import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Client {
  /// Link Provider
  /// You can sign in a user with an OAuth credential by issuing an HTTP POST request to the Auth verifyAssertion endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-sign-in-with-oauth-credential
  /// - Parameters:
  ///   - idToken: The Firebase ID token of the account.
  ///   - requestUri: The URI to which the IDP redirects the user back.
  ///   - provider: The Provider ID which issues the credential.
  /// - Returns: ``OAuthResponse``
  @discardableResult
  public func linkProvider(
    idToken: String,
    requestUri: URL,
    provider: OAuthProvider
  ) async throws -> OAuthResponse {
    try await self.createUserOrGetOAuth(
      idToken: idToken,
      requestUri: requestUri,
      provider: provider
    )
  }
}
