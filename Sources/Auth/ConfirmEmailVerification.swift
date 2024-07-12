import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var oobCode: String
  }

  public func confirmEmailVerification(oobCode: String) async throws -> ConfirmEmailVerificationResponse {
    let path = "accounts:update"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])
    
    let body = Body(oobCode: oobCode)
    let bodyData = try! JSONEncoder().encode(body)
        
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )
    
    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)
    
    let response = try JSONDecoder().decode(ConfirmEmailVerificationResponse.self, from: data)
    
    return response
  }
  
  public struct ConfirmEmailVerificationResponse: Sendable, Hashable, Codable {
    public var kind: String
    public var email: String
    public var displayName: String?
    public var photoUrl: String?
    public var passwordHash: String
    public var providerUserInfo: [ProviderUserInfo]
    public var emailVerified: Bool
  }
}

