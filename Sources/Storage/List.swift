import Foundation
import HTTPTypes

extension Storage {
  /// Get Lists
  /// - Parameters:
  ///   - bucket: Bucket Name
  ///   - directoryPath: Directory Path
  ///   - maxResults: 1 < maxResults < 1000
  ///   - pageToken: Next Page Token
  /// - Returns: ``ListResponse``
  public func list(
    bucket: String,
    directoryPath: String,
    maxResults: Int? = nil,
    pageToken: String? = nil
  ) async throws -> ListResponse {
    let bucket = percentEncode(bucket)
    let directoryPath = percentEncode(directoryPath)

    let queries: [String: String] = [
      "delimiter": "/",
      "prefix": directoryPath,
      "maxResults": maxResults?.description,
      "pageToken": pageToken.map {
        $0.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!
      },
    ].compactMapValues { $0 }

    let path: String =
      "v0/b/\(bucket)/o?\(queries.map { [$0, $1].joined(separator: "=") }.joined(separator: "&"))"

    let endpoint = URL(string: "\(baseUrl.absoluteString)\(path)")!

    let request = HTTPRequest(
      method: .get,
      url: endpoint
    )

    let (data, _) = try await httpClient.execute(for: request, from: nil)

    let item = try JSONDecoder().decode(ListResponse.self, from: data)

    return item
  }
}

public struct ListResponse: Codable, Hashable, Sendable {
  public struct Item: Codable, Hashable, Sendable {
    public var bucket: String
    public var name: String
  }

  public var prefixes: [String]
  public var items: [Item]
  public var nextPageToken: String?
}
