import XCTest
@testable import JWWNetworking

/// Tests to validate the `URL.Path` type.
final class URLPathGenerationTests: XCTestCase {
    /// Validate we can create a new Path object.
    func testInit() throws {
        let path = Path("v1/foo/1/bar")
        let expectedValue = "/v1/foo/1/bar"

        let result = path.pathValue

        XCTAssertEqual(result, expectedValue)
    }

    /// Validate we can get the `pathValue` for a given path object..
    func testGettingPathValue() throws {
        let path = Path(["v1", "foo", 1, "bar"])
        let expectedValue = "/v1/foo/1/bar"

        let result = path.pathValue

        XCTAssertEqual(result, expectedValue)
    }

    /// Validate we can get the `stringValue` for a given path object..
    func testGettingStringValue() throws {
        let path = Path(["v1", "foo", 1, "bar"])
        let expectedValue = "v1/foo/1/bar"

        let result = path.stringValue

        XCTAssertEqual(result, expectedValue)
    }

    /// Validate we don't add a second leading "/" if one was already defined
    /// during path init.
    func testOmittingSeparatorIfItAlreadyExists() throws {
        let path = Path("/v1/foo/1/bar")
        let expectedValue = "/v1/foo/1/bar"

        let result = path.pathValue

        XCTAssertEqual(result, expectedValue)
    }

    /// Valudate we properly support an empty/nil path.
    func testEmptyPathValue() throws {
        let path = Path("")
        let expectedValue = ""

        let result = path.pathValue

        XCTAssertEqual(result, expectedValue)
    }

    /// Validate we can append a path value with a new one.
    func testAppendingNewPathComponent() throws {
        let path = Path("v1")
        let expectedValue = "/v1/foo"

        let result = path.appending(Path("foo"))

        XCTAssertEqual(result.pathValue, expectedValue)
    }

    /// Validate we can join two path objects together.
    func testAdditionOperator() throws {
        let path = Path("v1")
        let expectedValue = "/v1/foo"

        let result = path + Path("foo")

        XCTAssertEqual(result.pathValue, expectedValue)
    }

    /// Validate if each component of a path includes a "/" we don't duplicate it when
    /// generating the `pathValue`.
    func testPathWithASeparatorInEachComponent() throws {
        let path = Path("/v1", "/foo", "biz")
        let expectedValue = "/v1/foo/biz"

        let result = path.pathValue

        XCTAssertEqual(result, expectedValue)
    }
}
