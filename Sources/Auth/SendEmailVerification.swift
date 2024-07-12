import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var requestType = "VERIFY_EMAIL"
    var idToken: String
  }

  public func sendEmailVerification(idToken: String, locale: String? = nil) async throws -> SendEmailVerificationResponse {
    let path = "accounts:sendOobCode"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    
    let body = Body(idToken: idToken)
    let bodyData = try! JSONEncoder().encode(body)
    
    var headerFields = HTTPFields([.init(name: .contentType, value: "application/json")])
    locale.map { headerFields.append(.init(name: .init("X-Firebase-Locale")!, value: $0)) }

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: headerFields
    )
    
    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)
    
    let response = try JSONDecoder().decode(SendEmailVerificationResponse.self, from: data)
    
    return response
  }
  
  public struct SendEmailVerificationResponse: Sendable, Hashable, Codable {
    public var kind: String
    public var email: String
  }
}
