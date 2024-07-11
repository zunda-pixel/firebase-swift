import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  public func sendEmailToResetPassword(email: String, locale: String? = nil) async throws -> ResetPasswordResponse {
    let path = "accounts:sendOobCode"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    struct Body: Sendable, Hashable, Codable {
      var requestType = "PASSWORD_RESET"
      var email: String
    }
    
    let body = Body(email: email)
    let bodyData = try! JSONEncoder().encode(body)
    
    var headerFields: HTTPFields = [.contentType: "application/json"]
    locale.map { headerFields.append(.init(name: .init("X-Firebase-Locale")!, value: $0)) }

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: headerFields
    )
    
    let (data, _) = try await URLSession.shared.upload(for: request, from: bodyData)
    
    let response = try JSONDecoder().decode(ResetPasswordResponse.self, from: data)
    
    return response
  }
  
  public struct ResetPasswordResponse: Sendable, Hashable, Codable {
    public var kind: String
    public var email: String
  }
}
