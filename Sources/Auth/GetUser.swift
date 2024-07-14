import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var idToken: String
  }
  
  /// Get user data
  /// You can get a user's data by issuing an HTTP POST request to the Auth getAccountInfo endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-get-account-info
  /// - Parameter idToken: The Firebase ID token of the account.
  /// - Returns: ``UserResponse``
  public func user(idToken: String) async throws -> UserResponse {
    let path = "accounts:lookup"
    let endpoint = baseURL
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
  public var email: String
  public var emailVerified: Bool
  public var displayName: String?
  public var providerUserInfo: [ProviderUserInfo]
  public var photoUrl: URL?
  public var passwordHash: String
  public var passwordUpdatedAt: Date
  public var validSince: Date
  public var disabled: Bool?
  public var lastLoginAt: Date
  public var createdAt: Date
  public var customAuth: Bool?
  public var lastRefreshAt: Date
  
  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: UserResponse.CodingKeys.self)
    self.localId = try container.decode(String.self, forKey: .localId)
    self.email = try container.decode(String.self, forKey: .email)
    self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
    self.photoUrl = try container.decodeIfPresent(URL.self, forKey: .photoUrl)
    self.passwordHash = try container.decode(String.self, forKey: .passwordHash)
    self.providerUserInfo = try container.decode([ProviderUserInfo].self, forKey: .providerUserInfo)
    self.emailVerified = try container.decode(Bool.self, forKey: .emailVerified)
    self.passwordHash = try container.decode(String.self, forKey: .passwordHash)
    self.passwordUpdatedAt = try container.decode(Date.self, forKey: .passwordUpdatedAt)
    let validSinceString = try container.decode(String.self, forKey: .validSince)
    self.validSince = .init(timeIntervalSinceReferenceDate: TimeInterval(validSinceString)!)
    self.disabled = try container.decodeIfPresent(Bool.self, forKey: .disabled)
    let lastLoginAtString = try container.decode(String.self, forKey: .lastLoginAt)
    self.lastLoginAt = .init(timeIntervalSinceReferenceDate: TimeInterval(lastLoginAtString)!)
    let createdAtString = try container.decode(String.self, forKey: .createdAt)
    self.createdAt = .init(timeIntervalSinceReferenceDate: TimeInterval(createdAtString)!)
    self.customAuth = try container.decodeIfPresent(Bool.self, forKey: .customAuth)
    let lastRefreshAtString = try container.decode(String.self, forKey: .lastRefreshAt)
    let formatter = ISO8601DateFormatter()
    formatter.formatOptions.insert(.withFractionalSeconds)
    self.lastRefreshAt = formatter.date(from: lastRefreshAtString)!
  }
}
