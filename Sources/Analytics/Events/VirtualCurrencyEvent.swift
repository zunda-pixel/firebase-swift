extension Analytics {
  /// Earn Virtual Currency event.
  public func earnVirtualCurrency(
    currencyName: String,
    value: Double
  ) async throws {
    try await log(
      eventName: .earnVirtualCurrency,
      parameters: [
        .virtualCurrencyName: .string(currencyName),
        .value: .float(value),
      ]
    )
  }

  /// Spend Virtual Currency event.
  ///
  /// This event tracks the sale of virtual goods in your app and can help you identify which virtual goods are the most popular objects of purchase.
  public func spendVirtualCurrency(
    itemName: String,
    currencyName: String,
    value: Double
  ) async throws {
    try await log(
      eventName: .spendVirtualCurrency,
      parameters: [
        .itemName: .string(itemName),
        .virtualCurrencyName: .string(currencyName),
        .value: .float(value),
      ]
    )
  }
}
