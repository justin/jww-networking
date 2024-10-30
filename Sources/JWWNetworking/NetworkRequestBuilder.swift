import Foundation
import HTTPTypes

/// Type that converst a network request template into a valid `URLRequest` object.
public struct NetworkRequestBuilder {
    /// The request template to convert into a `URLRequest`.
    public let template: any NetworkRequest

    // MARK: Initialization
    // ====================================
    // Initialization
    // ====================================

    /// Create a new request builder.
    ///
    /// - Parameters:
    ///   - template: The request template to convert into a `URLRequest`.
    public init(template: any NetworkRequest) {
        self.template = template
    }

    // MARK: Action Methods
    // ====================================
    // Action Methods
    // ====================================

    /// Convert a request template into a valid `URLRequest`.
    ///
    /// - Returns: A valid `URLRequest` that can be passed into a `URLSession`.
    public func build(for client: HTTPClient) throws(JWWNetworkError) -> URLRequest {
        let url = template.url ?? client.configuration.baseURL

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
        request.allHTTPHeaderFields = buildRequestHeaders()
        request.httpBody = template.body

        return request
    }
    private func buildRequestHeaders() -> [String: String] {
        let requestHeaders: [String: String] = template.headers.reduce(into: [:]) { result, x in
            result[x.key.rawName] = x.value
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
