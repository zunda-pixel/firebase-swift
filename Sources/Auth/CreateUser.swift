import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var email: String
    var password: String
    var returnSecureToken: Bool = true
  }

  /// Sign up with email / password
  /// You can create a new email and password user by issuing an HTTP POST request to the Auth signupNewUser endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-create-email-password
  /// - Parameters:
  ///   - email: The email for the user to create.
  ///   - password: The password for the user to create.
  /// - Returns: ``SignUpResponse``
  @discardableResult
  public func createUser(
    email: String,
    password: String
  ) async throws -> CreateUserResponse {
    let path = "v3/relyingparty/signupNewUser"
    let endpoint =
    baseUrlV3
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(email: email, password: password)
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(CreateUserResponse.self, from: data)

    return response
  }
}

public struct CreateUserResponse: Sendable, Hashable, Codable {
  public var idToken: String
  public var email: String
  public var expiresIn: Int
  public var refreshToken: String
  public var localId: String

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.idToken = try container.decode(String.self, forKey: .idToken)
    self.email = try container.decode(String.self, forKey: .email)
    let expiresInString = try container.decode(String.self, forKey: .expiresIn)
    self.expiresIn = Int(expiresInString)!
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    self.localId = try container.decode(String.self, forKey: .localId)
  }
}
