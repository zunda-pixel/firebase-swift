import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var idToken: String
  }
  
  /// Delete account
  /// You can delete a current user by issuing an HTTP POST request to the Auth deleteAccount endpoint.
  /// https://firebase.google.com/docs/reference/rest/auth#section-delete-account
  /// - Parameters:
  ///   - idToken: The Firebase ID token of the user to delete.
  /// - Returns: ``DeleteAccountResponse``
  public func deleteAccount(idToken: String) async throws -> DeleteAccountResponse {
    let path = "accounts:delete"
    let endpoint = baseURL
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: apiKey)])
    
    let body = Body(idToken: idToken)
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )
    
    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)
    
    let response = try JSONDecoder().decode(DeleteAccountResponse.self, from: data)
    
    return response
  }
}

public struct DeleteAccountResponse: Sendable, Hashable, Codable {
  public var kind: String
}