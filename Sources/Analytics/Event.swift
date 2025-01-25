import ProtobufKit

public enum Event {
  public struct Name: Sendable, ExpressibleByStringLiteral, Equatable {
    public var rawValue: String

    public init(stringLiteral value: String) {
      self.rawValue = value
    }
  }
}

extension Event.Name {
  public static let adImpression: Self = "ad_impression"
  public static let addPaymentInfo: Self = "add_payment_info"
  public static let addShippingInfo: Self = "add_shipping_info"
  public static let addToCart: Self = "add_to_cart"
  public static let addToWithlist: Self = "add_to_wishlist"
  public static let appOpen: Self = "app_open"
  public static let beginCheckout: Self = "begin_checkout"
  public static let campaignDetails: Self = "campaign_details"
  public static let earnVirtualCurrency: Self = "earn_virtual_currency"
  public static let generateLead: Self = "generate_lead"
  public static let joinGroup: Self = "join_group"
  public static let levelEnd: Self = "level_end"
  public static let levelStart: Self = "level_start"
  public static let levelUp: Self = "level_up"
  public static let login: Self = "login"
  public static let postScore: Self = "post_score"
  public static let purchase: Self = "purchase"
  public static let refund: Self = "refund"
  public static let removeFromCart: Self = "remove_from_cart"
  public static let screenView: Self = "_vs"
  public static let search: Self = "search"
  public static let selectContent: Self = "select_content"
  public static let selectItem: Self = "select_item"
  public static let selectPromotion: Self = "select_promotion"
  public static let share: Self = "share"
  public static let signUp: Self = "sign_up"
  public static let spendVirtualCurrency: Self = "spend_virtual_currency"
  public static let tutorialBegin: Self = "tutorial_begin"
  public static let tutorialComplete: Self = "tutorial_complete"
  public static let unlockAchievement: Self = "unlock_achievement"
  public static let viewCart: Self = "view_cart"
  public static let viewItem: Self = "view_item"
  public static let viewItemList: Self = "view_item_list"
  public static let viewPromotion: Self = "view_promotion"
  public static let viewSearchResults: Self = "view_search_results"
  public static let exception: Self = "exception"
  public static let pageView: Self = "page_view"
  public static let timingComplete: Self = "timing_complete"
  public static let closeConvertLead: Self = "close_convert_lead"
  public static let closeUnconvertLead: Self = "close_unconvert_lead"
  public static let disqualifyLead: Self = "disqualify_lead"
  public static let qualifyLead: Self = "qualify_lead"
  public static let workingLead: Self = "working_lead"
}
