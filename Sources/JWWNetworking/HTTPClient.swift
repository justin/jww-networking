import Foundation
import HTTPTypes

/// Primary client for accessing an HTTP API.
public actor HTTPClient {
    /// The network configuration to use for composing and sending requests.
    public let configuration: Configuration

    /// The `URLSession` instance for making requests.
    public let session: URLSession

    /// Object that contains configuration information for setting up the HTTP client.
    public struct Configuration: Sendable {
        /// The base URL to use for requests sent through the client.
        public let baseURL: URL

        /// The default decoder for parsing payloads.
        public let decoder: JSONDecoder

        /// The default encoder for converting JSON payloads.
        public let encoder: JSONEncoder

        /// Create and return a new HTTPClient configuration instance.
        ///
        /// - Parameters:
        ///   - baseURL: The base URL to use for requests sent through the client.
        ///   - decoder: The default decoder for parsing payloads.
        ///   - encoder: The default encoder for converting JSON payloads.
        public init(baseURL: URL, decoder: JSONDecoder = JSONDecoder(), encoder: JSONEncoder = JSONEncoder()) {
            self.baseURL = baseURL
            self.decoder = decoder
            self.encoder = encoder
        }
    }

    // MARK: Initialization
    // ====================================
    // Initialization
    // ====================================

    /// Create and return a new HTTPClient object.
    ///
    /// - Parameters:
    ///   - configuration: The network configuration to use for composing and sending requests.
    ///   - session: The `URLSession` instance for making requests.
    public init(configuration: Configuration, session: URLSession = .shared) {
        self.session = session
        self.configuration = configuration
    }

    // MARK: Public Methods
    // ====================================
    // Public Methods
    // ====================================

    /// Convert a request template into a network request and attempt to return the expected values.
    @discardableResult
    public func send<T: NetworkRequest>(template: T) async throws(JWWNetworkError) -> T.Output {
        let builder = NetworkRequestBuilder(template: template)
        let generatedRequest = try builder.build(for: self)

        do {
            let (data, response) = try await session.data(for: generatedRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw JWWNetworkError.invalidResponse(response)
            }

            let statusCode = httpResponse.statusCode
            if statusCode == 401 {
                let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                throw JWWNetworkError.requestFailed(code: statusCode, message: message)
            }

            guard HTTPURLResponse.successStatusCodes.contains(statusCode) else {
                let message = HTTPURLResponse.localizedString(forStatusCode: statusCode)
                throw JWWNetworkError.requestFailed(code: statusCode, message: message)
            }

            let decoder = configuration.decoder
            do {
                let (object, _) = try type(of: template).decode(response: data, with: decoder)
                return object
            } catch {
                throw JWWNetworkError.decodingError(type(of: template).Output.self, data, error)
            }
        } catch let error as JWWNetworkError {
            throw error
        } catch let error {
            throw JWWNetworkError.untypedError(error: error)
        }
    }
}
