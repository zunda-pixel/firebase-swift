import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public struct Auth<HTTPClient: HTTPClientProtocol>: Sendable, Hashable
where HTTPClient.Data == Foundation.Data, HTTPClient: Sendable & Hashable {
  public var apiKey: String
  public var baseUrlV1 = URL(string: "https://identitytoolkit.googleapis.com")!
  public var baseUrlV3 = URL(string: "https://www.googleapis.com/identitytoolkit")!
  public var baseUrlSecure = URL(string: "https://securetoken.googleapis.com")!
  public var httpClient: HTTPClient

  public init(apiKey: String, httpClient: HTTPClient) {
    self.apiKey = apiKey
    self.httpClient = httpClient
  }
}
