import Foundation
import HTTPTypes

extension Client {
  @discardableResult
  public func upload(
    bucket: String,
    path itemPath: String,
    data: Data,
    contentType: String
  ) async throws -> Item {
    let bucket = percentEncode(bucket)
    let itemPath = percentEncode(itemPath)
    let queries = [
      "uploadType": "resumable",
      "name": itemPath,
    ]
    let path =
      "v0/b/\(bucket)/o/\(itemPath)?\(queries.map { [$0.key, $0.value].joined(separator: "=") }.joined(separator: "&"))"

    let endpoint = URL(string: "\(baseUrl.absoluteString)\(path)")!

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [
        .contentType: contentType,
        .contentLength: data.count.description,
      ]
    )

    let (data, _) = try await httpClient.execute(for: request, from: data)

    let item = try self.decode(Item.self, from: data)

    return item
  }
}
