import XCTest

#if !os(macOS)
import UserAnalyticsTests

public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(UserAnalyticsTests.allTests),
    ]
}
#endif
