enum FirestoreDecodingError: Error {
  case typeMismatch(any Any.Type, debugDescription: String)
  case dataCorrupted(any Any.Type, debugDescription: String)
  case missingKey(key: String)
}
