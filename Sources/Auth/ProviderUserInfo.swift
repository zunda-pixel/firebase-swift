public struct ProviderUserInfo: Sendable, Hashable, Codable {
  public var providerId: String
  public var federatedId: String
  public var email: String
  public var rawId: String
}
