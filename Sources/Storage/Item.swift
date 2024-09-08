import Foundation

public enum StorageClass: String, Hashable, Sendable, Codable {
  case standard = "STANDARD"
}

public struct Item: Codable, Hashable, Sendable {
  public var name: String
  public var bucket: String
  public var generation: Date
  public var metageneration: Int
  public var timeCreated: Date
  public var updated: Date
  public var storageClass: StorageClass
  public var size: Int
  public var md5Hash: String
  public var contentEncoding: String
  public var contentDisposition: String
  public var crc32c: String
  public var etag: String
  public var downloadTokens: String

  public init(from decoder: any Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.name = try container.decode(String.self, forKey: .name)
    self.bucket = try container.decode(String.self, forKey: .bucket)
    let generationString = try container.decode(String.self, forKey: .generation)
    let generation = TimeInterval(generationString)!
    self.generation = Date(timeIntervalSince1970: generation / 1000000)
    let metagenerationString = try container.decode(String.self, forKey: .metageneration)
    self.metageneration = Int(metagenerationString)!
    
    let dateFormatter = ISO8601DateFormatter()
    dateFormatter.formatOptions.insert(.withFractionalSeconds)
    
    let timeCreated = try container.decode(String.self, forKey: .timeCreated)
    self.timeCreated = dateFormatter.date(from: timeCreated)!
    
    let updated = try container.decode(String.self, forKey: .updated)
    self.updated = dateFormatter.date(from: updated)!

    self.storageClass = try container.decode(StorageClass.self, forKey: .storageClass)

    let sizeString = try container.decode(String.self, forKey: .size)
    self.size = Int(sizeString)!

    self.md5Hash = try container.decode(String.self, forKey: .md5Hash)
    self.contentEncoding = try container.decode(String.self, forKey: .contentEncoding)
    self.contentDisposition = try container.decode(String.self, forKey: .contentDisposition)
    self.crc32c = try container.decode(String.self, forKey: .crc32c)
    self.etag = try container.decode(String.self, forKey: .etag)
    self.downloadTokens = try container.decode(String.self, forKey: .downloadTokens)
  }
}
