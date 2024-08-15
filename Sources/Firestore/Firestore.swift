import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public struct Firestore<HTTPClient: HTTPClientProtocol>: Sendable, Hashable
where HTTPClient.Data == Foundation.Data, HTTPClient: Sendable & Hashable {
  public var apiKey: String
  public var oauthApiKey: String
  public var baseUrl = URL(string: "https://firestore.googleapis.com")!
  public var projectName: String
  public var httpClient: HTTPClient

  public init(
    apiKey: String,
    oauthApiKey: String,
    projectName: String,
    httpClient: HTTPClient
  ) {
    self.apiKey = apiKey
    self.oauthApiKey = oauthApiKey
    self.projectName = projectName
    self.httpClient = httpClient
  }
}
