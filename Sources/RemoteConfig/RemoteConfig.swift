import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public struct RemoteConfig<HTTPClient: HTTPClientProtocol>: Sendable, Hashable
where HTTPClient.Body == Foundation.Data, HTTPClient.Data == Foundation.Data, HTTPClient: Hashable {
  public var apiKey: String
  public var baseUrl = URL(string: "https://firebaseremoteconfig.googleapis.com/v1")!
  public var realtimeBaseUrl = URL(string: "https://firebaseremoteconfigrealtime.googleapis.com/v1")!
  public var projectId: String
  public var projectName: String
  public var appInstanceId: String
  public var appId: String
  public var httpClient: HTTPClient
  
  public init(
    apiKey: String,
    projectId: String,
    projectName: String,
    appInstanceId: String,
    appId: String,
    httpClient: HTTPClient
  ) {
    self.apiKey = apiKey
    self.projectId = projectId
    self.projectName = projectName
    self.appInstanceId = appInstanceId
    self.appId = appId
    self.httpClient = httpClient
  }
}
