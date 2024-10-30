import Foundation

extension Storage {
  /// Esacape String
  /// https://github.com/firebase/firebase-ios-sdk/blob/424516b5ab552a07720927b39294e6cbe99f1306/FirebaseStorage/Sources/StorageUploadTask.swift#L250
  /// - Parameter value: <#value description#>
  /// - Returns: <#description#>
  func percentEncode(_ value: String) -> String {
    let gcsObjectAllowedCharacterSet =
      "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~!$'()*,=:@"
    let allowedCharacters = CharacterSet(charactersIn: gcsObjectAllowedCharacterSet)
    return value.addingPercentEncoding(withAllowedCharacters: allowedCharacters)!
  }
}
