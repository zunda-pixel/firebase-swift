import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Client {
  private struct Body: Sendable, Hashable, Codable {
    var idToken: String
  }

  /// Get user data
  /// You can get a user's data by issuing an HTTP POST request to the Auth getAccountInfo endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-get-account-info
  /// - Parameter idToken: The Firebase ID token of the account.
  /// - Returns: ``UserResponse``
  public func user(idToken: String) async throws -> UserResponse {
    let path = "v3/relyingparty/getAccountInfo"
    let endpoint =
      baseUrl
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(idToken: idToken)
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(UsersResponse.self, from: data)

    return response.users.first!
  }
}

public struct UsersResponse: Sendable, Hashable, Codable {
  public var users: [UserResponse]
}

public struct UserResponse: Sendable, Hashable, Codable {
  public var localId: String
  public var email: String?
  public var emailVerified: Bool?
  public var displayName: String?
  public var providerUserInfo: [ProviderUserInfo]
  public var photoUrl: URL?
  public var passwordHash: String?
  public var passwordUpdatedAt: Date?
  public var validSince: Date
  public var disabled: Bool?
  public var lastLoginAt: Date
  public var createdAt: Date
  public var customAuth: Bool?
  public var lastRefreshAt: Date

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: UserResponse.CodingKeys.self)
    self.localId = try container.decode(String.self, forKey: .localId)
    self.email = try container.decodeIfPresent(String.self, forKey: .email)
    self.emailVerified = try container.decodeIfPresent(Bool.self, forKey: .emailVerified)
    self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
    self.providerUserInfo = try container.decode([ProviderUserInfo].self, forKey: .providerUserInfo)
    self.photoUrl = try container.decodeIfPresent(URL.self, forKey: .photoUrl)
    self.passwordHash = try container.decodeIfPresent(String.self, forKey: .passwordHash)
    self.passwordUpdatedAt = try container.decodeIfPresent(Date.self, forKey: .passwordUpdatedAt)
    let validSinceString = try container.decode(String.self, forKey: .validSince)
    if let validSinceInterval = TimeInterval(validSinceString) {
      self.validSince = .init(timeIntervalSinceReferenceDate: validSinceInterval)
    } else {
      throw DecodingError.dataCorruptedError(
        forKey: .validSince,
        in: container,
        debugDescription: "\(validSinceString) is not TimeInterval format"
      )
    }
    self.disabled = try container.decodeIfPresent(Bool.self, forKey: .disabled)
    let lastLoginAtString = try container.decode(String.self, forKey: .lastLoginAt)
    if let lastLoginInterval = TimeInterval(lastLoginAtString) {
      self.lastLoginAt = .init(timeIntervalSince1970: lastLoginInterval / 1000)
    } else {
      throw DecodingError.dataCorruptedError(
        forKey: .lastLoginAt,
        in: container,
        debugDescription: "\(lastLoginAtString) is not TimeInterval format"
      )
    }
    let createdAtString = try container.decode(String.self, forKey: .createdAt)
    if let createdAtInterval = TimeInterval(createdAtString) {
      self.createdAt = .init(timeIntervalSince1970: createdAtInterval / 1000)
    } else {
      throw DecodingError.dataCorruptedError(
        forKey: .createdAt,
        in: container,
        debugDescription: "\(createdAtString) is not TimeInterval format"
      )
    }
    self.customAuth = try container.decodeIfPresent(Bool.self, forKey: .customAuth)
    let lastRefreshAt = try container.decode(String.self, forKey: .lastRefreshAt)
    self.lastRefreshAt = try Date(
      lastRefreshAt,
      strategy: Date.ISO8601FormatStyle(includingFractionalSeconds: true)
    )
  }
}
