extension Analytics {

  /// Close Convert  Lead Event.
  ///
  /// This event measures when a lead has been converted and closed (for example, through a purchase).
  public func closeConvertLead(
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .closeConvertLead,
      parameters: [
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// Close Unconvert Lead Event.
  ///
  /// This event measures when a user is marked as not becoming a converted lead, along with the reason.
  public func closeUnConvertLead(
    price: Price? = nil,
    reason: String? = nil
  ) async throws {
    try await log(
      eventName: .closeUnconvertLead,
      parameters: [
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
        .unconvertLeadReason: reason.map { .string($0) },
      ]
    )
  }

  /// Disqualify Lead  Event.
  ///
  /// This event measures when a lead is generated.
  public func disqualifyLead(
    price: Price? = nil,
    reason: String? = nil
  ) async throws {
    try await log(
      eventName: .disqualifyLead,
      parameters: [
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
        .disqualifiedLeadReason: reason.map { .string($0) },
      ]
    )
  }

  /// Qualify Lead  Event.
  ///
  /// This event measures when a user is marked as meeting the criteria to become a qualified lead.
  public func qualifyLead(
    price: Price? = nil
  ) async throws {
    try await log(
      eventName: .qualifyLead,
      parameters: [
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
      ]
    )
  }

  /// Working Lead  Event.
  ///
  /// This event measures when a user contacts or is contacted by a representative.
  public func workingLead(
    price: Price? = nil,
    leadStatus: String? = nil
  ) async throws {
    try await log(
      eventName: .workingLead,
      parameters: [
        .currency: price.map { .string($0.currency.rawValue.uppercased()) },
        .value: price.map { .float($0.value) },
        .leadStatus: leadStatus.map { .string($0) },
      ]
    )
  }
}
