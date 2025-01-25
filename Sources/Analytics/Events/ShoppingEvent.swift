import Foundation

extension Analytics {
  /// Add Payment Info event.
  ///
  /// This event signifies that a user has submitted their payment information.
  /// ```swift
  /// try await analytics.addPaymentInfo(
  ///   coupon: "SUMMER_FUN",
  ///   paymentType: "Visa",
  ///   price: Price(currency: .usd, value: 39.98),
  ///   items: [
  ///     .init(id: "SKU_123", name: "T-Shirt", category: "Apparel", price: .init(currency: .usd, value: 29.99), quantity: 1),
  ///     .init(id: "SKU_234", name: "Socks", category: "Apparel", price: .init(currency: .usd, value: 9.99) quantity: 2)
  ///   ]
  /// )
  /// ```
  public func addPaymentInfo(
    coupon: String? = nil,
    paymentType: String? = nil,
    price: Price? = nil,
    items: [Item]
  ) async throws {
    try await log(
      eventName: .addPaymentInfo,
      parameters: [
        .coupon: coupon.map { .string($0) },
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .paymentType: paymentType.map { .string($0) },
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// Add Shipping Info event.
  ///
  /// This event signifies that a user has submitted their shipping information.
  public func addShippingInfo(
    coupon: String? = nil,
    shippingTier: String? = nil,
    price: Price? = nil,
    items: [Item]
  ) async throws {
    try await log(
      eventName: .addShippingInfo,
      parameters: [
        .coupon: coupon.map { .string($0) },
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .shippingTier: shippingTier.map { .string($0) },
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// E-Commerce Add To Cart event.
  ///
  /// This event signifies that an item(s) was added to a cart for purchase.
  /// Add this event to a funnel with purchase to gauge the effectiveness of your checkout process.
  /// ```swift
  /// try await analytics.addToCart(
  ///   items: [
  ///     .init(id: "SKU_123", name: "T-Shirt", category: "Apparel", price: .init(currency: .usd, value: 29.99), quantity: 1),
  ///     .init(id: "SKU_234", name: "Socks", category: "Apparel", price: .init(currency: .usd, value: 9.99) quantity: 2)
  ///   ],
  ///   price: Price(currency: .usd, value: 39.98)
  /// )
  /// ```
  public func addToCart(
    items: [Item],
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .addToCart,
      parameters: [
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// E-Commerce Add To Wishlist event.
  ///
  /// This event signifies that an item was added to a wishlist.
  /// Use this event to identify popular gift items.
  /// ```swift
  /// try await analytics.addToWithlist(
  ///   items: [
  ///     .init(id: "SKU_123", name: "T-Shirt", category: "Apparel", price: .init(currency: .usd, value: 29.99), quantity: 1),
  ///     .init(id: "SKU_234", name: "Socks", category: "Apparel", price: .init(currency: .usd, value: 9.99) quantity: 2)
  ///   ],
  ///   price: Price(currency: .usd, value: 39.98)
  /// )
  /// ```
  public func addToWithlist(
    items: [Item],
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .addToWithlist,
      parameters: [
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// E-Commerce Begin Checkout event.
  ///
  /// This event signifies that a user has begun the process of checking out.
  /// Add this event to a funnel with your purchase event to gauge the effectiveness of your checkout process.
  public func beginCheckout(
    items: [Item],
    coupon: String? = nil,
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .beginCheckout,
      parameters: [
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .coupon: coupon.map { .string($0) },
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// E-Commerce Purchase event.
  ///
  /// This event signifies that an item(s) was purchased by a user.
  public func purchase(
    transactionId: String? = nil,
    coupon: String? = nil,
    tax: Double? = nil,
    price: Price? = nil,
    shipping: Double? = nil,
    items: [Item]
  ) async throws {
    try await log(
      eventName: .purchase,
      parameters: [
        .transactionId: transactionId.map { .string($0) },
        .coupon: coupon.map { .string($0) },
        .tax: tax.map { .float($0) },
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
        .shipping: shipping.map { .float($0) },
        .items: .array(items.map { .dictionary($0.paramterers) }),
      ]
    )
  }

  /// E-Commerce Refund event.
  ///
  /// This event signifies that a refund was issued.
  public func refund(
    transactionId: String? = nil,
    coupon: String? = nil,
    tax: Double? = nil,
    price: Price? = nil,
    shipping: Double? = nil,
    items: [Item]? = nil
  ) async throws {
    try await log(
      eventName: .refund,
      parameters: [
        .transactionId: transactionId.map { .string($0) },
        .coupon: coupon.map { .string($0) },
        .tax: tax.map { .float($0) },
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
        .shipping: shipping.map { .float($0) },
        .items: items.map { .array($0.map { .dictionary($0.paramterers) }) },
      ]
    )
  }

  /// E-Commerce Remove from Cart event.
  ///
  /// This event signifies that an item(s) was removed from a cart.
  public func removeFromCart(
    items: [Item],
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .removeFromCart,
      parameters: [
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// E-commerce View Cart event.
  ///
  /// This event signifies that a user has viewed their cart.
  /// Use this to analyze your purchase funnel.
  public func viewCart(
    items: [Item],
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .viewCart,
      parameters: [
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }
}
