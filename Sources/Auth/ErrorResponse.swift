public struct ErrorsResponse: Sendable, Hashable, Codable, Error {
  public var code: Int
  public var message: String
  public var errors: [ErrorResponse]
}

public struct ErrorResponse: Sendable, Hashable, Codable {
  public var message: String
  public var domain: String
  public var reason: String
}
