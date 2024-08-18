import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Encodable {
    /// The URI to which the IDP redirects the user back.
    var requestUri: URL
    /// Contains the OAuth credential (an ID token or access token) and provider ID which issues the credential.
    var postBody: String {
      switch provider {
      case .github(let accessToken):
        "access_token=\(accessToken)&providerId=\(provider.identifider)"
      case .google(let idToken):
        "id_token=\(idToken)&providerId=\(provider.identifider)"
      }
    }

    var provider: OAuthProvider
    /// Whether or not to return an ID and refresh token. Should always be true.
    var returnSecureToken = true

    /// Whether to force the return of the OAuth credential on the following errors: FEDERATED_USER_ID_ALREADY_LINKED and EMAIL_EXISTS.
    var returnIdpCredential: Bool
    // autoCreate: Bool = true

    private enum CodingKeys: CodingKey {
      case requestUri
      case postBody
      case returnSecureToken
      case returnIdpCredential
    }

    func encode(to encoder: any Encoder) throws {
      var container = encoder.container(keyedBy: Body.CodingKeys.self)
      try container.encode(self.requestUri, forKey: .requestUri)
      try container.encode(self.postBody, forKey: .postBody)
      try container.encode(self.returnSecureToken, forKey: .returnSecureToken)
      try container.encode(self.returnIdpCredential, forKey: .returnIdpCredential)
    }
  }

  /// Sign in with OAuth credential
  /// You can sign in a user with an OAuth credential by issuing an HTTP POST request to the Auth verifyAssertion endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-sign-in-with-oauth-credential
  /// - Parameters:
  ///   - requestUri: The URI to which the IDP redirects the user back.
  ///   - provider: The Provider ID which issues the credential.
  ///   - accessToken: Access Token
  /// - Returns: ``OAuthResponse``
  @discardableResult
  public func createUserOrGetOAuth(
    requestUri: URL,
    provider: OAuthProvider
  ) async throws -> OAuthResponse {
    let path = "v3/relyingparty/verifyAssertion"
    let endpoint =
      baseUrlV3
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(
      requestUri: requestUri,
      provider: provider,
      returnSecureToken: true,
      returnIdpCredential: true
    )
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(OAuthResponse.self, from: data)

    return response
  }
}

public enum OAuthProvider: Sendable, Hashable, Codable {
  case github(accessToken: String)
  case google(id_token: String)

  public var identifider: String {
    switch self {
    case .github: "github.com"
    case .google(_): "google.com"
    }
  }
}

public struct OAuthResponse: Sendable, Hashable, Codable {
  public var federatedId: String
  public var providerId: String
  public var emailVerified: Bool
  public var fullName: String
  public var photoUrl: URL
  public var localId: String
  public var displayName: String
  public var idToken: String
  public var oauthAccessToken: String
  public var refreshToken: String
  public var expiresIn: Int
  public var screenName: String
  public var isNewUser: Bool

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.federatedId = try container.decode(String.self, forKey: .federatedId)
    self.providerId = try container.decode(String.self, forKey: .providerId)
    self.emailVerified = try container.decode(Bool.self, forKey: .emailVerified)
    self.fullName = try container.decode(String.self, forKey: .fullName)
    self.photoUrl = try container.decode(URL.self, forKey: .photoUrl)
    self.localId = try container.decode(String.self, forKey: .localId)
    self.displayName = try container.decode(String.self, forKey: .displayName)
    self.idToken = try container.decode(String.self, forKey: .idToken)
    self.oauthAccessToken = try container.decode(String.self, forKey: .oauthAccessToken)
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    let expiresInString = try container.decode(String.self, forKey: .expiresIn)
    self.expiresIn = Int(expiresInString)!
    self.screenName = try container.decode(String.self, forKey: .screenName)
    self.isNewUser = try container.decodeIfPresent(Bool.self, forKey: .isNewUser) ?? false
  }
}
