import Testing
import Auth
import Foundation

extension Tag {
  @Tag static var emailRequired: Self
}

struct AuthTests {
  let apiKey = ProcessInfo().environment["API_KEY"]!
  let gmailUserID = ProcessInfo().environment["GMAIL_USER_ID"]!

  var client: Auth<URLSession> {
    Auth(
      apiKey: apiKey,
      httpClient: .urlSession(.shared)
    )
  }
  
  @Test
  func signUpAnonymous() async throws {
    let response = try await client.signUpAnonymous()
    
    print(response)
  }
  
  @Test
  func signUp() async throws {
    let email = "\(gmailUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.signUp(
      email: email,
      password: password
    )
    
    print(response)
  }
  
  @Test
  func signIn() async throws {
    let email = "\(gmailUserID)+\(UUID())@gmail.com"
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
  func sendEmailToResetPassword() async throws {
    let email = "\(gmailUserID)+\(UUID())@gmail.com"
    let password = "password123"

    let response = try await client.signUp(
      email: email,
      password: password
    )

    _ = try await client.sendEmailToResetPassword(
      email: response.email
    )
  }
  
  @Test
  func refreshToken() async throws {
    let email = "\(self.gmailUserID)+\(UUID())@gmail.com"
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
    let email = "\(gmailUserID)+\(UUID())@gmail.com"
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
    let email = "\(self.gmailUserID)+\(UUID())@gmail.com"
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
    let email = "\(self.gmailUserID)+\(UUID())@gmail.com"
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
    let email = "\(self.gmailUserID)+\(UUID())@gmail.com"
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
    let email = "\(self.gmailUserID)+\(UUID())@gmail.com"
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
    let email = "\(self.gmailUserID)+\(UUID())@gmail.com"
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
    let email = "\(self.gmailUserID)+\(UUID())@gmail.com"
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
    let email = "\(self.gmailUserID)+\(UUID())@gmail.com"
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
  
  @Test(.tags(.emailRequired))
  func resetPassword() async throws {
    let oobCode = "ywigG2AIRYIKQD6umz8mhWF1luMmjr33ykz_m-DITmsAAAGQsk4TNQ"
    let newPassword = "password123"
    
    let response = try await client.verifyResetPasswordCode(
      oobCode: oobCode
    )
    
    _ = try await client.resetPassword(
      oobCode: oobCode,
      newPassword: newPassword
    )
    
    _ = try await client.signIn(
      email: response.email,
      password: newPassword
    )
  }
  
  @Test(.tags(.emailRequired))
  func confirmEmailVerification() async throws {
    let oobCode = "l_0qVS_wyHVK_mhY2qbQZSB3Te-Bzm4tWXN0cg1lrdcAAAGQsk4q_w"
    
    _ = try await client.confirmEmailVerification(
      oobCode: oobCode
    )
  }
}
