import XCTest
import HTTPTypes
@testable import JWWNetworking

/// Tests to exercise our `NetworkRequestBuilder` type.
final class NetworkRequestBuilderTests: NetworkTestCase {
    /// Validate we can properly convert a `NetworkRequest` template into a valid `URLRequest`.
    func testBuildingRequestFromTemplate() throws {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "key1", value: "value1"),
            URLQueryItem(name: "key2", value: "value2")
        ]
        let path = "/one/two/three"
        let expectedURL = URL(string: "https://localhost/one/two/three?key1=value1&key2=value2")
        let expectedMethod: HTTPRequest.Method = .get
        let template = NetworkRequestFake(baseURL: TestingConstants.baseURL,
                                          path: path,
                                          queryItems: queryItems,
                                          method: expectedMethod)

        let result = try NetworkRequestBuilder(template: template).build(for: client)

        XCTAssertNotNil(result.url)
        XCTAssertEqual(result.url, expectedURL)
        XCTAssertEqual(result.httpMethod, String(describing: expectedMethod))
    }

    /// Validate if we set a header value on our request type it is added to the request.
    func testSettingRequestHeaders() throws {
        let expectedHeaders: [String: String] = [
            "Foo": "Bar",
            "Fiz": "Buzz"
        ]

        let request = NetworkRequestFake(url: TestingConstants.baseURL, headers: [
            HTTPField.Name("Foo")!: "Bar",
            HTTPField.Name("Fiz")!: "Buzz"
        ])

        let result = try NetworkRequestBuilder(template: request).build(for: client)

        XCTAssertEqual(result.allHTTPHeaderFields, expectedHeaders)
    }

    /// Validate we don't include the question mark if the query parameters field is empty.
    func testNoQuestionMarkIfNoQueryParameters() throws {
        let template = NetworkRequestFake(baseURL: TestingConstants.baseURL, path: "/fake-url", method: .get)

        let result = try XCTUnwrap(NetworkRequestBuilder(template: template).build(for: client).url)

        XCTAssertFalse(result.absoluteString.hasSuffix("?"), "URL is \(result.absoluteURL)")
    }
}
