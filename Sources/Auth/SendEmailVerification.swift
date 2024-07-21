import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var requestType = "VERIFY_EMAIL"
    var idToken: String
  }

  /// Send email verification
  /// You can send an email verification for the current user by issuing an HTTP POST request to the Auth getOobConfirmationCode endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-send-email-verification
  /// - Parameters:
  ///   - idToken: The Firebase ID token of the user to verify.
  ///   - locale: The language code corresponding to the user's locale. Passing this will localize the email verification sent to the user.
  /// - Returns: ``SendEmailVerificationResponse``
  public func sendEmailVerification(
    idToken: String,
    locale: String? = nil
  ) async throws -> SendEmailVerificationResponse {
    let path = "accounts:sendOobCode"
    let endpoint =
      baseUrlV1
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(idToken: idToken)
    let bodyData = try! JSONEncoder().encode(body)

    var headerFields: HTTPFields = [.contentType: "application/json"]
    locale.map { headerFields.append(.init(name: .init("X-Firebase-Locale")!, value: $0)) }

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: headerFields
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(SendEmailVerificationResponse.self, from: data)

    return response
  }
}

public struct SendEmailVerificationResponse: Sendable, Hashable, Codable {
  public var email: String
}
