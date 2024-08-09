import Foundation

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public struct ProviderUserInfo: Sendable, Hashable, Codable {
  public var providerId: String
  public var federatedId: String
  public var email: String?
  public var rawId: String
  public var displayName: String?
  public var photoUrl: URL?
  public var screenName: String?
}
