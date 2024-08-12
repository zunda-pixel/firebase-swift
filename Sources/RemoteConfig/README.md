## RemoteConfig

### Fetch Config

```swift
let api = RemoteConfig(
  apiKey: <#API_KEY#>,
  projectId: <#PROJECT_ID#>,
  projectName: <#PROJECT_NAME#>,
  appInstanceId: <#APP_INSTANCE_ID#>,
  appId: <#APP_ID#>,
  httpClient: .urlSession(.shared)
)

let response = try await api.fetch()
print(response.entries)
```

### SwiftUI

```swift
import SwiftUI
import RemoteConfig
import HTTPClientFoundation

struct ContentView: View {
  let remoteConfigObserver = RemoteConfigObserver(api: .init(
    apiKey: <#API_KEY#>,
    projectId: <#PROJECT_ID#>,
    projectName: <#PROJECT_NAME#>,
    appInstanceId: <#APP_INSTANCE_ID#>,
    appId: <#APP_ID#>,
    httpClient: .urlSession(.shared)
  ))

  var body: some View {
    NavigationStack {
      if let remoteConfig = remoteConfigObserver.response {
        RemoteConfigView()
          .environment(\.remoteConfig, remoteConfig)
      } else {
        ProgressView()
      }
    }
    .onAppear() {
      remoteConfigObserver.setTask()
    }
  }
}

struct RemoteConfigView: View {
  @Environment(\.remoteConfig) var remoteConfig
  
  var entries: [Dictionary<String, String>.Element] {
    Array(remoteConfig.entries).sorted(using: KeyPathComparator(\.key))
  }
  
  var body: some View {
    List {
      LabeledContent("Version", value: remoteConfig.templateVersion.description)
      LabeledContent("State", value: remoteConfig.state.rawValue)
      Section {
        ForEach(entries, id: \.key) { key, value in
          LabeledContent(key, value: value)
        }
      }
    }
  }
}

@MainActor
@Observable
final class RemoteConfigObserver: Sendable {
  let api: RemoteConfig<URLSession>
  var response: FetchResponse? = nil
  var task: Task<Void, Never>? = nil
  
  init(api: RemoteConfig<URLSession>) {
    self.api = api
  }
  
  func setTask() {
    self.task?.cancel()
    self.task = Task {
      do {
        for try await result in api.realtimeStream() {
          do {
            _ = try result.get()
            let response = try await api.fetch()
            self.response = response
          } catch {
            print(error)
          }
        }
      } catch {
        print(error)
        self.setTask()
      }
    }
  }
}

extension EnvironmentValues {
  @Entry var remoteConfig: FetchResponse = .init(entries: [:], state: .update, templateVersion: 0)
}
```
