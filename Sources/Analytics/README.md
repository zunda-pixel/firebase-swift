## Custom Event

```swift
import Analytics

func log(
  eventName: Event.Name,
  parameters: [Parameter.Key: Parameter.Value?]
) async throws

try await log(
  eventName: "custom_event",
  paramters: [
    "id": "item-id",
    "name": "item-name",
  ]
)
```

## Application

```swift
import Analytics

try await analytics.appOpen()
try await analytics.tutorialBegin()
try await analytics.tutorialComplete()
try await analytics.signUp()
try await analytics.login()
try await analytics.screenView(name: "TopView")
try await analytics.search(term: "Search Item")
try await analytics.viewSearchResults(term: "Search Iteem")
try await analytics.viewItem(items: [
  Item(name: "name1")
])
```

## Shopping

```swift
import Analytics

try await analytics.addPaymentInfo()
try await analytics.addToWithlist(item: [
  Item(name: "Item1", quantity: 1),
  Item(name: "Item2", quantity: 1),
  Item(name: "Item3", quantity: 1),
])
try await analytics.addCartItem(items: [
  Item(name: "Item1", quantity: 1),
  Item(name: "Item2", quantity: 1),
])
try await analytics.viewCart(items: [
  Item(name: "Item1", quantity: 1),
  Item(name: "Item2", quantity: 1),
])
try removeFromCart(items: [
  Item(name: "Item2", quantity: 1),
])
try await analytics.beginCheckout()
// adopt coupon
try await analytics.addShippingInfo(
  coupon: "DISCOUNT",
  shipingTier: "Standard",
  price: Price(currency: .usd, value: 0.5),
  items: [
    Item(name: "Item1", quantity: 1),
  ],
)
try await analytics.purchase(
  transactionId: UUID().uuidString,
  coupon: "DISCOUNT",
  tax: "2.0",
  shipping: 11.5,
  items: [
    Item(name: "Item1", quantity: 1),
  ]
)
try await analytics.refund()
```

## Advertising

```swift
import Analytics

try await analytics.adImpression()
```

## Game Event

```swift
import Analytics

try await analytics.levelStart(levelName: "First Stage")
try await analytics.levelUp(level: 1)
try await analytics.leveEnd(levelName: "First Stage", success: true)
try await analytics.postScore(score: 100)
try await analytics.achievementUnlocked(achievementId: "First Achievement")
```

## Virutal Currency

```swift
import Analytics

try await analytics.earnVirtualCurrency(currency: "Coins", amount: 100)
try await analytics.spendVirtualCurrency(
  itemName: "Shield",
  currencyName: "Coins",
  amount: 10
)
```


