import Foundation
import HTTPTypes

/// Type that converst a network request template into a valid `URLRequest` object.
public struct NetworkRequestBuilder {
    /// The request template to convert into a `URLRequest`.
    public let template: any NetworkRequest

    /// The network configuration to use for composing and sending requests.
    public let configuration: HTTPClient.Configuration

    // MARK: Initialization
    // ====================================
    // Initialization
    // ====================================

    /// Create a new request builder.
    ///
    /// - Parameters:
    ///   - template: The request template to convert into a `URLRequest`.
    ///   - configuration: The network configuration to use for composing and sending requests.
    public init(template: any NetworkRequest, configuration: HTTPClient.Configuration) {
        self.template = template
        self.configuration = configuration
    }

    // MARK: Action Methods
    // ====================================
    // Action Methods
    // ====================================

    /// Convert a request template into a valid `URLRequest`.
    ///
    /// - Returns: A valid `URLRequest` that can be passed into a `URLSession`.
    public func build(for client: HTTPClient) async throws(JWWNetworkError) -> URLRequest {
        let url = template.url ?? client.configuration.baseURL

        guard let url else {
            throw JWWNetworkError.invalidRequest
        }

        var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        components?.pathValue = Path(template.path)
        if !template.queryItems.isEmpty {
            components?.queryItems = template.queryItems
        }

        guard let url = components?.url else {
            throw JWWNetworkError.invalidRequest
        }

        var request = URLRequest(url: url)
        request.httpMethod = String(describing: template.method)
        request.allHTTPHeaderFields = try await buildRequestHeaders()
        request.httpBody = template.body

        return request
    }
    private func buildRequestHeaders() async throws(JWWNetworkError) -> [String: String] {
        var serviceHeaders: [String: String] = [:]

        if let userAgent = configuration.userAgent {
            serviceHeaders[HTTPField.Name.userAgent.rawName] = userAgent
        }

        if let authenticationController = configuration.authentication, template is (any AuthenticatedRequest) {
            do {
                let token = try await authenticationController.accessToken
                serviceHeaders[HTTPField.Name.authorization.rawName] = "Bearer \(token)"
            } catch {
                throw JWWNetworkError.authenticationError(error)
            }
        }

        let requestHeaders: [String: String] = template.headers.reduce(into: [:]) { result, x in
            result[x.key.rawName] = x.value
        }.merging(serviceHeaders) { (requestHeader, _) -> String in
            // Prefer request-specific headers to service-wide headers.
            return requestHeader
        }

        return requestHeaders
    }
}

private extension URLComponents {
    /// Path support for `URLComponents`.
    var pathValue: Path {
        get {
            Path(path)
        }

        set {
            path = newValue.pathValue
        }
    }
}
