import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Firestore {
  public func database(
    databaseId: String
  ) async throws -> Database {
    let path = "v1/projects/\(self.projectName)/databases/\(databaseId)"
    let endpoint =
      baseUrl
      .appending(path: path)

    let request = HTTPRequest(
      method: .get,
      url: endpoint,
      headerFields: [
        .contentType: "application/json",
        .authorization: "Bearer \(self.oauthApiKey)",
      ]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: nil)

    let response = try self.decode(Database.self, from: data)

    return response
  }
}

public struct Database: Sendable, Hashable, Codable {
  public var name: String
  public var uid: UUID
  public var createTime: Date
  public var updateTime: Date
  public var locationId: String
  public var type: String
  public var concurrencyMode: String
  public var versionRetentionPeriod: String
  public var earliestVersionTime: Date
  public var appEngineIntegrationMode: String
  public var pointInTimeRecoveryEnablement: String
  public var deleteProtectionState: String
  public var etag: String

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.uid = try container.decode(UUID.self, forKey: .uid)

    let dateFormatStyle: Date.ISO8601FormatStyle = .iso8601.year().month().day().time(includingFractionalSeconds: true)
    let createTime = try container.decode(String.self, forKey: .createTime)
    self.createTime = try Date(createTime, strategy: dateFormatStyle)
    let updateTime = try container.decode(String.self, forKey: .updateTime)
    self.updateTime = try Date(updateTime, strategy: dateFormatStyle)

    self.locationId = try container.decode(String.self, forKey: .locationId)
    self.type = try container.decode(String.self, forKey: .type)
    self.concurrencyMode = try container.decode(String.self, forKey: .concurrencyMode)
    self.versionRetentionPeriod = try container.decode(String.self, forKey: .versionRetentionPeriod)
    let earliestVersionTime = try container.decode(String.self, forKey: .earliestVersionTime)
    self.earliestVersionTime = try Date(earliestVersionTime, strategy: dateFormatStyle)
    self.appEngineIntegrationMode = try container.decode(
      String.self,
      forKey: .appEngineIntegrationMode
    )
    self.pointInTimeRecoveryEnablement = try container.decode(
      String.self,
      forKey: .pointInTimeRecoveryEnablement
    )
    self.deleteProtectionState = try container.decode(
      String.self,
      forKey: .deleteProtectionState
    )
    self.etag = try container.decode(String.self, forKey: .etag)
  }
}
