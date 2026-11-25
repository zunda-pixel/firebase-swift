import Auth
import Foundation
import HTTPClient
import HTTPTypes
import Testing

private struct StubHTTPClient: HTTPClientProtocol, Hashable {
  func execute(for request: HTTPRequest, from body: Data?) async throws -> (Data, HTTPResponse) {
    #expect(request.method == .post)
    #expect(request.path == "/identitytoolkit/v3/relyingparty/signupNewUser?key=test-key")
    #expect(request.headerFields[.contentType] == "application/json")
    let payload = try #require(body)
    #expect(
      try JSONDecoder().decode([String: Bool].self, from: payload) == ["returnSecureToken": true])

    let response = """
      {"idToken":"test-id-token","expiresIn":"3600","refreshToken":"test-refresh-token","localId":"test-user"}
      """
    return (Data(response.utf8), HTTPResponse(status: .ok))
  }
}

@Suite
struct OfflineTests {
  @Test
  func anonymousSignIn() async throws {
    let client = AuthClient(apiKey: "test-key", httpClient: StubHTTPClient())

    let user = try await client.createAnonymousUser()

    #expect(user.localId == "test-user")
    #expect(user.expiresIn == 3600)
  }
}
