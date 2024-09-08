import Foundation

extension Storage {
  public func contentUrl(
    bucket: String,
    itemPath: String,
    downloadTokens: String
  ) -> URL {
    let bucket = self.percentEncode(bucket)
    let itemPath = self.percentEncode(itemPath)
    let queries: [String: String] = [
      "alt": "media",
      "token": downloadTokens,
    ]
    let path =
      "v0/b/\(bucket)/o/\(itemPath)?\(queries.map { [$0.key, $0.value].joined(separator: "=") }.joined(separator: "&"))"

    return URL(string: "\(baseUrl.absoluteString)\(path)")!
  }

  public func contentUrl(item: Item) -> URL {
    return self.contentUrl(
      bucket: item.bucket,
      itemPath: item.name,
      downloadTokens: item.downloadTokens
    )
  }
}
