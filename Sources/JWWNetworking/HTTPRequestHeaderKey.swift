import Foundation

/// A type-safe value that can be used to represent an HTTP header name.
struct HTTPRequestHeaderKey: Hashable {
    /// The key name that is passed as part of the HTTP request.
    let value: String

    /// Create a HTTPRequestHeaderKey object
    ///
    /// - Parameter value: The key name that is passed as part of the HTTP request.
    init(_ value: String) {
        self.value = value
    }
}

extension HTTPRequestHeaderKey {
    /// Header key for setting the "User-Agent" on a request.
    static let userAgent = HTTPRequestHeaderKey("User-Agent")

    /// Header key for setting the "Content-Type" on a request.
    static let contentType = HTTPRequestHeaderKey("Content-Type")

    /// Header key for setting the "Referer" on a request.
    static let referer = HTTPRequestHeaderKey("Referer")

    /// Header key for setting the "Accept-Language" on a request.
    static let acceptLanguage = HTTPRequestHeaderKey("Accept-Language")

    /// Header key for setting the "Authorization" on a request.
    static let authorization = HTTPRequestHeaderKey("Authorization")
}
