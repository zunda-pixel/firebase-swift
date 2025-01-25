import Currency

public struct Price: Sendable {
  public var currency: Currency
  public var value: Double

  public init(currency: Currency, value: Double) {
    self.currency = currency
    self.value = value
  }
}
