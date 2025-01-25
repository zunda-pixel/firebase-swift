import Foundation

extension Analytics {

  /// Level Start event.
  ///
  /// Log this event when the user starts a new level.
  public func levelStart(
    levelName: String
  ) async throws {
    try await log(
      eventName: .levelStart,
      parameters: [
        .levelName: .string(levelName)
      ]
    )
  }

  /// Level Up event.
  ///
  /// This event signifies that a player has leveled up in your gaming app.
  /// It can help you gauge the level distribution of your userbase and help you identify certain levels that are difficult to pass.
  public func levelUp(
    level: UInt,
    character: String? = nil
  ) async throws {
    try await log(
      eventName: .levelUp,
      parameters: [
        .level: .uint(level),
        .character: character.map { .string($0) },
      ]
    )
  }

  /// Level End event.
  ///
  /// Log this event when the user finishes a level.
  public func levelEnd(
    levelName: String,
    success: Bool
  ) async throws {
    try await log(
      eventName: .levelEnd,
      parameters: [
        .levelName: .string(levelName),
        .success: .uint(success ? 1 : 0),
      ]
    )
  }

  /// Post Score event.
  ///
  /// Log this event when the user posts a score in your gaming app.
  /// This event can help you understand how users are actually performing in your game and it can help you correlate high scores with certain audiences or behaviors.
  public func postScore(
    score: UInt,
    level: UInt? = nil,
    character: String? = nil
  ) async throws {
    try await log(
      eventName: .postScore,
      parameters: [
        .score: .uint(score),
        .level: level.map { .uint($0) },
        .character: character.map { .string($0) },
      ]
    )
  }

  /// Unlock Achievement event.
  ///
  /// Log this event when the user has unlocked an achievement in your game.
  /// Since achievements generally represent the breadth of a gaming experience, this event can help you understand how many users are experiencing all that your game has to offer.
  public func unlockAchievement(
    achievementId: String
  ) async throws {
    try await log(
      eventName: .unlockAchievement,
      parameters: [
        .achievementId: .string(achievementId)
      ]
    )
  }
}
