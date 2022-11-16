import Foundation

/// Protocol that defines the attributes and methods needed to generate a request JWWNetworking can understand.
protocol NetworkRequest<Output, Failure>: Sendable {
    /// The type of response object that should be parsed.
    associatedtype Output: Decodable
    /// The type of error that will be returned upon failure.
    associatedtype Failure = Error

    /// The HTTP method for the request.
    var method: HTTPMethod { get }

    /// The path for the request.
    var path: String { get }

    /// The query parameters to append to the request.
    var queryItems: [URLQueryItem] { get }

    /// The headers to attach to the request.
    var headers: [HTTPRequestHeaderKey: String] { get }

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

extension NetworkRequest {
    static func decode(response: Data, with decoder: JSONDecoder) throws -> (Output, DecodingContext?) {
        let result = try decoder.decode(Output.self, from: response)

        return (result, decoder.context)
    }
}
