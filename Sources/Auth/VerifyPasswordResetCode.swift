import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var oobCode: String
  }
  /// Verify password reset code
  /// You can verify a password reset code by issuing an HTTP POST request to the Auth resetPassword endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-verify-password-reset-code
  /// - Parameter oobCode: The email action code sent to the user's email for resetting the password.
  /// - Returns: ``VerifyResetPasswordCodeResponse``
  @discardableResult
  public func verifyResetPasswordCode(
    oobCode: String
  ) async throws -> VerifyResetPasswordCodeResponse {
    let path = "v1/accounts:resetPassword"
    let endpoint =
      baseUrlV1
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

    let response = try self.decode(VerifyResetPasswordCodeResponse.self, from: data)

    return response
  }
}

public struct VerifyResetPasswordCodeResponse: Sendable, Hashable, Codable {
  public var requestType: String
  public var email: String?
}
