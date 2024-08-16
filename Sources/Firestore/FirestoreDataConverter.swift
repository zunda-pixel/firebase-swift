import Foundation

enum FirestoreDataConverter {
  static func extractionValue(valueType: ValueType, value: AnyHashable) throws -> AnyHashable {
    switch valueType {
    case .stringValue:
      guard let value = value as? String else {
        throw FirestoreDecodingError.typeMismatch(
          String.self,
          debugDescription: "\(value) Value type mismatch"
        )
      }
      return value
    case .booleanValue:
      guard let value = value as? Bool else {
        throw FirestoreDecodingError.typeMismatch(
          Bool.self,
          debugDescription: "\(value) Value type mismatch"
        )
      }
      return value
    case .timestampValue:
      guard let dateString = value as? String else {
        throw FirestoreDecodingError.typeMismatch(
          Date.self,
          debugDescription: "\(value) Value type mismatch"
        )
      }
      let formatter = ISO8601DateFormatter()
      formatter.formatOptions.insert(.withFractionalSeconds)
      guard let date = formatter.date(from: dateString) else {
        throw FirestoreDecodingError.dataCorrupted(
          Date.self,
          debugDescription: "\(value) Value type dataCorrupted"
        )
      }
      return date.timeIntervalSinceReferenceDate
    case .integerValue:
      guard let value = value as? String else {
        throw FirestoreDecodingError.typeMismatch(
          (any Numeric).self,
          debugDescription: "\(value) Value type mismatch"
        )
      }
      guard let value = Double(value) else {
        throw FirestoreDecodingError.dataCorrupted(
          (any Numeric).self,
          debugDescription: "\(value) Value type dataCorrupted"
        )
      }
      return value
    case .geoPointValue:
      guard let value = value as? [String: Double] else {
        throw FirestoreDecodingError.typeMismatch(
          [String: Double].self,
          debugDescription: "\(value) Value type mismatch"
        )
      }
      return value
    case .arrayValue:
      guard let keyValues: [AnyHashable] = (value as? [String: [AnyHashable]])?.first?.value else {
        throw FirestoreDecodingError.typeMismatch(
          Array<AnyHashable>.self,
          debugDescription: "\(value) Value type mismatch"
        )
      }
      return try keyValues.map { keyValues in
        guard let keyValues = (keyValues as? [String: AnyHashable])?.first else {
          throw FirestoreDecodingError.dataCorrupted(
            [String: AnyHashable].self,
            debugDescription: "\(value) Value type dataCorrupted"
          )
        }
        return try extractionValue(
          valueType: ValueType(rawValue: keyValues.key)!,
          value: keyValues.value
        )
      }
    }
  }

  static func removeNestedValueKey(keyValues: [String: [String: AnyHashable]]) throws -> Data {
    let objects: [(String, AnyHashable)] = try keyValues.map { key, objects in
      let object = objects.first!
      return try (
        key,
        extractionValue(
          valueType: ValueType(rawValue: object.key)!,
          value: object.value
        )
      )
    }

    let result: [String: AnyHashable] = objects.reduce(into: [String: AnyHashable]()) {
      partialResult, keyValue in
      partialResult[keyValue.0] = keyValue.1
    }

    return try JSONSerialization.data(withJSONObject: result)
  }
}

enum ValueType: String {
  case stringValue
  case booleanValue
  case geoPointValue
  case timestampValue
  case integerValue
  case arrayValue
}
