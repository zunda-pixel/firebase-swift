import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var requestType = "PASSWORD_RESET"
    var email: String
  }
  
  /// Send password reset email
  /// You can send a password reset email by issuing an HTTP POST request to the Auth getOobConfirmationCode endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-send-password-reset-email
  /// - Parameters:
  ///   - email: User's email address.
  ///   - locale: The language code corresponding to the user's locale. Passing this will localize the password reset email sent to the user.
  /// - Returns: ``SendEmailToResetPasswordResponse``
  public func sendEmailToResetPassword(email: String, locale: String? = nil) async throws -> SendEmailToResetPasswordResponse {
    let path = "accounts:sendOobCode"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])
    
    let body = Body(email: email)
    let bodyData = try! JSONEncoder().encode(body)
    
    var headerFields: HTTPFields = [.contentType: "application/json"]
    locale.map { headerFields.append(.init(name: .init("X-Firebase-Locale")!, value: $0)) }

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: headerFields
    )
    
    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)
    
    let response = try self.decode(SendEmailToResetPasswordResponse.self, from: data)
    
    return response
  }
}

public struct SendEmailToResetPasswordResponse: Sendable, Hashable, Codable {
  public var email: String
}
