import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Client {
  /// Link with email/password
  /// You can link an email/password to a current user by issuing an HTTP POST request to the Auth setAccountInfo endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-link-with-email-password
  /// - Parameters:
  ///   - idToken: The Firebase ID token of the account you are trying to link the credential to.
  ///   - email: The email to link to the account.
  ///   - password: The new password of the account.
  /// - Returns: ``CreateUserResponse``
  @discardableResult
  public func linkEmail(
    idToken: String,
    email: String,
    password: String
  ) async throws -> CreateUserResponse {
    try await self.createUser(
      idToken: idToken,
      email: email,
      password: password
    )
  }
}
