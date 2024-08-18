import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public struct Firestore<HTTPClient: HTTPClientProtocol>: Sendable, Hashable where HTTPClient: Sendable & Hashable {
  public var oauthApiKey: String
  public var baseUrl = URL(string: "https://firestore.googleapis.com")!
  public var projectName: String
  public var httpClient: HTTPClient

  public init(
    oauthApiKey: String,
    projectName: String,
    httpClient: HTTPClient
  ) {
    self.oauthApiKey = oauthApiKey
    self.projectName = projectName
    self.httpClient = httpClient
  }
}
