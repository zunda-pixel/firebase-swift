import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var returnSecureToken: Bool = true
  }
  
  /// Sign in anonymously
  /// You can sign in a user anonymously by issuing an HTTP POST request to the Auth signupNewUser endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-sign-in-anonymously
  /// - Returns: ``SignUpAnonymousResponse``
  public func signUpAnonymous() async throws -> SignUpAnonymousResponse {
    let path = "accounts:signUp"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body()
    let bodyData = try! JSONEncoder().encode(body)
    
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )
    
    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)
    
    let response = try JSONDecoder().decode(SignUpAnonymousResponse.self, from: data)
    
    return response
  }
  
  public struct SignUpAnonymousResponse: Sendable, Hashable, Codable {
    public var kind: String
    public var idToken: String
    public var expiresIn: Int
    public var refreshToken: String
    public var localId: String
    
    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<Auth.SignUpAnonymousResponse.CodingKeys> = try decoder.container(keyedBy: Auth.SignUpAnonymousResponse.CodingKeys.self)
      self.kind = try container.decode(String.self, forKey: .kind)
      self.idToken = try container.decode(String.self, forKey: .idToken)
      let expiresInString = try container.decode(String.self, forKey: .expiresIn)
      self.expiresIn = Int(expiresInString)!
      self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
      self.localId = try container.decode(String.self, forKey: .localId)
    }
  }
}
