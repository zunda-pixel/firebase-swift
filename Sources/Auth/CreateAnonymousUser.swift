import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Client {
  private struct Body: Sendable, Hashable, Codable {
    var returnSecureToken: Bool = true
  }

  /// Sign in anonymously
  /// You can sign in a user anonymously by issuing an HTTP POST request to the Auth signupNewUser endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-sign-in-anonymously
  /// - Returns: ``AnonymousUser``
  @discardableResult
  public func createAnonymousUser() async throws -> AnonymousUser {
    let path = "v3/relyingparty/signupNewUser"
    let endpoint =
      baseUrl
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body()
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(AnonymousUser.self, from: data)

    return response
  }
}

public struct AnonymousUser: Sendable, Hashable, Codable {
  public var idToken: String
  public var expiresIn: Int
  public var refreshToken: String
  public var localId: String

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.idToken = try container.decode(String.self, forKey: .idToken)
    let expiresInString = try container.decode(String.self, forKey: .expiresIn)
    if let expiresIn = Int(expiresInString) {
      self.expiresIn = expiresIn
    } else {
      throw DecodingError.dataCorruptedError(
        forKey: .expiresIn,
        in: container,
        debugDescription: "\(expiresInString) is not a valid Int."
      )
    }

    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    self.localId = try container.decode(String.self, forKey: .localId)
  }
}
