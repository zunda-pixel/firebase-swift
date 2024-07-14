import Foundation
import HTTPTypes
import HTTPTypesFoundation

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension URLSession: @retroactive @unchecked Sendable {}

extension URLSession: HTTPClientProtocol {
  public func execute(
    for request: HTTPRequest,
    from body: Data?
  ) async throws -> (Data, HTTPResponse) {
    if let body {
      try await self.upload(for: request, from: body)
    } else {
      try await self.data(for: request)
    }
  }
}

extension HTTPClientProtocol where Self == URLSession {
  public static func urlSession(_ urlSession: Self) -> Self {
    return urlSession
  }
}
