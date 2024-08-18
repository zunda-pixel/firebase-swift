import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var email: String
    var password: String
    var returnSecureToken: Bool = true
  }
  
  /// Sign in with email / password
  /// You can sign in a user with an email and password by issuing an HTTP POST request to the Auth verifyPassword endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-sign-in-email-password
  /// - Parameters:
  ///   - email: The email the user is signing in with.
  ///   - password: The password for the account.
  /// - Returns: ``VerifyPasswordResponse``
  @discardableResult
  public func verifyPassword(
    email: String,
    password: String
  ) async throws -> VerifyPasswordResponse {
    let path = "v3/relyingparty/verifyPassword"
    let endpoint =
    baseUrlV3
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(
      email: email,
      password: password
    )

    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(VerifyPasswordResponse.self, from: data)

    return response
  }
}

public struct VerifyPasswordResponse: Sendable, Hashable, Codable {
  public var idToken: String
  public var email: String
  public var expiresIn: Int
  public var refreshToken: String
  public var localId: String
  public var registered: Bool
  public var displayName: String

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.idToken = try container.decode(String.self, forKey: .idToken)
    self.email = try container.decode(String.self, forKey: .email)
    let expiresInString = try container.decode(String.self, forKey: .expiresIn)
    self.expiresIn = Int(expiresInString)!
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    self.localId = try container.decode(String.self, forKey: .localId)
    self.registered = try container.decode(Bool.self, forKey: .registered)
    self.displayName = try container.decode(String.self, forKey: .displayName)
  }
}
