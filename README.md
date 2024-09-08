# firebase-swift

Firebase API Client Swift

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
let client = Auth(
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
let client = RemoteConfig(
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
let storage = Storage(httpClient: .urlSession(.shared))

let item = try await storage.upload(
  bucket: bucket,
  path: filePath,
  data: svgData,
  contentType: contentType
)
```
