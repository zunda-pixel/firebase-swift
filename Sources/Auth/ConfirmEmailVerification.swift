import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var oobCode: String
  }

  /// Confirm email verification
  /// You can confirm an email verification code by issuing an HTTP POST request to the Auth setAccountInfo endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-confirm-email-verification
  /// - Parameter oobCode: The action code sent to user's email for email verification.
  /// - Returns: ``ConfirmEmailVerificationResponse``
  @discardableResult
  public func confirmEmailVerification(
    oobCode: String
  ) async throws -> ConfirmEmailVerificationResponse {
    let path = "accounts:update"
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

    let response = try self.decode(ConfirmEmailVerificationResponse.self, from: data)

    return response
  }
}

public struct ConfirmEmailVerificationResponse: Sendable, Hashable, Codable {
  public var email: String
  public var displayName: String?
  public var photoUrl: URL?
  public var passwordHash: String
  public var providerUserInfo: [ProviderUserInfo]
  public var emailVerified: Bool
}
