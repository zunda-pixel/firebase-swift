public struct ErrorsResponse: Sendable, Hashable, Codable, Error {
  var code: Int
  var message: String
  var errors: [ErrorResponse]
}

public struct ErrorResponse: Sendable, Hashable, Codable {
  var message: String
  var domain: String
  var reason: String
}
