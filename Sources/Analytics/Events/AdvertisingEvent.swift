extension Analytics {
  /// Ad Impression event.
  ///
  /// This event signifies when a user sees an ad impression.
  public func adImpression(
    platform: String? = nil,
    format: String? = nil,
    source: String? = nil,
    unitName: String? = nil,
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .adImpression,
      parameters: [
        .adPlatform: platform.map { .string($0) },
        .adFormat: format.map { .string($0) },
        .adSource: source.map { .string($0) },
        .adUnitName: unitName.map { .string($0) },
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }
}
