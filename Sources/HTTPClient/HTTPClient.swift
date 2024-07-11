import HTTPTypes
import Foundation

public protocol HTTPClientProtocol: Sendable, Hashable {
  func execute(for request: HTTPRequest, from body: Data?) async throws -> (Data, HTTPResponse)
}
