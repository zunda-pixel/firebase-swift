import Testing
import Foundation
import Storage

let bucket = ProcessInfo.processInfo.environment["FIREBASE_STORAGE_BUCKET"]!
let storage = Storage(httpClient: URLSession.shared)

@Test
func uploadItem() async throws {
  let svgFilepath = Bundle.module.url(forResource: "Swift_logo", withExtension: "svg")!
  let svgData = try Data(contentsOf: svgFilepath)
  let filePath = "images/swift/Swift_logo.svg"
  let contentType = "image/svg+xml"
  
  let item = try await storage.upload(
    bucket: bucket,
    filePath: filePath,
    data: svgData,
    contentType: contentType
  )
  
  #expect(item.bucket == bucket)
  #expect(item.name == filePath)
  #expect(item.contentType == contentType)
}

@Test
func getItem() async throws {
  let uploadedItem = try await storage.upload(
    bucket: bucket,
    filePath: "memos/\(UUID())",
    data: Data("Hello".utf8),
    contentType: "text/plain"
  )
  
  let item = try await storage.item(
    bucket: uploadedItem.bucket,
    filePath: uploadedItem.name
  )

  #expect(item.bucket == uploadedItem.bucket)
  #expect(item.name == uploadedItem.name)
}

@Test
func contentUrl() async throws {
  let item = try await storage.upload(
    bucket: bucket,
    filePath: "memos/\(UUID())",
    data: Data("Hello".utf8),
    contentType: "text/plain"
  )
  
  _ = storage.contentUrl(item: item)
}

@Test
func updateItem() async throws {
  let value = "test2"
  let contentLanguage = ["en", "de"].randomElement()!
  let customMetadata = [
    "key1": "value1",
    "key2": "value2",
  ]
  
  let uploadedItem = try await storage.upload(
    bucket: bucket,
    filePath: "memos/\(UUID())",
    data: Data("Hello".utf8),
    contentType: "text/plain"
  )

  let item = try await storage.update(
    item: uploadedItem,
    cacheControl: value,
    contentDisposition: value,
    contentEncoding: value,
    contentLanguage: contentLanguage,
    contentType: value,
    customMetadata: customMetadata
  )
  
  #expect(item.cacheControl == value)
  #expect(item.contentDisposition == value)
  #expect(item.contentEncoding == value)
  #expect(item.contentLanguage == contentLanguage)
  #expect(item.contentType == value)
  #expect(item.customMetadata == customMetadata)
}

@Test
func deleteItem() async throws {
  let item = try await storage.upload(
    bucket: bucket,
    filePath: "memos/\(UUID())",
    data: Data("Hello".utf8),
    contentType: "text/plain"
  )
  try await storage.delete(item: item)
}

@Test
func getList() async throws {
  let directoryPath = "images/"
  
  let listResponse1 = try await storage.list(
    bucket: bucket,
    directoryPath: directoryPath,
    maxResults: 2
  )
  
  for prefix in listResponse1.prefixes {
    _ = try await storage.list(
      bucket: bucket,
      directoryPath: prefix
    )
  }
  
  let nextPageToken = try #require(listResponse1.nextPageToken)
  
  _ = try await storage.list(
    bucket: bucket,
    directoryPath: directoryPath,
    maxResults: 2,
    pageToken: nextPageToken
  )
}
