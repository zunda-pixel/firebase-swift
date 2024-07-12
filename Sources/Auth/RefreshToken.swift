import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var grantType: String = "refresh_token"
    var refreshToken: String
    
    private enum CodingKeys: String, CodingKey {
      case grantType = "grant_type"
      case refreshToken = "refresh_token"
    }
  }

  public func refreshToken(refreshToken: String) async throws -> RefreshTokenResponse {
    let path = "token"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])
    
    let body = Body(refreshToken: refreshToken)
    let bodyData = try! JSONEncoder().encode(body)
    
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )
    
    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)
    
    let response = try JSONDecoder().decode(RefreshTokenResponse.self, from: data)
    
    return response
  }
  
  public struct RefreshTokenResponse: Sendable, Hashable, Codable {
    public var expiresIn: Int
    public var tokenType: String
    public var refreshToken: String
    public var idToken: String
    public var userId: String
    public var projectId: String
    
    private enum CodingKeys: String, CodingKey {
      case expiresIn = "expires_in"
      case tokenType = "token_type"
      case refreshToken = "refresh_token"
      case idToken = "id_token"
      case userId = "user_id"
      case projectId = "project_id"
    }
    
    public init(from decoder: any Decoder) throws {
      let container = try decoder.container(keyedBy: Auth<HTTPClient>.RefreshTokenResponse.CodingKeys.self)
      let expiresInString = try container.decode(String.self, forKey: Auth<HTTPClient>.RefreshTokenResponse.CodingKeys.expiresIn)
      self.expiresIn = Int(expiresInString)!
      self.tokenType = try container.decode(String.self, forKey: Auth<HTTPClient>.RefreshTokenResponse.CodingKeys.tokenType)
      self.refreshToken = try container.decode(String.self, forKey: Auth<HTTPClient>.RefreshTokenResponse.CodingKeys.refreshToken)
      self.idToken = try container.decode(String.self, forKey: Auth<HTTPClient>.RefreshTokenResponse.CodingKeys.idToken)
      self.userId = try container.decode(String.self, forKey: Auth<HTTPClient>.RefreshTokenResponse.CodingKeys.userId)
      self.projectId = try container.decode(String.self, forKey: Auth<HTTPClient>.RefreshTokenResponse.CodingKeys.projectId)
    }
  }
}
