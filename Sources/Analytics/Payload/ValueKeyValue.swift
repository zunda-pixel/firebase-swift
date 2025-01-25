import ProtobufKit

struct ValueKeyValue: ProtobufMessage, Equatable {
  var date: UInt
  var key: String
  var value: Parameter.Value

  init(
    date: UInt,
    key: String,
    value: Parameter.Value
  ) {
    self.date = date
    self.key = key
    self.value = value
  }

  init(from decoder: inout ProtobufDecoder) throws {
    var date: UInt?
    var key: String?
    var value: Parameter.Value?

    var keyValues: [Parameter.Key: Parameter.Value] = [:]
    var values: [Parameter.Value] = []

    while let field = try decoder.nextField() {
      switch field.tag {
      case 1: date = try decoder.uintField(field)
      case 2: key = try decoder.stringField(field)
      case 3: value = .string(try decoder.stringField(field))
      case 4: value = .uint(try decoder.uintField(field))
      case 6: value = .float(try decoder.doubleField(field))
      case 7:
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

    if let date, let key, let value {
      self.date = date
      self.key = key
      self.value = value
    } else {
      throw ProtobufDecodingError.missingField
    }
  }

  func encode(to encoder: inout ProtobufEncoder) throws {
    encoder.uintField(1, date, defaultValue: nil)
    try encoder.stringField(2, key, defaultValue: nil)
    switch value {
    case let .string(value):
      try encoder.stringField(3, value, defaultValue: nil)
    case let .uint(value):
      encoder.uintField(4, value, defaultValue: nil)
    case let .float(value):
      encoder.doubleField(6, value, defaultValue: nil)
    case let .dictionary(values):
      for item in values {
        try encoder.messageField(7, KeyValue(key: item.key, value: item.value))
      }
    case let .array(values):
      for item in values {
        try encoder.messageField(7, item)
      }
    }
  }
}
