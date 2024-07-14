import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var idToken: String
    var email: String
    var password: String
    var returnSecureToken = true
  }
  
  /// Link with email/password
  /// You can link an email/password to a current user by issuing an HTTP POST request to the Auth setAccountInfo endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-link-with-email-password
  /// - Parameters:
  ///   - idToken: The Firebase ID token of the account you are trying to link the credential to.
  ///   - email: The email to link to the account.
  ///   - password: The new password of the account.
  /// - Returns: ``LinkEmailResponse``
  public func linkEmail(idToken: String, email: String, password: String) async throws -> LinkEmailResponse {
    let path = "accounts:update"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])
    
    let body = Body(idToken: idToken, email: email, password: password)
    let bodyData = try! JSONEncoder().encode(body)
    
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )
    
    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)
    
    let response = try self.decode(LinkEmailResponse.self, from: data)
    
    return response
  }
}

public struct LinkEmailResponse: Sendable, Hashable, Codable {
  public var localId: String
  public var email: String
  public var displayName: String?
  public var photoUrl: URL?
  public var passwordHash: String
  public var providerUserInfo: [ProviderUserInfo]
  public var emailVerified: Bool
  public var idToken: String
  public var refreshToken: String
  public var expiresIn: Int
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: LinkEmailResponse.CodingKeys.self)
    self.localId = try container.decode(String.self, forKey: .localId)
    self.email = try container.decode(String.self, forKey: .email)
    self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
    self.photoUrl = try container.decodeIfPresent(URL.self, forKey: .photoUrl)
    self.passwordHash = try container.decode(String.self, forKey: .passwordHash)
    self.providerUserInfo = try container.decode([ProviderUserInfo].self, forKey: .providerUserInfo)
    self.emailVerified = try container.decode(Bool.self, forKey: .emailVerified)
    self.idToken = try container.decode(String.self, forKey: .idToken)
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    let expiresInString = try container.decode(String.self, forKey: .expiresIn)
    self.expiresIn = Int(expiresInString)!
  }
}
