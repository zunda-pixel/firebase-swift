import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension RemoteConfig {
  public func fetch(
    country: String? = nil,
    language: String? = nil,
    timezone: String? = nil
  ) async throws -> FetchResponse {
    let path = "v1/projects/\(self.projectName)/namespaces/firebase:fetch"
    let endpoint =
      baseUrl
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: self.apiKey)])

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let body = [
      "app_instance_id": self.appInstanceId,
      "app_id": self.appId,
      "country_code": country,
      "language_code": language,
      "time_zone": timezone,
    ].compactMapValues { $0 }

    let bodyData = try! JSONEncoder().encode(body)

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)
    let response = try self.decode(FetchResponse.self, from: data)
    return response
  }
}

extension FetchResponse {
  public enum State: String, Sendable, Hashable, Codable {
    case update = "UPDATE"
  }
}

public struct FetchResponse: Sendable, Hashable, Codable {
  public var entries: [String: String]
  public var state: State
  public var templateVersion: Int

  public init(
    entries: [String: String],
    state: State,
    templateVersion: Int
  ) {
    self.entries = entries
    self.state = state
    self.templateVersion = templateVersion
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.entries = try container.decode([String: String].self, forKey: .entries)
    self.state = try container.decode(State.self, forKey: .state)
    let templateVersionString = try container.decode(String.self, forKey: .templateVersion)
    if let templateVersion = Int(templateVersionString) {
      self.templateVersion = templateVersion
    } else {
      throw DecodingError.dataCorruptedError(
        forKey: .templateVersion,
        in: container,
        debugDescription: "\(templateVersionString) is not number"
      )
    }
  }
}
