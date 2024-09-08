import Foundation

extension Storage {
  public func contentUrl(
    bucket: String,
    filePath: String,
    downloadTokens: String
  ) -> URL {
    let bucket = self.percentEncode(bucket)
    let filePath = self.percentEncode(filePath)
    let queries: [String: String] = [
      "alt": "media",
      "token": downloadTokens
    ]
    let path = "v0/b/\(bucket)/o/\(filePath)?\(queries.map { [$0.key, $0.value].joined(separator: "=") }.joined(separator: "&"))"
    
    return URL(string: "\(baseUrl.absoluteString)\(path)")!
  }
  
  public func contentUrl(item: Item) -> URL {
    return self.contentUrl(
      bucket: item.bucket,
      filePath: item.name,
      downloadTokens: item.downloadTokens
    )
  }
}
