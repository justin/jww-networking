import Foundation

/// A type-safe value that can be used to declare the MIME type
struct ContentType: Hashable, CustomStringConvertible {
    /// The content type name that is passed as the value in the HTTP header.
    let value: String

    /// Create a ContentType object
    ///
    /// - Parameter value: The content type name that is passed as the value in the HTTP header.
    init(_ value: String) {
        self.value = value
    }

    nonisolated var description: String {
        value
    }
}

extension ContentType {
    /// Content type for plain text.
    static let text = ContentType("text/plain")

    /// Content type for JSON.
    static let json = ContentType("application/json")
}
