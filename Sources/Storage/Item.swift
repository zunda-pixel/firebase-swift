import Foundation

public enum StorageClass: String, Hashable, Sendable, Codable {
  case standard = "STANDARD"
}

public struct Item: Codable, Hashable, Sendable {
  public var name: String
  public var bucket: String
  public var generation: Date
  public var metageneration: Int
  public var contentType: String
  public var timeCreated: Date
  public var updated: Date
  public var storageClass: StorageClass
  public var size: Int
  public var md5Hash: String
  public var contentEncoding: String
  public var contentDisposition: String
  public var contentLanguage: String?
  public var cacheControl: String?
  public var crc32c: String
  public var etag: String
  public var downloadTokens: String
  public var customMetadata: [String: String]?

  private enum CodingKeys: String, CodingKey {
    case name
    case bucket
    case generation
    case metageneration
    case contentType
    case timeCreated
    case updated
    case storageClass
    case size
    case md5Hash
    case contentEncoding
    case contentDisposition
    case contentLanguage
    case cacheControl
    case crc32c
    case etag
    case downloadTokens
    case customMetadata = "metadata"
  }

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.bucket = try container.decode(String.self, forKey: .bucket)
    let generationString = try container.decode(String.self, forKey: .generation)
    let generation = TimeInterval(generationString)!
    self.generation = Date(timeIntervalSince1970: generation / 1_000_000)
    let metagenerationString = try container.decode(String.self, forKey: .metageneration)
    self.metageneration = Int(metagenerationString)!

    self.contentType = try container.decode(String.self, forKey: .contentType)

    let dateFormatStyle: Date.ISO8601FormatStyle = .iso8601.year().month().day().time(includingFractionalSeconds: true)

    let timeCreated = try container.decode(String.self, forKey: .timeCreated)
    self.timeCreated = try Date(timeCreated, strategy: dateFormatStyle)

    let updated = try container.decode(String.self, forKey: .updated)
    self.updated = try Date(updated, strategy: dateFormatStyle)

    self.storageClass = try container.decode(StorageClass.self, forKey: .storageClass)

    let sizeString = try container.decode(String.self, forKey: .size)
    self.size = Int(sizeString)!

    self.md5Hash = try container.decode(String.self, forKey: .md5Hash)
    self.contentEncoding = try container.decode(String.self, forKey: .contentEncoding)
    self.contentDisposition = try container.decode(String.self, forKey: .contentDisposition)
    self.contentLanguage = try container.decodeIfPresent(String.self, forKey: .contentLanguage)
    self.cacheControl = try container.decodeIfPresent(String.self, forKey: .cacheControl)
    self.crc32c = try container.decode(String.self, forKey: .crc32c)
    self.etag = try container.decode(String.self, forKey: .etag)
    self.downloadTokens = try container.decode(String.self, forKey: .downloadTokens)
    self.customMetadata = try container.decodeIfPresent(
      [String: String].self, forKey: .customMetadata)
  }
}
