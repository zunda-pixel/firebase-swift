import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension Auth {
  private struct Body: Sendable, Hashable, Codable {
    var email: String
    var continueUrl: URL
    var requestType = "EMAIL_SIGNIN"
  }

  public func sendSignUpLink(
    email: String,
    continueUrl: URL
  ) async throws {
    let endpoint = URL(
      string: "https://www.googleapis.com/identitytoolkit/v3/relyingparty/getOobConfirmationCode")!
      .appending(queryItems: [.init(name: "key", value: apiKey)])

    let body = Body(email: email, continueUrl: continueUrl)
    let bodyData = try! JSONEncoder().encode(body)

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [.contentType: "application/json"]
    )

    let (data, _) = try await self.httpClient.execute(for: request, from: bodyData)

    _ = try self.decode(EmailProviderResponse.self, from: data)
  }
}

private struct EmailProviderResponse: Sendable, Hashable, Codable {
  var email: String
}
