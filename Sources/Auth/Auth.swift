import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public typealias AuthClient = Client

public struct Client<HTTPClient: HTTPClientProtocol>: Sendable, Hashable
where HTTPClient: Sendable & Hashable {
  public var apiKey: String
  public var baseUrl = URL(string: "https://www.googleapis.com/identitytoolkit")!
  public var baseUrlSecure = URL(string: "https://securetoken.googleapis.com")!
  public var httpClient: HTTPClient

  public init(apiKey: String, httpClient: HTTPClient) {
    self.apiKey = apiKey
    self.httpClient = httpClient
  }
}
