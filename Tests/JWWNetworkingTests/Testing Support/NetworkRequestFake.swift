import Foundation
@testable import JWWNetworking
import HTTPTypes

/// Network request object that can have any of its values injected or adjusted.
struct NetworkRequestFake: NetworkRequest {
    typealias Output = NetworkResponseFake

    var url: URL?
    var path: String
    var method: HTTPRequest.Method
    var queryItems: [URLQueryItem]
    var headers: [HTTPField.Name: String]
    var body: Data?

    /// Create a new request template using the passed in components.
    init(baseURL: URL,
         path: String,
         queryItems: [URLQueryItem] = [],
         method: HTTPRequest.Method,
         headers: [HTTPField.Name: String] = [:],
         body: Data? = nil) {
        self.url = baseURL
        self.path = path
        self.method = method
        self.queryItems = queryItems
        self.headers = headers
        self.body = body
    }

    /// Create a new request template using the passed in `URL`.
    /// The URL will be broken into components to populate the appropriate values.
    init(url: URL, method: HTTPRequest.Method = .get, body: Data? = nil, headers: [HTTPField.Name: String] = [:]) {
        let urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)

        // Generate the base URL from the components in the passed in `url`.
        var baseURLComponents = URLComponents()
        baseURLComponents.scheme = urlComponents?.scheme
        baseURLComponents.host = urlComponents?.host
        baseURLComponents.port = urlComponents?.port
        self.url = baseURLComponents.url!

        let path = Path(urlComponents?.path ?? "")
        self.path = path.pathValue

        self.queryItems = urlComponents?.queryItems ?? []
        self.method = method
        self.body = body
        self.headers = headers
    }
}

/// Network response object we can use for basic tests.
struct NetworkResponseFake: Hashable, Sendable, Codable {
    /// The value to check against.
    let value: String
}
