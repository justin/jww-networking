import Foundation
import HTTPTypes
import JWWCore

/// Protocol that defines the attributes and methods needed to generate a request JWWNetworking can understand.
public protocol NetworkRequest<Output, Failure>: Sendable {
    /// The type of response object that should be parsed.
    associatedtype Output: Decodable
    /// The type of error that will be returned upon failure.
    associatedtype Failure = Error

    var url: URL? { get }

    /// The HTTP method for the request.
    var method: HTTPRequest.Method { get }

    /// The path for the request.
    var path: String { get }

    /// Optional. Request body.
    var body: Data? { get }

    /// The query parameters to append to the request.
    var queryItems: [URLQueryItem] { get }

    /// The headers to attach to the request.
    var headers: [HTTPField.Name: String] { get }

    /// Decode the passed in Data and return a valid response object.
    /// - Parameter response: The `Data` object to decode.
    ///
    /// - Returns: A decoded object of type `ResponseObject`.
    static func decode(response: Data, with decoder: JSONDecoder) throws -> (Output, DecodingContext?)
}

// MARK: Default Implementations
// ====================================
// Default Implementations
// ====================================

public extension NetworkRequest {
    static func decode(response: Data, with decoder: JSONDecoder) throws -> (Output, DecodingContext?) {
        let result = try decoder.decode(Output.self, from: response)

        return (result, decoder.context)
    }
}

// MARK: Authenticated Requests
// ====================================
// Authenticated Requests
// ====================================

/// Protocol that defines the attributes and methods needed to generate an authenticated request
/// JWWNetworking can understand.
public protocol AuthenticatedRequest: NetworkRequest {
    /// The type of authentication to use for the request.
    var authenticationType: AuthenticationType { get }
}

/// Supported authentication types when making an `AuthenticatedRequest`
public enum AuthenticationType: Sendable, Equatable {
    /// Setting the Authorization field with a Bearer token.
    case bearer
}
