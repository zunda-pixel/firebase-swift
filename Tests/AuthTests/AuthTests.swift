import Auth
import Foundation
import HTTPClient
import HTTPClientFoundation
import HTTPTypes
import Testing

#if canImport(FoundationNetworking)
  import FoundationNetworking
#endif

extension Tag {
  @Tag static var emailRequired: Self
}

let apiKey = ProcessInfo.processInfo.environment["FIREBASE_API_TOKEN"]!
let googleUserID = ProcessInfo.processInfo.environment["GOOGLE_USER_ID"]!
let githubToken = ProcessInfo.processInfo.environment["GITHUB_TOKEN"]!
let emailRequired: Bool = ProcessInfo.processInfo.environment["EMAIL_REQUIRED"] != nil

let client = Auth(
  apiKey: apiKey,
  httpClient: .urlSession(.shared)
)

@Test
func sendSignUpLinkForURL() async throws {
  let email = "\(googleUserID)+\(UUID())@gmail.com"
  let continueUrl = URL(string: "http://localhost")!
  try await client.sendSignUpLink(
    email: email,
    continueUrl: continueUrl
  )
}

@Test(.enabled(if: emailRequired), .tags(.emailRequired))
func signUpFromEmailLink() async throws {
  let oobCode = "REOxFT0P8iTcBsnZIYT7fE4n0K8u53kidBKq3Q7PYggAAAGQ01XEQA"
  let email = "\(googleUserID)+\(UUID())@gmail.com"
  let newPassword = "password123"

  try await client.verifyResetPasswordCode(
    oobCode: oobCode
  )

  try await client.signUp(
    email: email,
    password: newPassword
  )
}

@Test
func createAnonymousUser() async throws {
  try await client.createAnonymousUser()
}

@Test
func signUp() async throws {
  let email = "\(googleUserID)+\(UUID())@gmail.com"
  let password = "password123"

  try await client.signUp(
    email: email,
    password: password
  )
}

@Test
func verifyPassword() async throws {
  let email = "\(googleUserID)+\(UUID())@gmail.com"
  let password = "password123"

  try await client.signUp(
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

  let response = try await client.signUp(
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

  let response = try await client.verifyPassword(
    email: email,
    password: password
  )

  try await client.sendEmailVerification(
    idToken: response.idToken
  )
}

@Test
func deleteAccount() async throws {
  let email = "\(googleUserID)+\(UUID())@gmail.com"
  let password = "password123"

  let response1 = try await client.signUp(
    email: email,
    password: password
  )

  try await client.deleteAccount(
    idToken: response1.idToken
  )
}

@Test
func unLinkProvider() async throws {
  let email = "\(googleUserID)+\(UUID())@gmail.com"
  let password = "password123"

  let response1 = try await client.signUp(
    email: email,
    password: password
  )

  try await client.unLinkEmail(
    idToken: response1.idToken,
    deleteProviders: ["password"]
  )
}

@Test(.enabled(if: emailRequired), .tags(.emailRequired))
func linkEmail() async throws {
  let email = "\(googleUserID)+\(UUID())@gmail.com"
  let response = try await client.signInWithOAuth(
    requestUri: URL(string: "http://localhost")!,
    provider: .github(accessToken: githubToken)
  )

  try await client.sendEmailVerification(
    idToken: response.idToken
  )

  try await client.confirmEmailVerification(oobCode: "code")

  try await client.linkEmail(
    idToken: response.idToken,
    email: email,
    password: "password123"
  )
}

@Test
func user() async throws {
  let email = "\(googleUserID)+\(UUID())@gmail.com"
  let password = "password123"

  let response = try await client.signUp(
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

  let response = try await client.signUp(
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

  let response = try await client.signUp(
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

  let response1 = try await client.signUp(
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
  try await client.signInWithOAuth(
    requestUri: URL(string: "http://localhost")!,
    provider: .github(accessToken: githubToken)
  )
}

@Test
func sendEmailToResetPassword() async throws {
  let email = "\(googleUserID)+\(UUID())@gmail.com"
  let password = "password123"

  try await client.signUp(
    email: email,
    password: password
  )

  try await client.sendEmailToResetPassword(
    email: email
  )
}

@Test(.enabled(if: emailRequired), .tags(.emailRequired))
func resetPassword() async throws {
  let oobCode = "ywigG2AIRYIKQD6umz8mhWF1luMmjr33ykz_m-DITmsAAAGQsk4TNQ"
  let newPassword = "password123"

  try await client.verifyResetPasswordCode(
    oobCode: oobCode
  )

  let response = try await client.resetPassword(
    oobCode: oobCode,
    newPassword: newPassword
  )

  try await client.verifyPassword(
    email: response.email,
    password: newPassword
  )
}

@Test(.enabled(if: emailRequired), .tags(.emailRequired))
func confirmEmailVerification() async throws {
  let oobCode = "l_0qVS_wyHVK_mhY2qbQZSB3Te-Bzm4tWXN0cg1lrdcAAAGQsk4q_w"

  try await client.confirmEmailVerification(
    oobCode: oobCode
  )
}
