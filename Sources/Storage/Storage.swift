import Foundation
import HTTPClient
import HTTPTypes
import HTTPTypesFoundation

public struct Storage<HTTPClient: HTTPClientProtocol & Sendable>: Sendable {
  public var baseUrl = URL(string: "https://firebasestorage.googleapis.com/")!
  public var httpClient: HTTPClient

  public init(httpClient: HTTPClient) {
    self.httpClient = httpClient
  }
}
