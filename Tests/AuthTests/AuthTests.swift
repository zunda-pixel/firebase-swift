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

struct AuthTests {
  static let apiKey = ProcessInfo.processInfo.environment["FIREBASE_API_TOKEN"]!
  static let googleUserID = ProcessInfo.processInfo.environment["GOOGLE_USER_ID"]!
  static let emailRequired: Bool = ProcessInfo.processInfo.environment["EMAIL_REQUIRED"] != nil

  var client: Auth<URLSession> {
    Auth(
      apiKey: Self.apiKey,
      httpClient: .urlSession(.shared)
    )
  }
  
  @Test
  func sendSignUpLinkForURL() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
    let continueUrl = URL(string: "http://localhost")!
    _ = try await client.sendSignUpLink(
      email: email,
      continueUrl: continueUrl
    )
  }
  
  @Test(.enabled(if: Self.emailRequired), .tags(.emailRequired))
  func signUpFromEmailLink() async throws {
    let oobCode = "REOxFT0P8iTcBsnZIYT7fE4n0K8u53kidBKq3Q7PYggAAAGQ01XEQA"
    let email = "rokki.hiroki+4eb7a529-5c57-4627-9a2c-e26df01438ac@gmail.com"
    let newPassword = "password123"

    _ = try await client.verifyResetPasswordCode(
      oobCode: oobCode
    )

    _ = try await client.signUp(
      email: email,
      password: newPassword
    )
  }

  @Test
  func signUpAnonymous() async throws {
    _ = try await client.signUpAnonymous()
  }

  @Test
  func signUp() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    _ = try await client.signUp(
      email: email,
      password: password
    )
  }

  @Test
  func signIn() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    _ = try await client.signUp(
      email: email,
      password: password
    )

    _ = try await client.signIn(
      email: email,
      password: password
    )
  }

  @Test
  func refreshToken() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
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
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.signUp(
      email: email,
      password: password
    )

    _ = try await client.sendEmailVerification(
      idToken: response.idToken
    )
  }

  @Test
  func deleteAccount() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response1 = try await client.signUp(
      email: email,
      password: password
    )

    _ = try await client.deleteAccount(
      idToken: response1.idToken
    )
  }

  @Test
  func unLinkProvider() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response1 = try await client.signUp(
      email: email,
      password: password
    )

    _ = try await client.unLinkEmail(
      idToken: response1.idToken,
      deleteProviders: ["password"]
    )
  }

  @Test
  func linkAndUnLinkProvider() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response1 = try await client.signUp(
      email: email,
      password: password
    )

    _ = try await client.unLinkEmail(
      idToken: response1.idToken,
      deleteProviders: ["password"]
    )

    _ = try await client.linkEmail(
      idToken: response1.idToken,
      email: email,
      password: password
    )
  }

  @Test
  func user() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
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

    _ = try await client.updateProfile(
      idToken: response.idToken,
      profile: updateProfile
    )

    let user = try await client.user(
      idToken: response.idToken
    )

    #expect(user.email.lowercased() == email.lowercased())
    #expect(user.displayName! == updateProfile.displayName!)
    #expect(user.photoUrl! == updateProfile.photoUrl!)
  }

  @Test
  func updateProfile() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
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
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
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
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
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

  @Test
  func sendEmailToResetPassword() async throws {
    let email = "\(Self.googleUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.signUp(
      email: email,
      password: password
    )

    _ = try await client.sendEmailToResetPassword(
      email: email
    )
  }

  @Test(.enabled(if: Self.emailRequired), .tags(.emailRequired))
  func resetPassword() async throws {
    let oobCode = "ywigG2AIRYIKQD6umz8mhWF1luMmjr33ykz_m-DITmsAAAGQsk4TNQ"
    let newPassword = "password123"

    _ = try await client.verifyResetPasswordCode(
      oobCode: oobCode
    )

    let response = try await client.resetPassword(
      oobCode: oobCode,
      newPassword: newPassword
    )

    _ = try await client.signIn(
      email: response.email,
      password: newPassword
    )
  }

  @Test(.enabled(if: Self.emailRequired), .tags(.emailRequired))
  func confirmEmailVerification() async throws {
    let oobCode = "l_0qVS_wyHVK_mhY2qbQZSB3Te-Bzm4tWXN0cg1lrdcAAAGQsk4q_w"

    _ = try await client.confirmEmailVerification(
      oobCode: oobCode
    )
  }
}
