public struct ErrorResponse: Sendable, Hashable, Codable, Error {
  public var code: Int
  public var message: String
  public var status: String
}
