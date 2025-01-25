import Foundation

extension Analytics {
  /// App Open event.
  ///
  /// By logging this event when an App becomes active, developers can understand how often users leave and return during the course of a Session.
  /// Although Sessions are automatically reported, this event can provide further clarification around the continuous engagement of app-users.
  public func appOpen() async throws {
    try await log(eventName: .appOpen, parameters: [:])
  }

  /// Login event.
  ///
  /// Apps with a login feature can report this event to signify that a user has logged in.
  public func login(method: String? = nil) async throws {
    try await log(
      eventName: .login,
      parameters: [
        .method: method.map { .string($0) }
      ]
    )
  }

  /// Screen View event.
  ///
  /// This event signifies a screen view.
  /// Use this when a screen transition occurs.
  /// This event can be logged irrespective of whether automatic screen tracking is enabled.
  public func screenView(
    name: String? = nil,
    className: String? = nil
  ) async throws {
    try await log(
      eventName: .screenView,
      parameters: [
        .screenName: name.map { .string($0) },
        .screenClass: className.map { .string($0) },
      ]
    )
  }

  /// Search event.
  ///
  /// Apps that support search features can use this event to contextualize search operations by supplying the appropriate, corresponding parameters.
  /// This event can help you identify the most popular content in your app.
  public func search(
    term: String
  ) async throws {
    try await log(
      eventName: .search,
      parameters: [
        .searchTerm: .string(term),
        .numberOfNights: nil,
        .numberOfRooms: nil,
        .numberOfPassengers: nil,
        .origin: nil,
        .destination: nil,
        .travelClass: nil,
      ]
    )
  }

  /// Search event.
  ///
  /// Apps that support search features can use this event to contextualize search operations by supplying the appropriate, corresponding parameters.
  /// This event can help you identify the most popular content in your app.
  public func searchTravel(
    term: String,
    numberOfNights: UInt? = nil,
    numberOfRooms: UInt? = nil,
    numberOfPassengers: UInt? = nil,
    origin: String? = nil,
    destination: String? = nil,
    travelClass: String? = nil
  ) async throws {
    try await log(
      eventName: .search,
      parameters: [
        .searchTerm: .string(term),
        .numberOfNights: numberOfNights.map { .uint($0) },
        .numberOfRooms: numberOfRooms.map { .uint($0) },
        .numberOfPassengers: numberOfPassengers.map { .uint($0) },
        .origin: origin.map { .string($0) },
        .destination: destination.map { .string($0) },
        .travelClass: travelClass.map { .string($0) },
      ]
    )
  }

  /// Select Content event.
  ///
  /// This general purpose event signifies that a user has selected some content of a certain type in an app.
  /// The content can be any object in your app. This event can help you identify popular content and categories of content in your app.
  public func selectContent(
    itemId: String,
    contentType: String
  ) async throws {
    try await log(
      eventName: .selectContent,
      parameters: [
        .itemId: .string(itemId),
        .contentType: .string(contentType),
      ]
    )
  }

  /// Select Item event.
  ///
  /// This event signifies that an item was selected by a user from a list.
  /// Use the appropriate parameters to contextualize the event.
  /// Use this event to discover the most popular items selected.
  public func selectItem(
    items: [Item],
    itemListId: String? = nil,
    itemListName: String? = nil
  ) async throws {
    try await log(
      eventName: .selectItem,
      parameters: [
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .itemListId: itemListId.map { .string($0) },
        .itemListName: itemListName.map { .string($0) },
      ]
    )
  }

  /// Select promotion event.
  ///
  /// This event signifies that a user has selected a promotion offer.
  /// Use the appropriate parameters to contextualize the event, such as the item(s) for which the promotion applies.
  public func selectPromotion(
    creativeName: String? = nil,
    creativeSlot: String? = nil,
    promotionId: String? = nil,
    promotionName: String? = nil,
    items: [Item]
  ) async throws {
    try await log(
      eventName: .selectPromotion,
      parameters: [
        .creativeName: creativeName.map { .string($0) },
        .creativeSlot: creativeSlot.map { .string($0) },
        .promotionId: promotionId.map { .string($0) },
        .promotionName: promotionName.map { .string($0) },
        .items: .array(items.map { .dictionary($0.paramterers) }),
      ]
    )
  }

  /// Share event.
  ///
  /// Apps with social features can log the Share event to identify the most viral content.
  public func share(
    method: String,
    itemId: String,
    contentType: String
  ) async throws {
    try await log(
      eventName: .share,
      parameters: [
        .method: .string(method),
        .itemId: .string(itemId),
        .contentType: .string(contentType),
      ]
    )
  }

  /// Sign Up event.
  ///
  /// This event indicates that a user has signed up for an account in your app.
  /// The parameter signifies the method by which the user signed up.
  /// Use this event to understand the different behaviors between logged in and logged out users.
  public func signUp(
    method: String
  ) async throws {
    try await log(
      eventName: .signUp,
      parameters: [
        .method: .string(method)
      ]
    )
  }

  /// Tutorial Begin event.
  ///
  /// This event signifies the start of the on-boarding process in your app.
  /// Use this in a funnel with tutorialComplete to understand how many users complete this process and move on to the full app experience.
  public func tutorialBegin() async throws {
    try await log(eventName: .tutorialBegin, parameters: [:])
  }

  /// Tutorial End event.
  ///
  /// Use this event to signify the user's completion of your app's on-boarding process.
  /// Add this to a funnel with tutorialBegin to gauge the completion rate of your on-boarding process.
  public func tutorialComplete() async throws {
    try await log(eventName: .tutorialComplete, parameters: [:])
  }

  /// View Item event.
  ///
  /// This event signifies that a user has viewed an item.
  /// Use the appropriate parameters to contextualize the event.
  /// Use this event to discover the most popular items viewed in your app.
  public func viewItem(
    items: [Item],
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .viewItem,
      parameters: [
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// View Item List event.
  ///
  /// Log this event when a user sees a list of items or offerings.
  public func viewItemList(
    items: [Item],
    itemListId: String? = nil,
    itemListName: String? = nil
  ) async throws {
    try await log(
      eventName: .viewItemList,
      parameters: [
        .items: .array(items.map { .dictionary($0.paramterers) }),
        .itemListId: itemListId.map { .string($0) },
        .itemListName: itemListName.map { .string($0) },
      ]
    )
  }

  /// View Search Results event.
  ///
  /// Log this event when the user has been presented with the results of a search.
  public func viewSearchResults(
    term: String
  ) async throws {
    try await log(
      eventName: .viewSearchResults,
      parameters: [
        .searchTerm: .string(term)
      ]
    )
  }

  /// Join Group event.
  ///
  /// Log this event when a user joins a group such as a guild, team or family.
  /// Use this event to analyze how popular certain groups or social features are in your app.
  public func joinGroup(
    groupId: String
  ) async throws {
    try await log(
      eventName: .joinGroup,
      parameters: [
        .groupId: .string(groupId)
      ]
    )
  }
}
