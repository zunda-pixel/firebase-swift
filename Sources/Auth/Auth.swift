import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public struct Auth<HTTPClient: HTTPClientProtocol>: Sendable, Hashable where HTTPClient.Body == Foundation.Data, HTTPClient.Data == Foundation.Data, HTTPClient: Hashable {
  public var apiKey: String
  public var baseUrlV1 = URL(string: "https://identitytoolkit.googleapis.com/v1")!
  public var baseUrlV3 = URL(string: "https://www.googleapis.com/identitytoolkit/v3")!
  public var httpClient: HTTPClient

  public init(apiKey: String, httpClient: HTTPClient) {
    self.apiKey = apiKey
    self.httpClient = httpClient
  }
}
