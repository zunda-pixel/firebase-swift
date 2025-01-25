import ProtobufKit

struct Payload: ProtobufMessage, Equatable {
  var value: UInt
  var events: [EventPayload]?
  var sessionInformations: [ValueKeyValue]
  var value4: UInt?
  var value5: UInt?
  var value6: UInt?
  var value7: UInt?
  var os: String
  var osVersion: String
  var deviceModel: String
  var value11: String?
  var value12: UInt?
  var installMethod: String
  var bundleId: String
  var appVersion: String
  var value17: UInt?
  var value18: UInt?
  var value21: String?
  var value23: UInt?
  var googleAppId: String
  var value26: UInt?
  var value27: String?
  var value30: String?
  var value31: UInt?
  var value35: UInt?
  var value39: UInt?
  var value45: UInt?
  var value52: String?
  var value64: String?
  var value71: String?
  var value72: UInt?
  var value77: UInt?

  init(
    value: UInt,
    events: [EventPayload]? = nil,
    sessionInformations: [ValueKeyValue],
    value4: UInt? = nil,
    value5: UInt? = nil,
    value6: UInt? = nil,
    value7: UInt? = nil,
    os: String,
    osVersion: String,
    deviceModel: String,
    value11: String? = nil,
    value12: UInt? = nil,
    installMethod: String,
    bundleId: String,
    appVersion: String,
    value17: UInt? = nil,
    value18: UInt? = nil,
    value21: String? = nil,
    value23: UInt? = nil,
    googleAppId: String,
    value26: UInt? = nil,
    value27: String? = nil,
    value30: String? = nil,
    value31: UInt? = nil,
    value35: UInt? = nil,
    value39: UInt? = nil,
    value45: UInt? = nil,
    value52: String? = nil,
    value64: String? = nil,
    value71: String? = nil,
    value72: UInt? = nil,
    value77: UInt? = nil
  ) {
    self.value = value
    self.events = events
    self.sessionInformations = sessionInformations
    self.value4 = value4
    self.value5 = value5
    self.value6 = value6
    self.value7 = value7
    self.os = os
    self.osVersion = osVersion
    self.deviceModel = deviceModel
    self.value11 = value11
    self.value12 = value12
    self.installMethod = installMethod
    self.bundleId = bundleId
    self.appVersion = appVersion
    self.value17 = value17
    self.value18 = value18
    self.value21 = value21
    self.value23 = value23
    self.googleAppId = googleAppId
    self.value26 = value26
    self.value27 = value27
    self.value30 = value30
    self.value31 = value31
    self.value35 = value35
    self.value39 = value39
    self.value45 = value45
    self.value52 = value52
    self.value64 = value64
    self.value71 = value71
    self.value72 = value72
    self.value77 = value77
  }

  init(from decoder: inout ProtobufDecoder) throws {
    var value: UInt?
    var events: [EventPayload] = []
    var sessionInformations: [ValueKeyValue] = []
    var value4: UInt?
    var value5: UInt?
    var value6: UInt?
    var value7: UInt?
    var os: String?
    var osVersion: String?
    var deviceModel: String?
    var value11: String?
    var value12: UInt?
    var installMethod: String?
    var bundleId: String?
    var appVersion: String?
    var value17: UInt?
    var value18: UInt?
    var value21: String?
    var value23: UInt?
    var googleAppId: String?
    var value26: UInt?
    var value27: String?
    var value30: String?
    var value31: UInt?
    var value35: UInt?
    var value39: UInt?
    var value45: UInt?
    var value52: String?
    var value64: String?
    var value71: String?
    var value72: UInt?
    var value77: UInt?

    while let field = try decoder.nextField() {
      switch field.tag {
      case 1: value = try decoder.uintField(field)
      case 2:
        let event: EventPayload = try decoder.messageField(field)
        events.append(event)
      case 3:
        let session: ValueKeyValue = try decoder.messageField(field)
        sessionInformations.append(session)
      case 4: value4 = try decoder.uintField(field)
      case 5: value5 = try decoder.uintField(field)
      case 6: value6 = try decoder.uintField(field)
      case 7: value7 = try decoder.uintField(field)
      case 8: os = try decoder.stringField(field)
      case 9: osVersion = try decoder.stringField(field)
      case 10: deviceModel = try decoder.stringField(field)
      case 11: value11 = try decoder.stringField(field)
      case 12: value12 = try decoder.uintField(field)
      case 13: installMethod = try decoder.stringField(field)
      case 14: bundleId = try decoder.stringField(field)
      case 16: appVersion = try decoder.stringField(field)
      case 17: value17 = try decoder.uintField(field)
      case 18: value18 = try decoder.uintField(field)
      case 21: value21 = try decoder.stringField(field)
      case 23: value23 = try decoder.uintField(field)
      case 25: googleAppId = try decoder.stringField(field)
      case 26: value26 = try decoder.uintField(field)
      case 27: value27 = try decoder.stringField(field)
      case 30: value30 = try decoder.stringField(field)
      case 31: value31 = try decoder.uintField(field)
      case 35: value35 = try decoder.uintField(field)
      case 39: value39 = try decoder.uintField(field)
      case 45: value45 = try decoder.uintField(field)
      case 52: value52 = try decoder.stringField(field)
      case 64: value64 = try decoder.stringField(field)
      case 71: value71 = try decoder.stringField(field)
      case 72: value72 = try decoder.uintField(field)
      case 77: value77 = try decoder.uintField(field)
      default: throw ProtobufDecodingError.unknownError
      }
    }

    if let value, let os, let osVersion, let deviceModel, let installMethod, let bundleId,
      let appVersion, let googleAppId
    {
      self.value = value
      self.events = events
      self.sessionInformations = sessionInformations
      self.value4 = value4
      self.value5 = value5
      self.value6 = value6
      self.value7 = value7
      self.os = os
      self.osVersion = osVersion
      self.deviceModel = deviceModel
      self.value11 = value11
      self.value12 = value12
      self.installMethod = installMethod
      self.bundleId = bundleId
      self.appVersion = appVersion
      self.value17 = value17
      self.value18 = value18
      self.value21 = value21
      self.value23 = value23
      self.googleAppId = googleAppId
      self.value26 = value26
      self.value27 = value27
      self.value30 = value30
      self.value31 = value31
      self.value35 = value35
      self.value39 = value39
      self.value45 = value45
      self.value52 = value52
      self.value64 = value64
      self.value71 = value71
      self.value72 = value72
      self.value77 = value77
    } else {
      throw ProtobufDecodingError.missingField
    }
  }

  func encode(to encoder: inout ProtobufEncoder) throws {
    encoder.uintField(1, value, defaultValue: nil)
    for event in events ?? [] {
      try encoder.messageField(2, event)
    }
    for item in sessionInformations {
      try encoder.messageField(3, item)
    }
    value4.map { encoder.uintField(4, $0, defaultValue: nil) }
    value5.map { encoder.uintField(5, $0, defaultValue: nil) }
    value6.map { encoder.uintField(6, $0, defaultValue: nil) }
    value7.map { encoder.uintField(7, $0, defaultValue: nil) }
    try encoder.stringField(8, os, defaultValue: nil)
    try encoder.stringField(9, osVersion, defaultValue: nil)
    try encoder.stringField(10, deviceModel, defaultValue: nil)
    try value11.map { try encoder.stringField(11, $0, defaultValue: nil) }
    value12.map { encoder.uintField(12, $0, defaultValue: nil) }
    try encoder.stringField(13, installMethod, defaultValue: nil)
    try encoder.stringField(14, bundleId, defaultValue: nil)
    try encoder.stringField(16, appVersion, defaultValue: nil)
    value17.map { encoder.uintField(17, $0, defaultValue: nil) }
    value18.map { encoder.uintField(18, $0, defaultValue: nil) }
    try value21.map { try encoder.stringField(21, $0, defaultValue: nil) }
    value23.map { encoder.uintField(23, $0, defaultValue: nil) }
    try encoder.stringField(25, googleAppId, defaultValue: nil)
    value26.map { encoder.uintField(26, $0) }
    try value27.map { try encoder.stringField(27, $0, defaultValue: nil) }
    try value30.map { try encoder.stringField(30, $0, defaultValue: nil) }
    value31.map { encoder.uintField(31, $0, defaultValue: nil) }
    value35.map { encoder.uintField(35, $0, defaultValue: nil) }
    value39.map { encoder.uintField(39, $0, defaultValue: nil) }
    value45.map { encoder.uintField(45, $0, defaultValue: nil) }
    try value52.map { try encoder.stringField(52, $0, defaultValue: nil) }
    try value64.map { try encoder.stringField(64, $0, defaultValue: nil) }
    try value71.map { try encoder.stringField(71, $0, defaultValue: nil) }
    value72.map { encoder.uintField(72, $0, defaultValue: nil) }
    value77.map { encoder.uintField(77, $0, defaultValue: nil) }
  }
}
