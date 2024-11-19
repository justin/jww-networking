import Foundation
import Testing
@testable import JWWNetworking

/// Tests to validate the `URL.Path` type.
struct URLPathGenerationTests {
    /// Validate we can create a new Path object.
    @Test
    func initialization() throws {
        let path = Path("v1/foo/1/bar")
        let expectedValue = "/v1/foo/1/bar"

        let result = path.pathValue

        #expect(result == expectedValue)
    }

    /// Validate we can get the `pathValue` for a given path object..
    @Test
    func gettingPathValue() throws {
        let path = Path(["v1", "foo", 1, "bar"])
        let expectedValue = "/v1/foo/1/bar"

        let result = path.pathValue

        #expect(result == expectedValue)
    }

    /// Validate we can get the `stringValue` for a given path object.
    @Test
    func gettingStringValue() throws {
        let path = Path(["v1", "foo", 1, "bar"])
        let expectedValue = "v1/foo/1/bar"

        let result = path.stringValue

        #expect(result == expectedValue)
    }

    /// Validate we don't add a second leading "/" if one was already defined
    /// during path init.
    @Test
    func omittingSeparatorIfItAlreadyExists() throws {
        let path = Path("/v1/foo/1/bar")
        let expectedValue = "/v1/foo/1/bar"

        let result = path.pathValue

        #expect(result == expectedValue)
    }

    /// Valudate we properly support an empty/nil path.
    @Test
    func emptyPathValue() throws {
        let path = Path("")
        let expectedValue = ""

        let result = path.pathValue

        #expect(result == expectedValue)
    }

    /// Validate we can append a path value with a new one.
    @Test
    func appendingNewPathComponent() throws {
        let path = Path("v1")
        let expectedValue = "/v1/foo"

        let result = path.appending(Path("foo"))

        #expect(result.pathValue == expectedValue)
    }

    /// Validate we can join two path objects together.
    @Test
    func additionOperator() throws {
        let path = Path("v1")
        let expectedValue = "/v1/foo"

        let result = path + Path("foo")

        #expect(result.pathValue == expectedValue)
    }

    /// Validate if each component of a path includes a "/" we don't duplicate it when
    /// generating the `pathValue`.
    @Test
    func pathWithASeparatorInEachComponent() throws {
        let path = Path("/v1", "/foo", "biz")
        let expectedValue = "/v1/foo/biz"

        let result = path.pathValue

        #expect(result == expectedValue)
    }
}
