import Foundation

public struct Session: Sendable {
  /// 1の場合ユーザーの初めてのインタラクションであることを示す
  var firstInteraction: Bool  // _fi
  /// ユーザーがアプリまたはウェブサイトを最初に開いた時間(UNIXタイムスタンプ)を示しています。
  var firstOpenTime: TimeInterval  // _fot
  /// 0の場合、広告がパーソナライズされていることを示します
  var nonPersonalizedAds: Bool  // _npa
  /// セッションID
  /// タイムスタンプ形式で表現されることが多い
  var sessionId: UInt  // _sid
  /// セッションの回数を示します。そのユーザーにとって何回目のセッションかを示します
  var sessionNumber: UInt  // _sno
  /// ユーザーがこれまでにアプリやウェブサイトで費やした総時間を示します（単位は秒）
  var lifetimeEngagement: TimeInterval  // _lte
  /// 現在のセッションでユーザーが費やしたエンゲージメント時間を示します（単位は秒）
  var sessionEngagement: TimeInterval  // _se

  /// User ID
  ///
  /// This feature must be used in accordance with [Google's Privacy Policy](https://www.google.com/policies/privacy)
  /// The user ID to ascribe to the user of this app on this device, which must be non-empty and no more than 256 characters long.
  var userId: String?

  var parameters: [ValueKeyValue] {
    var params: [ValueKeyValue] = [
      .init(
        date: UInt(Date.now.timeIntervalSince1970 * 100),
        key: "_fi",
        value: .uint(firstInteraction ? 0 : 1)
      ),
      .init(
        date: UInt(Date.now.timeIntervalSince1970 * 100),
        key: "_fot",
        value: .uint(UInt(firstOpenTime))
      ),
      .init(
        date: UInt(Date.now.timeIntervalSince1970 * 100),
        key: "_npa",
        value: .uint(nonPersonalizedAds ? 1 : 0)
      ),
      .init(
        date: UInt(Date.now.timeIntervalSince1970 * 100),
        key: "_sid",
        value: .uint(sessionId)
      ),
      .init(
        date: UInt(Date.now.timeIntervalSince1970 * 100),
        key: "_sno",
        value: .uint(sessionNumber)
      ),
      .init(
        date: UInt(Date.now.timeIntervalSince1970 * 100),
        key: "_lte",
        value: .uint(UInt(lifetimeEngagement))
      ),
      .init(
        date: UInt(Date.now.timeIntervalSince1970 * 100),
        key: "_se",
        value: .uint(UInt(sessionEngagement))
      ),
    ]

    if let userId {
      params.append(
        .init(
          date: UInt(Date.now.timeIntervalSince1970 * 100),
          key: "_id",
          value: .string(userId)
        ))
    }

    return params
  }
}
