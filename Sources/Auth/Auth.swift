import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public struct Auth<HTTPClient: HTTPClientProtocol>: Sendable, Hashable {
  public var apiKey: String
  public var baseURL = URL(string: "https://identitytoolkit.googleapis.com/v1")!
  public var httpClient: HTTPClient

  public init(apiKey: String, httpClient: HTTPClient) {
    self.apiKey = apiKey
    self.httpClient = httpClient
  }
}
