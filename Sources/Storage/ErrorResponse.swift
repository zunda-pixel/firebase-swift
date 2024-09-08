import Foundation

public struct ErrorResponse: Error, Codable, Hashable, Sendable {
  public var code: Int
  public var message: String
}

struct ErrorsResponse: Codable, Hashable, Sendable {
  var error: ErrorResponse
}
