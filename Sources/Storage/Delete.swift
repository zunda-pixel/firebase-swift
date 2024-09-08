import Foundation
import HTTPTypes

extension Storage {
  public func delete(
    bucket: String,
    filePath: String
  ) async throws {
    let bucket = percentEncode(bucket)
    let filePath = percentEncode(filePath)
    let path = "v0/b/\(bucket)/o/\(filePath)"

    let endpoint = URL(string: "\(baseUrl.absoluteString)\(path)")!

    let request = HTTPRequest(
      method: .delete,
      url: endpoint
    )

    let (data, response) = try await httpClient.execute(for: request, from: nil)

    if response.status.code != 204 {
      let response = try JSONDecoder().decode(ErrorsResponse.self, from: data)
      throw response.error
    }
  }
}

extension Storage {
  public func delete(item: Item) async throws {
    try await self.delete(
      bucket: item.bucket,
      filePath: item.name
    )
  }
}
