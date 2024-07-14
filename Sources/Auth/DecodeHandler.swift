import Foundation

extension Auth {
  func decode<T>(_ type: T.Type, from data: Data) throws -> T where T : Decodable {
    let decoder = JSONDecoder()
    
    do {
      return try decoder.decode(T.self, from: data)
    } catch {
      let errorsResponse = try decoder.decode(ErrorsResponse.self, from: data)
      throw errorsResponse
    }
  }
}
