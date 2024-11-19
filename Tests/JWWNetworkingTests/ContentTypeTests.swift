import Foundation
import Testing
@testable import JWWNetworking

/// Tests to exercise our `ContentType` type.
struct ContentTypeTests {
    /// Validate we can initialize a new content type object.
    @Test
    func initialization() {
        let key = ContentType("application/gzip")

        #expect(key.value == "application/gzip")
    }

    /// Validate we return the key value when describing a content type object.
    @Test
    func customDescription() throws {
        let expectedValue = "application/json"

        let result = String(describing: ContentType.json)

        #expect(result == expectedValue)
    }
}
