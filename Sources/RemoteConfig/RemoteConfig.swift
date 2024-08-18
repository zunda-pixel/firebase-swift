import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public struct RemoteConfig<HTTPClient: HTTPClientProtocol>: Sendable, Hashable where HTTPClient: Sendable & Hashable {
  public var apiKey: String
  public var baseUrl = URL(string: "https://firebaseremoteconfig.googleapis.com/v1")!
  public var realtimeBaseUrl = URL(
    string: "https://firebaseremoteconfigrealtime.googleapis.com/v1")!
  public var projectId: String
  public var projectName: String
  public var appId: String
  /// Uniequ User(Device) ID
  public var appInstanceId: String
  public var httpClient: HTTPClient

  public init(
    apiKey: String,
    projectId: String,
    projectName: String,
    appId: String,
    appInstanceId: String,
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
