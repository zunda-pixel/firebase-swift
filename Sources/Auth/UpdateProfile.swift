import Foundation
import HTTPTypes
import HTTPTypesFoundation

public enum DeleteAttribute: String, Sendable, Hashable, Codable {
  case displayName = "DISPLAY_NAME"
  case photoUrl = "PHOTO_URL"
}

public struct UpdateProfile: Sendable, Hashable, Codable {
  /// User's new display name.
  public var displayName: String?
  /// User's new photo url.
  public var photoUrl: URL?
  /// List of strings  List of attributes to delete, "DISPLAY_NAME" or "PHOTO_URL". This will nullify these values.
  public var deleteAttribute: [DeleteAttribute]
  /// Whether or not to return an ID and refresh token.
  public var returnSecureToken: Bool?

  public init(
    displayName: String? = nil,
    photoUrl: URL? = nil,
    deleteAttribute: [DeleteAttribute] = [],
    returnSecureToken: Bool? = nil
  ) {
    self.displayName = displayName
    self.photoUrl = photoUrl
    self.deleteAttribute = deleteAttribute
    self.returnSecureToken = returnSecureToken
  }
}

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var idToken: String
    var displayName: String?
    var photoUrl: URL?
    var deleteAttribute: [DeleteAttribute]
    var returnSecureToken: Bool?
  }

  /// Update profile
  /// You can update a user's profile (display name / photo URL) by issuing an HTTP POST request to the Auth setAccountInfo endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-update-profile
  /// - Parameter profile: ``UpdateProfile``
  /// - Returns: ``UpdateProfileResponse``
  @discardableResult
  public func updateProfile(
    idToken: String,
    profile: UpdateProfile
  ) async throws -> UpdateProfileResponse {
    let path = "v3/relyingparty/setAccountInfo"
    let endpoint =
      baseUrl
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(
      idToken: idToken,
      displayName: profile.displayName,
      photoUrl: profile.photoUrl,
      deleteAttribute: profile.deleteAttribute,
      returnSecureToken: profile.returnSecureToken
    )

    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    let response = try self.decode(UpdateProfileResponse.self, from: data)

    return response
  }
}

public struct UpdateProfileResponse: Sendable, Hashable, Codable {
  public var localId: String
  public var email: String
  public var displayName: String?
  public var photoUrl: URL?
  public var passwordHash: String
  public var providerUserInfo: [ProviderUserInfo]
  public var emailVerified: Bool
}
