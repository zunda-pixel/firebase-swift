import Foundation
import HTTPTypes
import HTTPTypesFoundation
import HTTPClient

public struct Storage<HTTPClient: HTTPClientProtocol & Sendable>: Sendable {
  public var baseUrl = URL(string : "https://firebasestorage.googleapis.com/")!
  public var httpClient: HTTPClient

  public init(httpClient: HTTPClient) {
    self.httpClient = httpClient
  }
}
