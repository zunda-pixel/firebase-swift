import ProtobufKit

struct EventPayload: ProtobufMessage & Equatable {
  var parameters: [Parameter.Key: Parameter.Value]
  var eventName: Event.Name
  var startDate: UInt?
  var endDate: UInt

  init(
    parameters: [Parameter.Key: Parameter.Value],
    eventName: Event.Name,
    startDate: UInt,
    endDate: UInt
  ) {
    self.parameters = parameters
    self.eventName = eventName
    self.startDate = startDate
    self.endDate = endDate
    self.endDate = endDate
  }

  func encode(to encoder: inout ProtobufKit.ProtobufEncoder) throws {
    for parameter in parameters {
      try encoder.messageField(1, KeyValue(key: parameter.key, value: parameter.value))
    }
    try encoder.stringField(2, eventName.rawValue, defaultValue: nil)
    startDate.map { encoder.uintField(4, $0, defaultValue: nil) }
    encoder.uintField(3, endDate, defaultValue: nil)
  }

  init(from decoder: inout ProtobufDecoder) throws {
    var eventName: Event.Name?
    var startDate: UInt?
    var endDate: UInt?
    var parameters: [Parameter.Key: Parameter.Value] = [:]
    while let field = try decoder.nextField() {
      switch field.tag {
      case 1:
        let parameter: KeyValue = try decoder.messageField(field)
        parameters[parameter.key] = parameter.value
      case 2: eventName = .init(stringLiteral: try decoder.stringField(field))
      case 3: endDate = try decoder.uintField(field)
      case 4: startDate = try decoder.uintField(field)
      default: throw ProtobufDecodingError.unknownError
      }
    }

    if let eventName, let endDate {
      self.parameters = parameters
      self.eventName = eventName
      self.startDate = startDate
      self.endDate = endDate
    } else {
      throw ProtobufDecodingError.missingField
    }
  }
}

struct KeyValue: ProtobufMessage {
  var key: Parameter.Key
  var value: Parameter.Value

  init(key: Parameter.Key, value: Parameter.Value) {
    self.key = key
    self.value = value
  }

  init(from decoder: inout ProtobufDecoder) throws {
    var key: Parameter.Key?
    var value: Parameter.Value?
    var values: [Parameter.Value] = []

    while let field = try decoder.nextField() {
      switch field.tag {
      case 1: key = .init(stringLiteral: try decoder.stringField(field))
      case 2: value = .string(try decoder.stringField(field))
      case 3: value = .uint(try decoder.uintField(field))
      case 5: value = .float(try decoder.doubleField(field))
      case 6:
        let arrayValue: Array6 = try decoder.messageField(field)
        values.append(arrayValue.value)
      default: throw ProtobufDecodingError.unknownError
      }
    }

    if !values.isEmpty {
      value = .array(values)
    }

    if let key, let value {
      self.key = key
      self.value = value
    } else {
      throw ProtobufDecodingError.missingField
    }
  }

  func encode(to encoder: inout ProtobufEncoder) throws {
    try encoder.stringField(1, key.rawValue, defaultValue: nil)
    switch value {
    case let .string(value):
      try encoder.stringField(2, value, defaultValue: nil)
    case let .uint(value):
      encoder.uintField(3, value, defaultValue: nil)
    case let .float(value):
      encoder.doubleField(5, value, defaultValue: nil)
    case let .dictionary(values):
      let arayValue = Array6(value: .dictionary(values))
      try encoder.messageField(6, arayValue)
    case let .array(values):
      for value in values {
        let arayValue = Array6(value: value)
        try encoder.messageField(6, arayValue)
      }
    }
  }
}

struct Array6: ProtobufDecodableMessage, ProtobufEncodableMessage {
  var value: Parameter.Value

  init(value: Parameter.Value) {
    self.value = value
  }

  init(from decoder: inout ProtobufDecoder) throws {
    var keyValues: [Parameter.Key: Parameter.Value] = [:]
    var values: [Parameter.Value] = []

    while let field = try decoder.nextField() {
      switch field.tag {
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
      self.value = .dictionary(keyValues)
    } else if !values.isEmpty {
      self.value = .array(values)
    } else {
      throw ProtobufDecodingError.unknownError
    }
  }

  func encode(to encoder: inout ProtobufEncoder) throws {
    switch value {
    case .dictionary(let value):
      for item in value {
        try encoder.messageField(6, KeyValue(key: item.key, value: item.value))
      }
    case .array(let array):
      for item in array {
        try encoder.messageField(6, item)
      }
    default:
      fatalError()
    }
  }
}
