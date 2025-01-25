import ProtobufKit

struct NestedValue<Value: ProtobufMessage & Equatable>: ProtobufMessage, Equatable {
  var value: Value

  init(value: Value) {
    self.value = value
  }

  init(from decoder: inout ProtobufDecoder) throws {
    var value: Value?

    while let field = try decoder.nextField() {
      switch field.tag {
      case 1:
        value = try decoder.messageField(field)
      default: throw ProtobufDecodingError.unknownError
      }
    }

    if let value {
      self.value = value
    } else {
      throw ProtobufDecodingError.missingField
    }
  }

  func encode(to encoder: inout ProtobufEncoder) throws {
    try encoder.messageField(1, value)
  }
}

enum ProtobufDecodingError: Error {
  case missingField
  case unknownError
}
