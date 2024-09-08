import Foundation
import HTTPTypes

private struct Body: Codable, Sendable, Hashable {
  var cacheControl: String?
  var contentDisposition: String?
  var contentEncoding: String?
  var contentLanguage: String?
  var contentType: String?
  var customMetadata: [String: String]?

  private enum CodingKeys: String, CodingKey {
    case cacheControl
    case contentDisposition
    case contentEncoding
    case contentLanguage
    case contentType
    case customMetadata = "metadata"
  }
}

extension Storage {
  @discardableResult
  public func update(
    bucket: String,
    itemPath: String,
    md5Hash: String? = nil,
    cacheControl: String? = nil,
    contentDisposition: String? = nil,
    contentEncoding: String? = nil,
    contentLanguage: String? = nil,
    contentType: String? = nil,
    customMetadata: [String: String]? = nil
  ) async throws -> Item {
    let body = Body(
      cacheControl: cacheControl,
      contentDisposition: contentDisposition,
      contentEncoding: contentEncoding,
      contentLanguage: contentLanguage,
      contentType: contentType,
      customMetadata: customMetadata
    )

    let bodyData = try! JSONEncoder().encode(body)

    let bucket = percentEncode(bucket)
    let itemPath = percentEncode(itemPath)
    let path = "v0/b/\(bucket)/o/\(itemPath)"

    let endpoint = URL(string: "\(baseUrl.absoluteString)\(path)")!

    let request = HTTPRequest(
      method: .patch,
      url: endpoint,
      headerFields: [
        .contentType: "application/json; charset=UTF-8",
        .contentLength: bodyData.count.description,
      ]
    )

    let (data, _) = try await httpClient.execute(for: request, from: bodyData)

    let item = try JSONDecoder().decode(Item.self, from: data)

    return item
  }
}

extension Storage {
  @discardableResult
  public func update(
    item: Item,
    md5Hash: String? = nil,
    cacheControl: String? = nil,
    contentDisposition: String? = nil,
    contentEncoding: String? = nil,
    contentLanguage: String? = nil,
    contentType: String? = nil,
    customMetadata: [String: String]? = nil
  ) async throws -> Item {
    try await self.update(
      bucket: item.bucket,
      itemPath: item.name,
      cacheControl: cacheControl,
      contentDisposition: contentDisposition,
      contentEncoding: contentEncoding,
      contentLanguage: contentLanguage,
      contentType: contentType,
      customMetadata: customMetadata
    )
  }
}
