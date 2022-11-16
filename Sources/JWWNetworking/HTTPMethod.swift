import Foundation

/// Constants for accessing the different HTTP request methods.
///
/// These method names map to the methods defined in [RFC9110](https://www.rfc-editor.org/rfc/rfc9110.html#name-methods).
enum HTTPMethod: String, CustomStringConvertible, CaseIterable, Codable {
    case get
    case head
    case post
    case put
    case delete
    case connect
    case options
    case trace
    case patch

    nonisolated var description: String {
        rawValue.uppercased()
    }
}
