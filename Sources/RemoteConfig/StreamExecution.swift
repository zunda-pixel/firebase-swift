import Foundation
import HTTPTypes

#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

actor StreamExecution: NSObject, URLSessionDataDelegate {
  let handler: @Sendable (Data) -> Void
  let errorHandle: @Sendable (any Error) -> Void

  var task: URLSessionDataTask!

  init(
    for request: HTTPRequest,
    from body: Data? = nil,
    urlSessionConfiguration: URLSessionConfiguration = .default,
    handler: @escaping @Sendable (Data) -> Void,
    errorHandler: @escaping @Sendable (any Error) -> Void
  ) {
    self.handler = handler
    self.errorHandle = errorHandler

    super.init()

    let session = URLSession(
      configuration: urlSessionConfiguration,
      delegate: self,
      delegateQueue: nil
    )
    if let body {
      self.task = session.uploadTask(with: .init(httpRequest: request)!, from: body)
    } else {
      self.task = session.dataTask(with: .init(httpRequest: request)!)
    }
  }

  func start() {
    task.resume()
  }

  nonisolated func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
    handler(data)
  }

  nonisolated public func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: (any Error)?) {
    guard let error else { return }
    errorHandle(error)
  }
}
