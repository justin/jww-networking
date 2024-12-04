import XCTest
@testable import JWWNetworking

/// Tests to exercise our `NetworkRequestBuilder` type.
final class NetworkRequestBuilderTests: NetworkTestCase {
    /// Validate we can properly convert a `NetworkRequest` template into a valid `URLRequest`.
    func testBuildingRequestFromTemplate() async throws {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "key1", value: "value1"),
            URLQueryItem(name: "key2", value: "value2")
        ]
        let path = "/one/two/three"
        let expectedURL = URL(string: "https://localhost/one/two/three?key1=value1&key2=value2")
        let expectedMethod: HTTPMethod = .get
        let template = NetworkRequestFake(baseURL: TestingConstants.baseURL,
                                          path: path,
                                          queryItems: queryItems,
                                          method: expectedMethod)

        let result = try await NetworkRequestBuilder(template: template,
                                                     configuration: HTTPClient.Configuration(baseURL: TestingConstants.baseURL)).build(for: client)

        XCTAssertNotNil(result.url)
        XCTAssertEqual(result.url, expectedURL)
        XCTAssertEqual(result.httpMethod, String(describing: expectedMethod))
    }

    /// Validate if we set a header value on our request type it is added to the request.
    func testSettingRequestHeaders() async throws {
        let expectedHeaders: [String: String] = [
            "Foo": "Bar",
            "Fiz": "Buzz"
        ]

        let request = NetworkRequestFake(url: TestingConstants.baseURL, headers: [
            HTTPRequestHeaderKey("Foo"): "Bar",
            HTTPRequestHeaderKey("Fiz"): "Buzz"
        ])

        let result = try await NetworkRequestBuilder(template: request,
                                               configuration: HTTPClient.Configuration(baseURL: TestingConstants.baseURL)).build(for: client)

        XCTAssertEqual(result.allHTTPHeaderFields, expectedHeaders)
    }

    /// Validate we don't include the question mark if the query parameters field is empty.
    func testNoQuestionMarkIfNoQueryParameters() async throws {
        let template = NetworkRequestFake(baseURL: TestingConstants.baseURL, path: "/fake-url", method: .get)

        let request = try await NetworkRequestBuilder(template: template,
                                                         configuration: HTTPClient.Configuration(baseURL: TestingConstants.baseURL)).build(for: client)
        let result = try XCTUnwrap(request.url)

        XCTAssertFalse(result.absoluteString.hasSuffix("?"), "URL is \(result.absoluteURL)")
    }

    /// Validate we can set the user agent header on our request.
    func testSettingUserAgentHeader() async throws {
        let userAgent = "FakeUserAgent/1.0"
        let configuration = HTTPClient.Configuration(baseURL: TestingConstants.baseURL, userAgent: userAgent)

        let request = NetworkRequestFake(url: TestingConstants.baseURL)

        let result = try await NetworkRequestBuilder(template: request, configuration: configuration).build(for: client)

        XCTAssertEqual(result.allHTTPHeaderFields?["User-Agent"], userAgent)
    }

    /// Validate if we do not set the user agent header on our request it falls back to the default.
    func testFallingBackToDefaultUserAgent() async throws {
        let configuration = HTTPClient.Configuration(baseURL: TestingConstants.baseURL)

        let request = NetworkRequestFake(url: TestingConstants.baseURL)

        let result = try await NetworkRequestBuilder(template: request, configuration: configuration).build(for: client)

        XCTAssertNil(result.allHTTPHeaderFields?["User-Agent"])
    }
}
