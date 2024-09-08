import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var token: String
    var returnSecureToken: Bool = true
  }

  /// Exchange custom token for an ID and refresh token
  /// You can exchange a custom Auth token for an ID and refresh token by issuing an HTTP POST request to the Auth verifyCustomToken endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-verify-custom-token
  @discardableResult
  public func verifyCustomToken(
    token: String
  ) async throws -> VerifyCustomTokenResponse {
    let path = "v3/relyingparty/verifyCustomToken"
    let endpoint =
      baseUrl
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(
      token: token
    )

    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(VerifyCustomTokenResponse.self, from: data)

    return response
  }
}

public struct VerifyCustomTokenResponse: Sendable, Hashable, Codable {
  public var idToken: String
  public var expiresIn: Int
  public var refreshToken: String

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.idToken = try container.decode(String.self, forKey: .idToken)
    let expiresInString = try container.decode(String.self, forKey: .expiresIn)
    self.expiresIn = Int(expiresInString)!
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
  }
}
