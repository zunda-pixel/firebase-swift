import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Client {
  private struct Body: Sendable, Hashable, Codable {
    var idToken: String
    var newEmail: String
    var requestType: String = "VERIFY_AND_CHANGE_EMAIL"
  }

  /// Send Email to Update Email
  /// - Parameters:
  ///   - idToken: The Firebase ID token of the user to update email.
  ///   - newEmail: The new Email of the account.
  /// - Returns: ``SendEmailToUpdateEmailResponse``
  @discardableResult
  public func sendEmailToUpdateEmail(
    idToken: String,
    newEmail: String
  ) async throws -> SendEmailToUpdateEmailResponse {
    let path = "v3/relyingparty/getOobConfirmationCode"
    let endpoint =
      baseUrl
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(
      idToken: idToken,
      newEmail: newEmail
    )

    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(SendEmailToUpdateEmailResponse.self, from: data)

    return response
  }
}

public struct SendEmailToUpdateEmailResponse: Sendable, Hashable, Codable {
  public var email: String
}
