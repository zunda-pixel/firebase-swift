import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Firestore {
  public func documents<Model: Codable>(
    databaseId: String,
    documentId: String,
    as: Model.Type,
    decoder: JSONDecoder = JSONDecoder()
  ) async throws -> [Document<Model>] {
    let path = "v1/projects/\(self.projectName)/databases/\(databaseId)/documents/\(documentId)"
    let endpoint =
      baseUrl
      .appending(path: path)

    let request = HTTPRequest(
      method: .get,
      url: endpoint,
      headerFields: [
        .contentType: "application/json",
        .authorization: "Bearer \(self.oauthApiKey)",
      ]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: nil)

    guard let keyValues = try JSONSerialization.jsonObject(with: data) as? [String: [AnyHashable]]
    else {
      throw FirestoreDecodingError.dataCorrupted(
        [String: [AnyHashable]].self,
        debugDescription: "\(data) Value type dataCorrupted"
      )
    }
    guard let documents = keyValues["documents"] else {
      throw FirestoreDecodingError.missingKey(key: "documents")
    }

    return try documents.map { document in
      guard let valuesData = document as? [String: AnyHashable] else {
        throw FirestoreDecodingError.dataCorrupted(
          [String: AnyHashable].self,
          debugDescription: "\(document) Value type dataCorrupted"
        )
      }
      guard let fields = valuesData["fields"] else {
        throw FirestoreDecodingError.missingKey(key: "fields")
      }
      guard let fieldsKeyValue = fields as? [String: [String: AnyHashable]] else {
        throw FirestoreDecodingError.dataCorrupted(
          [String: [String: AnyHashable]].self,
          debugDescription: "\(fields) Value type dataCorrupted"
        )
      }
      let fieldsData = try FirestoreDataConverter.removeNestedValueKey(keyValues: fieldsKeyValue)
      let internalDocument = try self.decode(
        InternalDocument.self,
        from: try JSONSerialization.data(withJSONObject: document)
      )
      let model = try decoder.decode(Model.self, from: fieldsData)
      return Document<Model>(
        name: internalDocument.name,
        model: model,
        createTime: internalDocument.createTime,
        updateTime: internalDocument.updateTime
      )
    }
  }
}

private struct Documents: Decodable {
  var documents: [InternalDocument]
}

private struct InternalDocument: Decodable {
  var name: String
  var createTime: Date
  var updateTime: Date

  enum CodingKeys: CodingKey {
    case name
    case createTime
    case updateTime
  }

  init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let name = try container.decode(URL.self, forKey: .name)
    self.name = name.lastPathComponent

    let formatter = ISO8601DateFormatter()
    formatter.formatOptions.insert(.withFractionalSeconds)
    let createTime = try container.decode(String.self, forKey: .createTime)
    if let createTime = formatter.date(from: createTime) {
      self.createTime = createTime
    } else {
      throw DecodingError.dataCorrupted(
        .init(
          codingPath: [CodingKeys.createTime],
          debugDescription: "Invalid date format: \(createTime)"
        ))
    }
    let updateTime = try container.decode(String.self, forKey: .updateTime)
    if let updateTime = formatter.date(from: updateTime) {
      self.updateTime = updateTime
    } else {
      throw DecodingError.dataCorrupted(
        .init(
          codingPath: [CodingKeys.updateTime],
          debugDescription: "Invalid date format: \(updateTime)"
        ))
    }
  }
}

public struct Document<Model: Decodable> {
  public var name: String
  public var model: Model
  public var createTime: Date
  public var updateTime: Date
}
