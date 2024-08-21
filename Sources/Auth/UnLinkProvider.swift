import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var idToken: String
    var deleteProvider: [String]
  }

  /// Unlink provider
  /// You can unlink a provider from a current user by issuing an HTTP POST request to the Auth setAccountInfo endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-unlink-provider
  /// - Parameters:
  ///   - idToken: The Firebase ID token of the account.
  ///   - deleteProviders: The list of provider IDs to unlink, eg: 'google.com', 'password', etc.
  /// - Returns: ``UnLinkProviderResponse``
  @discardableResult
  public func unLinkEmail(
    idToken: String,
    deleteProviders: [String]
  ) async throws -> UnLinkProviderResponse {
    let path = "v3/relyingparty/setAccountInfo"
    let endpoint =
      baseUrlV3
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(idToken: idToken, deleteProvider: deleteProviders)
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(UnLinkProviderResponse.self, from: data)

    return response
  }
}

public struct UnLinkProviderResponse: Sendable, Hashable, Codable {
  public var localId: String
  public var email: String
  public var displayName: String?
  public var photoUrl: URL?
  public var passwordHash: String?
  public var providerUserInfo: [ProviderUserInfo]
  public var emailVerified: Bool

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: UnLinkProviderResponse.CodingKeys.self)
    self.localId = try container.decode(String.self, forKey: .localId)
    self.email = try container.decode(String.self, forKey: .email)
    self.displayName = try container.decodeIfPresent(String.self, forKey: .displayName)
    self.photoUrl = try container.decodeIfPresent(URL.self, forKey: .photoUrl)
    self.passwordHash = try container.decodeIfPresent(String.self, forKey: .passwordHash)
    self.providerUserInfo =
      try container.decodeIfPresent([ProviderUserInfo].self, forKey: .providerUserInfo) ?? []
    self.emailVerified = try container.decode(Bool.self, forKey: .emailVerified)
  }
}
