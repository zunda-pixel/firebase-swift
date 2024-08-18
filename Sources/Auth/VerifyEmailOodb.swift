import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var oobCode: String
  }

  /// Verify Email oodCode
  /// You can confirm an email verification code by issuing an HTTP POST request to the Auth setAccountInfo endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-confirm-email-verification
  /// - Parameter oobCode: The action code sent to user's email for email verification.
  /// - Returns: ``VerifyEmailOodbCodeResponse``
  @discardableResult
  public func verifyEmailOobCode(
    oobCode: String
  ) async throws -> VerifyEmailOodbCodeResponse {
    let path = "v3/relyingparty/resetPassword"
    let endpoint =
      baseUrlV3
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

    let response = try self.decode(VerifyEmailOodbCodeResponse.self, from: data)

    return response
  }
}

public struct VerifyEmailOodbCodeResponse: Sendable, Hashable, Codable {
  public var email: String
  public var requestType: String
}
