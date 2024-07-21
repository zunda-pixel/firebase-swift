import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var grantType: String = "refresh_token"
    var refreshToken: String

    private enum CodingKeys: String, CodingKey {
      case grantType = "grant_type"
      case refreshToken = "refresh_token"
    }
  }

  /// Exchange a refresh token for an ID token
  /// You can refresh a Firebase ID token by issuing an HTTP POST request to the securetoken.googleapis.com endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-refresh-token
  /// - Parameter refreshToken: A Firebase Auth refresh token.
  /// - Returns: ``RefreshTokenResponse``
  public func refreshToken(refreshToken: String) async throws -> RefreshTokenResponse {
    let path = "token"
    let endpoint =
      baseUrlV1
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(refreshToken: refreshToken)
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(RefreshTokenResponse.self, from: data)

    return response
  }
}

public struct RefreshTokenResponse: Sendable, Hashable, Codable {
  public var expiresIn: Int
  public var tokenType: String
  public var refreshToken: String
  public var idToken: String
  public var userId: String
  public var projectId: String

  private enum CodingKeys: String, CodingKey {
    case expiresIn = "expires_in"
    case tokenType = "token_type"
    case refreshToken = "refresh_token"
    case idToken = "id_token"
    case userId = "user_id"
    case projectId = "project_id"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: RefreshTokenResponse.CodingKeys.self)
    let expiresInString = try container.decode(String.self, forKey: .expiresIn)
    self.expiresIn = Int(expiresInString)!
    self.tokenType = try container.decode(String.self, forKey: .tokenType)
    self.refreshToken = try container.decode(String.self, forKey: .refreshToken)
    self.idToken = try container.decode(String.self, forKey: .idToken)
    self.userId = try container.decode(String.self, forKey: .userId)
    self.projectId = try container.decode(String.self, forKey: .projectId)
  }
}
