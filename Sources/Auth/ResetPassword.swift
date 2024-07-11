import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  public func resetPassword(oobCode: String, newPassword password: String) async throws -> ResetPasswordResponse {
    let path = "accounts:resetPassword"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])
    
    struct Body: Sendable, Hashable, Codable {
      var oobCode: String
      var password: String
    }
    
    let body = Body(oobCode: oobCode, password: password)
    let bodyData = try! JSONEncoder().encode(body)
    
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )
    
    let (data, _) = try await URLSession.shared.upload(for: request, from: bodyData)
    
    let response = try JSONDecoder().decode(ResetPasswordResponse.self, from: data)
    
    return response
  }
  
  public struct ResetPasswordResponse: Sendable, Hashable, Codable {
    public var kind: String
    public var requestType: String
    public var email: String
  }
}
