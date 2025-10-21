import Auth
import Foundation
import HTTPClient
import HTTPTypes
import Testing

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension Tag {
  @Tag static var emailRequired: Self
}

@Suite
struct AuthTests {
  static let emailRequired: Bool = ProcessInfo.processInfo.environment["EMAIL_REQUIRED"] != nil

  var googleUserID: String
  var githubToken: String
  var client: AuthClient<URLSession>

  init() {
    self.googleUserID = ProcessInfo.processInfo.environment["GOOGLE_USER_ID"]!
    self.githubToken = ProcessInfo.processInfo.environment["GITHUB_TOKEN"]!
    self.client = AuthClient(
      apiKey: ProcessInfo.processInfo.environment["FIREBASE_API_TOKEN"]!,
      httpClient: .urlSession(.shared)
    )
  }

  @Test
  func sendEmailToUpdateEmail() async throws {
    let oldEmail = "\(googleUserID)+\(UUID())@gmail.com"
    let newEmail = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let user = try await client.createUser(
      email: oldEmail,
      password: password
    )

    try await client.sendEmailToUpdateEmail(
      idToken: user.idToken,
      newEmail: newEmail
    )
  }

  @Test
  func sendSignUpLinkForURL() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let continueUrl = URL(string: "http://localhost")!
    try await client.sendSignUpLink(
      email: email,
      continueUrl: continueUrl
    )
  }

  @Test
  func createAnonymousUser() async throws {
    try await client.createAnonymousUser()
  }

  @Test
  func createUser() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    try await client.createUser(
      email: email,
      password: password
    )
  }

  @Test
  func verifyPassword() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    try await client.createUser(
      email: email,
      password: password
    )

    try await client.verifyPassword(
      email: email,
      password: password
    )
  }

  @Test
  func refreshToken() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.createUser(
      email: email,
      password: password
    )

    _ = try await client.refreshToken(
      refreshToken: response.refreshToken
    )
  }

  @Test
  func sendEmailVerification() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.createUser(
      email: email,
      password: password
    )

    try await client.sendEmailVerification(
      idToken: response.idToken
    )
  }

  @Test(.enabled(if: emailRequired), .tags(.emailRequired))
  func verifyEmailOobCode() async throws {
    let oobCode = "ehxU1I1HKY9afhSfF2EA74AVfo4aaoUrPEJUVTJjXFIAAAGRZgrsZw"

    try await client.verifyEmailOobCode(
      oobCode: oobCode
    )
  }

  @Test
  func deleteAccount() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.createUser(
      email: email,
      password: password
    )

    try await client.deleteAccount(
      idToken: response.idToken
    )
  }

  @Test
  func linkEmailForAnonymousUser() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let originalUser = try await client.createAnonymousUser()

    let newUser = try await client.linkEmail(
      idToken: originalUser.idToken,
      email: email,
      password: password
    )

    #expect(originalUser.localId == newUser.localId)
  }

  @Test
  func unLinkEmailProvider() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.createAnonymousUser()

    try await client.linkEmail(
      idToken: response.idToken,
      email: email,
      password: password
    )

    let user = try await client.unLink(
      idToken: response.idToken,
      deleteProviders: ["password"]
    )

    let containsPasswordProvider = user.providerUserInfo.contains(where: {
      $0.providerId == "password"
    })
    #expect(containsPasswordProvider == false)
  }

  @Test
  func unLinkGitHubProvider() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.createUser(
      email: email,
      password: password
    )

    let user = try await client.unLink(
      idToken: response.idToken,
      deleteProviders: ["github.com"]
    )

    let containsPasswordProvider = user.providerUserInfo.contains(where: {
      $0.providerId == "github.com"
    })
    #expect(containsPasswordProvider == false)
  }

  @Test(.enabled(if: emailRequired), .tags(.emailRequired))
  func linkGitHub() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let user = try await client.createUser(
      email: email,
      password: password
    )

    try await client.linkProvider(
      idToken: user.idToken,
      requestUri: URL(string: "http://localhost")!,
      provider: .github(accessToken: githubToken)
    )
  }

  @Test(.enabled(if: emailRequired), .tags(.emailRequired))
  func linkEmailToGitHubAccount() async throws {
    let githubAccount = try await client.createUserOrGetOAuth(
      requestUri: URL(string: "http://localhost")!,
      provider: .github(accessToken: githubToken)
    )

    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    try await client.linkEmail(
      idToken: githubAccount.idToken,
      email: email,
      password: password
    )
  }

  @Test
  func user() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.createUser(
      email: email,
      password: password
    )

    let updateProfile = UpdateProfile(
      displayName: "displayName-\(UUID().uuidString)",
      photoUrl: URL(string: "https://google.com?query=\(UUID().uuidString)")!,
      deleteAttribute: [],
      returnSecureToken: false
    )

    try await client.updateProfile(
      idToken: response.idToken,
      profile: updateProfile
    )

    let user = try await client.user(
      idToken: response.idToken
    )
    let userEmail = try #require(user.email)
    #expect(userEmail.lowercased() == email.lowercased())
    #expect(user.displayName! == updateProfile.displayName!)
    #expect(user.photoUrl! == updateProfile.photoUrl!)
  }

  @Test
  func updateProfile() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.createUser(
      email: email,
      password: password
    )

    let updateProfile = UpdateProfile(
      displayName: "displayName-\(UUID().uuidString)",
      photoUrl: URL(string: "https://google.com?query=\(UUID().uuidString)")!,
      deleteAttribute: [],
      returnSecureToken: false
    )

    let updateProfileResponse = try await client.updateProfile(
      idToken: response.idToken,
      profile: updateProfile
    )

    #expect(updateProfile.displayName! == updateProfileResponse.displayName!)
    #expect(updateProfile.photoUrl! == updateProfileResponse.photoUrl!)
  }

  @Test
  func deleteDisplayName() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.createUser(
      email: email,
      password: password
    )

    let updateProfile = UpdateProfile(
      deleteAttribute: [.displayName]
    )

    let response2 = try await client.updateProfile(
      idToken: response.idToken,
      profile: updateProfile
    )

    #expect(response2.displayName == nil)
  }

  @Test
  func deletePhotoUrl() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response1 = try await client.createUser(
      email: email,
      password: password
    )

    let updateProfile = UpdateProfile(
      deleteAttribute: [.photoUrl]
    )

    let response2 = try await client.updateProfile(
      idToken: response1.idToken,
      profile: updateProfile
    )

    #expect(response2.photoUrl == nil)
  }

  @Test(.enabled(if: emailRequired), .tags(.emailRequired))
  func signInWithOAuthGitHub() async throws {
    try await client.createUserOrGetOAuth(
      requestUri: URL(string: "http://localhost")!,
      provider: .github(accessToken: githubToken)
    )
  }

  @Test
  func sendEmailToResetPassword() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    try await client.createUser(
      email: email,
      password: password
    )

    try await client.sendEmailToResetPassword(
      email: email
    )
  }

  @Test
  func updatePassword() async throws {
    let email = "\(googleUserID)+\(UUID())@gmail.com"
    let password = "password123"
    let newPassword = "password12345"

    let response = try await client.createUser(
      email: email,
      password: password
    )

    try await client.updatePassword(
      idToken: response.idToken,
      newPassword: newPassword
    )
  }

  @Test(.enabled(if: emailRequired), .tags(.emailRequired))
  func resetPassword() async throws {
    let oobCode = "weY70CQTC6SoUkNpe5GXd3oA"
    let newPassword = "password12345"

    try await client.verifyCodeResetPassword(
      oobCode: oobCode,
      newPassword: newPassword
    )
  }
}
