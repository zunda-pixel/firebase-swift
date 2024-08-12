import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public struct RemoteConfig<HTTPClient: HTTPClientProtocol>: Sendable, Hashable
where HTTPClient.Body == Foundation.Data, HTTPClient.Data == Foundation.Data, HTTPClient: Hashable {
  public var apiKey: String
  public var baseUrl = URL(string: "https://firebaseremoteconfig.googleapis.com/v1")!
  public var projectName: String
  public var httpClient: HTTPClient
  
  public init(
    apiKey: String,
    projectId: String,
    httpClient: HTTPClient
  ) {
    self.apiKey = apiKey
    self.projectName = projectId
    self.httpClient = httpClient
  }
}
