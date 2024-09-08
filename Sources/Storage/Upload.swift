import Foundation
import HTTPTypes

extension Storage {
  public func upload(
    backetName: String,
    filePath: String,
    data: Data,
    contentType: String
  ) async throws -> Item {
    let filePath = percentEncode(filePath)
    let queries = [
      "uploadType": "resumable",
      "name": filePath,
    ]
    let path = "v0/b/\(backetName)/o/\(filePath)?\(queries.map { [$0.key, $0.value].joined(separator: "=") }.joined(separator: "&"))"

    let endpoint = URL(string: "\(baseUrl.absoluteString)\(path)")!

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [
        .contentType: contentType,
        .contentLength: data.count.description
      ]
    )
    
    let (data, _) = try await httpClient.execute(for: request, from: data)

    let item = try JSONDecoder().decode(Item.self, from: data)
    
    return item
  }
}
