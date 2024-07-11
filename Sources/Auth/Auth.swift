import Foundation
import HTTPTypes
import HTTPTypesFoundation

public struct Auth: Sendable {
  public var apiKey: String
  public var baseURL = URL(string: "https://identitytoolkit.googleapis.com/v1")!
  
  public init(apiKey: String) {
    self.apiKey = apiKey
  }
}
