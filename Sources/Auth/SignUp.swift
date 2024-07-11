import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  public func signUp(email: String, password: String) async throws -> SignUpResponse {
    let path = "accounts:signUp"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])
    
    struct Body: Sendable, Hashable, Codable {
      var email: String
      var password: String
      var returnSecureToken: Bool = true
    }
    
    let body = Body(email: email, password: password)
    let bodyData = try! JSONEncoder().encode(body)
    
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )
    
    let (data, _) = try await URLSession.shared.upload(for: request, from: bodyData)
    
    let response = try JSONDecoder().decode(SignUpResponse.self, from: data)
    
    return response
  }
  
  public struct SignUpResponse: Sendable, Hashable, Codable {
    public var kind: String
    public var idToken: String
    public var email: String
    public var expiresIn: Int
    public var refreshToken: String
    public var localId: String
    
    public init(from decoder: any Decoder) throws {
      let container: KeyedDecodingContainer<Auth.SignUpResponse.CodingKeys> = try decoder.container(keyedBy: Auth.SignUpResponse.CodingKeys.self)
      self.kind = try container.decode(String.self, forKey: .kind)
      self.idToken = try container.decode(String.self, forKey: .idToken)
      self.email = try container.decode(String.self, forKey: .email)
      let expiresInString = try container.decode(String.self, forKey: .expiresIn)
      self.expiresIn = Int(expiresInString)!
      self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
      self.localId = try container.decode(String.self, forKey: .localId)
    }
  }
}
