// https://firebaseremoteconfigrealtime.googleapis.com/v1/projects/211171649289/namespaces/firebase:streamFetchInvalidations?key=AIzaSyAqomU63-8m6_LE6KQkT56-mYuI_tyYfF4
import Foundation
import HTTPTypes
import HTTPTypesFoundation

extension RemoteConfig {
  public func realtimeRequest(
    lastKnownVersionNumber: Int? = nil
  ) -> (request: HTTPRequest, body: Data) {
    let path = "/projects/\(self.projectId)/namespaces/firebase:streamFetchInvalidations"
    let endpoint = realtimeBaseUrl
      .appending(path: path)
      .appending(queryItems: [.init(name: "key", value: self.apiKey)])

    let request = HTTPRequest(
      method: .post,
      url: endpoint,
      headerFields: [
        .contentType: "application/json",
        .acceptEncoding: "application/json",
      ]
    )

    let body = [
      "project": self.projectId,
      "namespace": "firebase",
      "lastKnownVersionNumber": lastKnownVersionNumber.map { String($0) },
      "appId": self.appId
    ].compactMapValues { $0 }
    
    let bodyData = try! JSONEncoder().encode(body)
    
    return (request, bodyData)
  }
  
  public func realtimeStream(
    lastKnownVersionNumber: Int? = nil
  ) ->  AsyncThrowingStream<Result<RealtimeRemoteConfigResponse, any Error>, any Error> {
    let (request, body) = self.realtimeRequest(
      lastKnownVersionNumber: lastKnownVersionNumber
    )
    
    return AsyncThrowingStream { continuation in
      let stream = StreamExecution(for: request, from: body) { data in
        do {
          var stringData = String(decoding: data, as: UTF8.self)
          stringData.removeFirst() // remove "[" as first
          let response = try self.decode(
            RealtimeRemoteConfigResponse.self,
            from: Data(stringData.utf8)
          )
          continuation.yield(.success(response))
        } catch {
          continuation.yield(.failure(error))
        }
      } errorHandler: { error in
        continuation.finish(throwing: error)
      }

      continuation.onTermination = { @Sendable _ in
        Task { await stream.task.cancel() }
      }

      Task { await stream.start() }
    }
  }
}

public struct RealtimeRemoteConfigResponse: Sendable, Hashable, Codable {
  public var latestTemplateVersionNumber: String
}
