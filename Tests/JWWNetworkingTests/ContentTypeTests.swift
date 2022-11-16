import XCTest
@testable import JWWNetworking

/// Tests to exercise our `ContentType` type.
final class ContentTypeTests: XCTestCase {
    /// Validate we can initialize a new content type object.
    func testInit() {
        let key = ContentType("application/gzip")

        XCTAssertEqual(key.value, "application/gzip")
    }

    /// Validate we return the key value when describing a content type object.
    func testDescription() throws {
        let expectedValue = "application/json"

        let result = String(describing: ContentType.json)

        XCTAssertEqual(result, expectedValue)
    }
}
