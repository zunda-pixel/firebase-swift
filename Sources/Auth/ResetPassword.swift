import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var oobCode: String
    var password: String
  }

  /// Confirm password reset
  /// You can apply a password reset change by issuing an HTTP POST request to the Auth resetPassword endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-confirm-reset-password
  /// - Parameters:
  ///   - oobCode: The email action code sent to the user's email for resetting the password.
  ///   - password: The user's new password.
  /// - Returns: ``ResetPasswordResponse``
  @discardableResult
  public func resetPassword(
    oobCode: String,
    newPassword password: String
  ) async throws -> ResetPasswordResponse {
    let path = "v1/accounts:resetPassword"
    let endpoint =
      baseUrlV1
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(oobCode: oobCode, password: password)
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(ResetPasswordResponse.self, from: data)

    return response
  }
}

public struct ResetPasswordResponse: Sendable, Hashable, Codable {
  public var requestType: String
  public var email: String
}
