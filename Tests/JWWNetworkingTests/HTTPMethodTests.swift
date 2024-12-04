import XCTest
@testable import JWWNetworking

/// Tests to exercise our `HTTPMethod` type.
final class HTTPMethodTests: XCTestCase {
    /// Validate if we attempt to generate a string from a method it returns the expected value in uppercase.
    func testStringValuesReturnUppercase() {
        let expectedValues = ["GET", "HEAD", "POST", "PUT", "DELETE", "CONNECT", "OPTIONS", "TRACE", "PATCH"]

        for method in HTTPMethod.allCases {
            let result = String(describing: method)
            XCTAssertTrue(expectedValues.contains(result))
        }
    }
}
