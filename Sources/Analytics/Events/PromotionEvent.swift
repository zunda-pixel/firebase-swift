extension Analytics {
  /// View Promotion event.
  ///
  /// This event signifies that a promotion was shown to a user.
  /// Add this event to a funnel with the addToCart and purchase to gauge your conversion process.
  public func viewPromotion(
    creativeName: String? = nil,
    creativeSlot: String? = nil,
    promotionId: String? = nil,
    promotionName: String? = nil,
    items: [Item]
  ) async throws {
    try await log(
      eventName: .viewPromotion,
      parameters: [
        .creativeName: creativeName.map { .string($0) },
        .creativeSlot: creativeSlot.map { .string($0) },
        .promotionId: promotionId.map { .string($0) },
        .promotionName: promotionName.map { .string($0) },
        .items: .array(items.map { .dictionary($0.paramterers) }),
      ]
    )
  }

  /// Generate Lead event.
  ///
  /// Log this event when a lead has been generated in the app to understand the efficacy of your install and re-engagement campaigns.
  public func generateLead(
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .generateLead,
      parameters: [
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// Campaign Detail event.
  ///
  /// Log this event to supply the referral details of a re-engagement campaign.
  /// Note: you must supply at least one of the required parameters source, medium or campaign.
  public func campaignDetails(
    source: String?,
    medium: String?,
    campaign: String?,
    term: String? = nil,
    adNetworkClickId: String? = nil,
    campaignId: String? = nil,
    campaignContent: String? = nil,
    campaignCutomData: String? = nil,
    creativeFormat: String? = nil,
    marketingTactic: String? = nil,
    sourcePlatform: String? = nil
  ) async throws {
    try await log(
      eventName: .campaignDetails,
      parameters: [
        .source: source.map { .string($0) },
        .medium: medium.map { .string($0) },
        .campaign: campaign.map { .string($0) },
        .term: term.map { .string($0) },
        .adNetworkClickId: adNetworkClickId.map { .string($0) },
        .campaignId: campaignId.map { .string($0) },
        .campaignContent: campaignContent.map { .string($0) },
        .campaignCutomData: campaignCutomData.map { .string($0) },
        .creativeFormat: creativeFormat.map { .string($0) },
        .marketingTactic: marketingTactic.map { .string($0) },
        .sourcePlatform: sourcePlatform.map { .string($0) },
      ]
    )
  }
}
