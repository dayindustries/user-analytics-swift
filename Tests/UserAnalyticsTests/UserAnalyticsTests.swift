import XCTest
@testable import UserAnalytics

class UserAnalyticsTests: XCTestCase {
    func testInitSetsTitle() {
      guard let token = ProcessInfo.processInfo.environment["USER_ANALYTICS_TOKEN"] else {
        XCTFail("USER_ANALYTICS_TOKEN must be provided")
        return
      }

      guard let endpoint = ProcessInfo.processInfo.environment["USER_ANALYTICS_ENDPOINT"] else {
        XCTFail("USER_ANALYTICS_ENDPOINT must be provided")
        return
      }

      let userAnalytics = UserAnalytics(token: token, endpoint: endpoint)
      let data: Dictionary<String, Any> = [
          "distinct_id": "1",
          "time": UserAnalytics.toAthenaTimestamp(Date()),
          "ip": "71.198.38.200",
          "env": "prod",
          "event": "Signed Up",
          "subcategory": "",
          "event_id": "",
          "source": "someservice",
          "client": "ios",
          "os_version": "",
          "app_version": ""
      ]

      let promise = expectation(description: "Simple Request")
      userAnalytics.post(streamName: "UserAnalytics", data: data) { data, error in
          if error != nil {
              XCTFail("The POST request failed with an error")
              return
          }

          if data == nil {
              XCTFail("The POST request failed with a nil body")
              return
          }

          let responseString = String(decoding: data!, as: UTF8.self)
          XCTAssertEqual(responseString.count > 0, true, "Response string should not be empty")
          promise.fulfill()
      }

      waitForExpectations(timeout: 5, handler: nil)
    }
}
