public struct Item: Sendable {
  public var id: String?
  public var name: String?
  public var affiliation: String?
  public var category: String?
  public var category2: String?
  public var category3: String?
  public var category4: String?
  public var category5: String?
  public var variant: String?
  public var brand: String?
  public var price: Price?
  public var discount: Double?
  public var index: UInt?
  public var quantity: UInt?
  public var coupon: String?
  public var listId: String?
  public var listName: String?
  public var locationId: String?

  var paramterers: [Parameter.Key: Parameter.Value] {
    let parameters: [Parameter.Key: Parameter.Value] = [
      .itemId: id.map { .string($0) },
      .itemName: name.map { .string($0) },
      .affiliation: affiliation.map { .string($0) },
      .itemCategory: category.map { .string($0) },
      .itemCategory2: category2.map { .string($0) },
      .itemCategory3: category3.map { .string($0) },
      .itemCategory4: category4.map { .string($0) },
      .itemCategory5: category5.map { .string($0) },
      .itemVariant: variant.map { .string($0) },
      .itemBrand: brand.map { .string($0) },
      .value: price.map { .float($0.value) },
      .discount: discount.map { .float($0) },
      .index: index.map { .uint($0) },
      .currency: price.map { .string($0.currency.rawValue.uppercased()) },
      .quantity: quantity.map { .uint($0) },
      .coupon: coupon.map { .string($0) },
      .itemListId: listId.map { .string($0) },
      .itemListName: listName.map { .string($0) },
      .locationId: locationId.map { .string($0) },
    ].compactMapValues { $0 }

    return parameters
  }
}
