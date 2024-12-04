import XCTest
@testable import JWWNetworking

/// Tests to exercise our `HTTPRequestHeaderKey` type.
final class HTTPRequestHeaderKeyTests: XCTestCase {
    /// Validate we can initialize a new request key.
    func testInit() {
        let key = HTTPRequestHeaderKey("test-value")

        XCTAssertEqual(key.value, "test-value")
    }
}
