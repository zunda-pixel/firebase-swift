import Foundation
import HTTPClient
import HTTPClientFoundation
import HTTPTypes
import Testing

@testable import Firestore

let oauthApiKey = ProcessInfo.processInfo.environment["FIREBASE_OAUTH_TOKEN"]!
let projectName = ProcessInfo.processInfo.environment["FIREBASE_PROJECT_NAME"]!

let client = Firestore(
  oauthApiKey: oauthApiKey,
  projectName: projectName,
  httpClient: .urlSession(.shared)
)

@Test
func database() async throws {
  _ = try await client.database(databaseId: "tekitou123")
}

@Test
func documents() async throws {
  let documents = try await client.documents(
    databaseId: "tekitou123",
    documentId: "books",
    as: Book.self
  )

  let document = try #require(documents.first)
  let book = document.model

  #expect(document.name == "98ULHXM7uH05vrPEOjwp")
  #expect(document.createTime == Date(timeIntervalSinceReferenceDate: 745421071.7060001))
  #expect(document.updateTime == Date(timeIntervalSinceReferenceDate: 745432755.769))
  #expect(book.name == "Book1")
  #expect(book.age == 123)
  #expect(book.disabled == false)
  #expect(book.location == Location(latitude: 33, longitude: 44))
  #expect(book.fruits == ["mikan", "orange"])
  #expect(book.birthday == Date(timeIntervalSinceReferenceDate: 745858800.4089999))
}

struct Book: Codable {
  var name: String
  var age: Int
  var location: Location
  var disabled: Bool
  var birthday: Date
  var fruits: [String]
}

struct Location: Codable, Hashable {
  var latitude: Double
  var longitude: Double
}

@Test
func decodeNestModel() async throws {
  let json = """
    {
      "fruits": {
        "arrayValue": {
          "values": [
            {
              "stringValue": "mikan"
            },
            {
              "stringValue": "orange"
            }
          ]
        }
      },
      "location": {
        "geoPointValue": {
          "latitude": 33,
          "longitude": 44
        }
      },
      "age": {
        "integerValue": "123"
      },
      "name": {
        "stringValue": "Book1"
      },
      "disabled": {
        "booleanValue": false
      },
      "birthday": {
        "timestampValue": "2024-08-20T15:00:00.409Z"
      }
    }
    """

  let keyValues =
    try JSONSerialization.jsonObject(with: Data(json.utf8)) as! [String: [String: AnyHashable]]
  let data = try FirestoreDataConverter.removeNestedValueKey(keyValues: keyValues)

  let book = try JSONDecoder().decode(Book.self, from: data)

  #expect(book.name == "Book1")
  #expect(book.age == 123)
  #expect(book.disabled == false)
  #expect(book.location == Location(latitude: 33, longitude: 44))
  #expect(book.fruits == ["mikan", "orange"])
  #expect(book.birthday == Date(timeIntervalSinceReferenceDate: 745858800.4089999))
}

struct User: Codable {
  var age: Int
  var name: String
}
