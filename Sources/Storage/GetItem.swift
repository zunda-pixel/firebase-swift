import Foundation
import HTTPTypes

extension Storage {
  public func item(
    bucket: String,
    path itemPath: String
  ) async throws -> Item {
    let bucket = percentEncode(bucket)
    let itemPath = percentEncode(itemPath)
    let path = "v0/b/\(bucket)/o/\(itemPath)"

    let endpoint = URL(string: "\(baseUrl.absoluteString)\(path)")!

    let request = HTTPRequest(
      method: .get,
      url: endpoint
    )

    let (data, _) = try await httpClient.execute(for: request, from: nil)

    let item = try JSONDecoder().decode(Item.self, from: data)

    return item
  }
}
