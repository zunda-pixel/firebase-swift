import Foundation
import HTTPTypes

struct RequestError: Error {
  var request: HTTPRequest
  var body: Data
  var response: (Data, HTTPResponse)
}
