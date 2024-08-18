import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var idToken: String
    var password: String
    var returnSecureToken: Bool = true
  }

  /// Change password
  /// You can change a user's password by issuing an HTTP POST request to the Auth setAccountInfo endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-change-password
  /// - Parameters:
  ///   - idToken: The email for the user to create.
  ///   - newPassword: The user's new password.
  /// - Returns: ``UpdatePasswordResponse``
  @discardableResult
  public func updatePassword(
    idToken: String,
    newPassword: String
  ) async throws -> UpdatePasswordResponse {
    let path = "v3/relyingparty/setAccountInfo"
    let endpoint =
      baseUrlV3
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(
      idToken: idToken,
      password: newPassword
    )
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(UpdatePasswordResponse.self, from: data)

    return response
  }
}

public struct UpdatePasswordResponse: Sendable, Hashable, Codable {
  public var localId: String
  public var email: String
  public var idToken: String
  public var providerUserInfo: [ProviderUserInfo]
  public var refreshToken: String
  public var expiresIn: Int
  public var passwordHash: String
  public var emailVerified: Bool
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.localId = try container.decode(String.self, forKey: .localId)
    self.email = try container.decode(String.self, forKey: .email)
    self.idToken = try container.decode(String.self, forKey: .idToken)
    self.providerUserInfo = try container.decode([ProviderUserInfo].self, forKey: .providerUserInfo)
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    let expiresIntString = try container.decode(String.self, forKey: .expiresIn)
    self.expiresIn = Int(expiresIntString)!
    self.passwordHash = try container.decode(String.self, forKey: .passwordHash)
    self.emailVerified = try container.decode(Bool.self, forKey: .emailVerified)
  }
}
