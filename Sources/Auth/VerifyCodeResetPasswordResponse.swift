import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var oobCode: String
    var newPassword: String
  }
  /// Verify password reset code
  /// You can verify a password reset code by issuing an HTTP POST request to the Auth resetPassword endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-verify-password-reset-code
  /// - Parameter oobCode: The email action code sent to the user's email for resetting the password.
  /// - Parameter newPassword:A Firebase Auth new password for the user.
  /// - Returns: ``VerifyResetPasswordCodeResponse``
  @discardableResult
  public func verifyCodeResetPassword(
    oobCode: String,
    newPassword: String
  ) async throws -> VerifyCodeResetPasswordResponse {
    let path = "v3/relyingparty/resetPassword"
    let endpoint =
    baseUrlV3
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(
      oobCode: oobCode,
      newPassword: newPassword
    )
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(VerifyCodeResetPasswordResponse.self, from: data)

    return response
  }
}

public struct VerifyCodeResetPasswordResponse: Sendable, Hashable, Codable {
  public var requestType: String
  public var email: String?
}
