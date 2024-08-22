import Foundation
import HTTPClient
import RemoteConfig
import Testing

let apiKey = ProcessInfo.processInfo.environment["FIREBASE_API_TOKEN"]!
let projectId = ProcessInfo.processInfo.environment["FIREBASE_PROJECT_ID"]!
let projectName = ProcessInfo.processInfo.environment["FIREBASE_PROJECT_NAME"]!
let appId = ProcessInfo.processInfo.environment["FIREBASE_APP_ID"]!

let client = RemoteConfig(
  apiKey: apiKey,
  projectId: projectId,
  projectName: projectName,
  appId: appId,
  appInstanceId: UUID().uuidString,
  httpClient: .urlSession(.shared)
)

@Test
func fetch() async throws {
  let response = try await client.fetch()
  #expect(response.entries.keys.contains("parameterBool"))
  #expect(response.entries.keys.contains("parameterInt"))
  #expect(response.entries.keys.contains("parameterString"))
  #expect(response.entries.keys.contains("parameterJson"))
}

#if canImport(ObjectiveC)
  @Test
  func realtimeStream() async throws {
    for try await result in client.realtimeStream() {
      _ = try result.get()
      let remoteConfig = try await client.fetch()
      #expect(remoteConfig.entries.keys.contains("parameterBool"))
      #expect(remoteConfig.entries.keys.contains("parameterInt"))
      #expect(remoteConfig.entries.keys.contains("parameterString"))
      #expect(remoteConfig.entries.keys.contains("parameterJson"))
    }
  }
#endif
