import Foundation

#if canImport(FoundationNetworking)
  extension URL {
    public func appending(path: String, isDirectory: Bool? = nil) -> URL {
      if let isDirectory {
        self.appendingPathComponent(path, isDirectory: isDirectory)
      } else {
        self.appendingPathComponent(path)
      }
    }

    public func appending(queryItems: [URLQueryItem]) -> URL {
      var components = URLComponents(url: self, resolvingAgainstBaseURL: false)!
      var newQueryItems = components.queryItems ?? []
      newQueryItems.append(contentsOf: queryItems)
      components.queryItems = newQueryItems
      return components.url!
    }
  }
#endif
