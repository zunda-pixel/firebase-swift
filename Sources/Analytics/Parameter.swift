import ProtobufKit

public enum Parameter {
  public struct Key: Sendable, Hashable, ExpressibleByStringLiteral, Equatable {
    public var rawValue: String

    public init(stringLiteral value: String) {
      self.rawValue = value
    }
  }

  public enum Value: Sendable, ProtobufMessage, Equatable {
    case string(String)
    case uint(UInt)
    case float(Double)
    case dictionary([Parameter.Key: Parameter.Value])
    case array([Parameter.Value])

    static func bool(_ value: Bool) -> Self {
      .uint(value ? 1 : 0)
    }

    public init(from decoder: inout ProtobufDecoder) throws {
      var value: Parameter.Value?

      var keyValues: [Parameter.Key: Parameter.Value] = [:]
      var values: [Parameter.Value] = []

      while let field = try decoder.nextField() {
        switch field.tag {
        case 1: value = .string(try decoder.stringField(field))
        case 2: value = .uint(try decoder.uintField(field))
        case 5: value = .float(try decoder.doubleField(field))
        case 6:
          if let keyValue: KeyValue = try? decoder.messageField(field) {
            keyValues[keyValue.key] = keyValue.value
          } else if let value: Parameter.Value = try? decoder.messageField(field) {
            values.append(value)
          } else {
            throw ProtobufDecodingError.unknownError
          }
        default: throw ProtobufDecodingError.unknownError
        }
      }

      if !keyValues.isEmpty {
        value = .dictionary(keyValues)
      } else if !values.isEmpty {
        value = .array(values)
      }

      if let value {
        self = value
      } else {
        throw ProtobufDecodingError.missingField
      }
    }

    public func encode(to encoder: inout ProtobufEncoder) throws {
      switch self {
      case let .string(value):
        try encoder.stringField(1, value, defaultValue: nil)
      case let .uint(value):
        encoder.uintField(2, value, defaultValue: nil)
      case let .float(value):
        encoder.doubleField(5, value, defaultValue: nil)
      case let .dictionary(value):
        for (key, value) in value {
          try encoder.messageField(6, KeyValue(key: key, value: value))
        }
      case let .array(values):
        for item in values {
          try encoder.messageField(6, item)
        }
      }
    }
  }
}

extension Parameter.Value: ExpressibleByStringLiteral {
  public init(stringLiteral value: String) {
    self = .string(value)
  }
}

extension Parameter.Value: ExpressibleByFloatLiteral {
  public init(floatLiteral value: FloatLiteralType) {
    self = .float(value)
  }
}

extension Parameter.Value: ExpressibleByBooleanLiteral {
  public init(booleanLiteral value: BooleanLiteralType) {
    self = .bool(value)
  }
}

extension Parameter.Key {
  /// The name of the event (String). app, web or auto
  public static let platform: Self = "_o"
  /// Game achievement ID.
  public static let achievementId: Self = "achievement_id"
  /// The ad format (e.g. Banner, Interstitial, Rewarded, Native, Rewarded Interstitial, Instream).
  public static let adFormat: Self = "ad_format"
  /// Ad Network Click ID. Used for network-specific click IDs which vary in format.
  public static let adNetworkClickId: Self = "aclid"
  /// The ad platform (e.g. MoPub, IronSource)
  public static let adPlatform: Self = "ad_platform"
  /// The ad source (e.g. AdColony)
  public static let adSource: Self = "ad_source"
  /// The ad unit name (e.g. Banner_03)
  public static let adUnitName: Self = "ad_unit_name"
  /// A product affiliation to designate a supplying company or brick and mortar store location
  public static let affiliation: Self = "affiliation"
  /// Campaign custom parameter. Used as a method of capturing custom data in a campaign.
  /// Use varies by network.
  public static let campaignCutomData: Self = "cp1"
  /// The individual campaign name, slogan, promo code, etc. Some networks have pre-defined macro to
  /// capture campaign information, otherwise can be populated by developer. Highly Recommended
  public static let campaign: Self = "campaign"
  /// Campaign ID . Used for keyword analysis to identify a specific product promotion or
  /// strategic campaign. This is a required key for GA4 data import.
  public static let campaignId: Self = "campaign_id"
  /// Character used in game. ex) beat_boss
  public static let character: Self = "character"
  /// Campaign content.
  public static let campaignContent: Self = "content"
  /// Type of content selected. ex) news article
  public static let contentType: Self = "content_type"
  /// Coupon code used for a purchase.
  /// ex) SUMMER_FUN
  public static let coupon: Self = "coupon"
  /// Creative Format. Used to identify the high-level classification of the type of ad
  /// served by a specific campaign.
  public static let creativeFormat: Self = "creative_format"
  /// The name of a creative used in a promotional spot.
  public static let creativeName: Self = "creative_name"
  /// The name of a creative slot.
  public static let creativeSlot: Self = "creative_slot"
  /// Currency of the purchase or items associated with the event, in 3-letter ISO_4217 format.
  public static let currency: Self = "currency"
  /// Flight or Travel destination.
  public static let destination: Self = "destination"
  /// Monetary value of discount associated with a purchase (Double).
  public static let discount: Self = "discount"
  /// Indicates that the associated event should either extend the current session or start a new
  /// session if no session was active when the event was logged. Specify 1 to extend the current
  /// session or to start a new session; any other value will not extend or start a session.
  public static let extendSession: Self = "extend_session"
  /// Flight number for travel events.
  public static let flightNumber: Self = "flight_number"
  /// Group/clan/guild ID.
  public static let groupId: Self = "group_id"
  /// The index of the item in a list.
  public static let index: Self = "index"
  ///  Item brand.
  public static let itemBrand: Self = "item_brand"
  /// Item category (context-specific) (String).
  public static let itemCategory: Self = "item_category"
  /// Item Category (context-specific) (String).
  public static let itemCategory2: Self = "item_category2"
  /// Item Category (context-specific) (String).
  public static let itemCategory3: Self = "item_category3"
  /// Item Category (context-specific) (String).
  public static let itemCategory4: Self = "item_category4"
  /// Item Category (context-specific) (String).
  public static let itemCategory5: Self = "item_category5"
  /// Item ID (context-specific) (String).
  public static let itemId: Self = "item_id"
  /// The ID of the list in which the item was presented to the user.
  public static let itemListId: Self = "item_list_id"
  /// The name of the list in which the item was presented to the user.
  public static let itemListName: Self = "item_list_name"
  /// Item Name (context-specific).
  public static let itemName: Self = "item_name"
  /// Item variant.
  public static let itemVariant: Self = "item_variant"
  /// The list of items involved in the transaction expressed.
  public static let items: Self = "items"
  /// Level in game (Int).
  public static let level: Self = "level"
  /// The name of a level in a game (String).
  public static let levelName: Self = "level_name"
  /// Location (String). The Google [Place ID](https://developers.google.com/places/place-id) that corresponds to the associated event. Alternatively, you can supply your own custom
  public static let location: Self = "location"
  /// The location associated with the event. Preferred to be the Google
  /// [Place ID](https://developers.google.com/places/place-id) that corresponds to the
  /// associated item but could be overridden to a custom location ID string.(String).
  public static let locationId: Self = "location_id"
  /// Marketing Tactic (String). Used to identify the targeting criteria applied to a specific
  /// campaign.
  public static let marketingTactic: Self = "marketing_tactic"
  /// The advertising or marketing medium, for example: cpc, banner, email, push. Highly recommended
  /// (String).
  public static let medium: Self = "medium"
  /// A particular approach used in an operation; for example, "facebook" or "email" in the context
  /// of a sign_up or login event. (String).
  public static let method: Self = "method"
  /// Number of nights staying at hotel (Int).
  public static let numberOfNights: Self = "number_of_nights"
  /// Number of passengers traveling (Int).
  public static let numberOfPassengers: Self = "number_of_passengers"
  /// Number of rooms for travel events (Int).
  public static let numberOfRooms: Self = "number_of_rooms"
  /// Flight or Travel origin (String).
  public static let origin: Self = "origin"
  /// The chosen method of payment (String).
  /// ex) Visa, Mastercard, Paypal
  public static let paymentType: Self = "payment_type"
  /// Purchase price (Double).
  public static let price: Self = "price"
  /// The ID of a product promotion (String).
  /// ex) ABC123
  public static let promotionId: Self = "promotion_id"
  /// The name of a product promotion (String).
  /// ex) Summer Sale
  public static let promotionName: Self = "promotion_name"
  /// Purchase quantity (Int).
  /// ex) 1
  public static let quantity: Self = "quantity"
  /// Score in game (Int).
  public static let score: Self = "score"
  /// Current screen class, such as the class name of the UIViewController, logged with screen_view
  /// event and added to every event (String).
  /// ex) LoginViewController
  public static let screenClass: Self = "screen_class"
  /// Current screen name, such as the name of the UIViewController, logged with screen_view event and
  /// added to every event (String).
  /// ex) LoginView
  public static let screenName: Self = "screen_name"
  /// The search string/keywords used (String).
  /// ex) purple t-shirt
  public static let searchTerm: Self = "search_term"
  /// Shipping cost associated with a transaction (Double).
  public static let shipping: Self = "shipping"
  /// The shipping tier (e.g. Ground, Air, Next-day) selected for delivery of the purchased item
  /// (String).
  /// ex) Ground
  public static let shippingTier: Self = "shipping_tier"
  /// The origin of your traffic, such as an Ad network (for example, google) or partner (urban
  /// airship). Identify the advertiser, site, publication, etc. that is sending traffic to your
  /// property. Highly recommended (String).
  /// ex) InMobi
  public static let source: Self = "source"
  /// Source Platform (String). Used to identify the platform responsible for directing traffic to a
  /// given Analytics property (e.g., a buying platform where budgets, targeting criteria, etc. are
  /// set, a platform for managing organic traffic data, etc.).
  /// ex) sa360
  public static let sourcePlatform: Self = "source_platform"
  /// The result of an operation. Specify 1 to indicate success and 0 to indicate failure (Int).
  public static let success: Self = "success"
  /// Tax cost associated with a transaction (Double).
  public static let tax: Self = "tax"
  /// If you're manually tagging keyword campaigns, you should use utm_term to specify the keyword
  /// (String).
  /// ex) game
  public static let term: Self = "term"
  /// The unique identifier of a transaction (String).
  public static let transactionId: Self = "transaction_id"
  /// Travel class (String).
  /// ex) business
  public static let travelClass: Self = "travel_class"
  /// A context-specific numeric value which is accumulated automatically for each event type.
  /// This is a general purpose parameter that is useful for accumulating a key metric that pertains to an event.
  /// Examples include revenue, distance, time and points. Value should be specified as Int or Double.
  /// Notes: Values for pre-defined currency-related events (such as @c ``Event.ddToCart``)
  /// should be supplied using Double and must be accompanied by a @c ``Parameter.currency`` parameter.
  /// The valid range of accumulated values is [-9,223,372,036,854.77, 9,223,372,036,854.77].
  /// Supplying a non-numeric value, omitting the corresponding @c ``Parameter.currency`` parameter, or supplying an invalid
  /// [currency code](https://goo.gl/qqX3J2) for conversion events will cause that conversion to be omitted from reporting.
  public static let value: Self = "value"
  /// Name of virtual currency type.
  /// ex) virtual_currency_name
  public static let virtualCurrencyName: Self = "virtual_currency_name"

  /// The status of the lead.
  public static let leadStatus: Self = "lead_status"

  /// The reason the lead was unconverted.
  public static let unconvertLeadReason: Self = "unconvert_lead_reason"

  /// The reason a lead was marked as disqualified.
  public static let disqualifiedLeadReason: Self = "disqualified_lead_reason"
}
