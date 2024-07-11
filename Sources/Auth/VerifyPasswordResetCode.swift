import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  public func verifyPasswordResetCode(oobCode: String) async throws -> VerifyPasswordResetCodeResponse {
    let path = "accounts:resetPassword"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    struct Body: Sendable, Hashable, Codable {
      var oobCode: String
    }
    
    let body = Body(oobCode: oobCode)
    let bodyData = try! JSONEncoder().encode(body)
    
    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )
    
    let (data, _) = try await URLSession.shared.upload(for: request, from: bodyData)
    
    let response = try JSONDecoder().decode(VerifyPasswordResetCodeResponse.self, from: data)
    
    return response
  }
  
  public struct VerifyPasswordResetCodeResponse: Sendable, Hashable, Codable {
    public var requestType: String
    public var email: String
  }
}
