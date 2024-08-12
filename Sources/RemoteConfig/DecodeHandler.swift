import Foundation

extension RemoteConfig {
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
    let decoder = JSONDecoder()
    print(String(decoding: data, as: UTF8.self))
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      let errorsResponse = try decoder.decode(RawErrorResponse.self, from: data)
      throw errorsResponse.error
    }
  }
}

private struct RawErrorResponse: Sendable, Hashable, Codable {
  var error: ErrorResponse
}