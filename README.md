# firebase-swift

Firebase client for Swift.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fzunda-pixel%2Ffirebase-swift%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/zunda-pixel/firebase-swift)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fzunda-pixel%2Ffirebase-swift%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/zunda-pixel/firebase-swift)

### [Authentication](https://firebase.google.com/docs/auth)

- Create Anonymous User
- Create User
- Delete Account
- Link Email for Anonymous User
- Refresh Token
- Send Email Verification
- Send Email to Reset Password
- Send SignUp Link
- Update Password
- Update Profile
- Verify Password

```swift
let client = AuthClient(
  apiKey: apiKey,
  httpClient: .urlSession(.shared)
)

let user = try await client.createUser(
  email: "test@gmail.com",
  password: "password"
)

print(user)
```

### [Remote Config](https://firebase.google.com/docs/remote-config)

- Fetch Remote Config
- Realtime Remote Config

```swift
let client = RemoteConfigClient(
  apiKey: apiKey,
  projectId: projectId,
  projectName: projectName,
  appId: appId,
  appInstanceId: UUID().uuidString,
  httpClient: .urlSession(.shared)
)

let config = try await client.fetch()
print(config)
```

### [Cloud Storage](https://firebase.google.com/docs/storage)

- Get Item
- Get Items
- Upload Item
- Delete Item
- Update Item

```swift
let client = StorageClient(
  httpClient: .urlSession(.shared)
)

let item = try await client.upload(
  bucket: bucket,
  path: itemPath,
  data: data,
  contentType: contentType
)

print(item)
```
