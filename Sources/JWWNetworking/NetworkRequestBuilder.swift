import Foundation

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
    public func build(for client: HTTPClient) throws -> URLRequest {
        var components = URLComponents(url: client.configuration.baseURL, resolvingAgainstBaseURL: false)
        components?.pathValue = Path(template.path)
        if !template.queryItems.isEmpty {
            components?.queryItems = template.queryItems
        }

        guard let url = components?.url else {
            throw URLError(.badURL)
        }

        var request = URLRequest(url: url)
        request.httpMethod = String(describing: template.method)
        request.allHTTPHeaderFields = try buildRequestHeaders()
        request.httpBody = template.body

        return request
    }

    private func buildRequestHeaders() throws -> [String: String] {
        let requestHeaders: [String: String] = template.headers.reduce(into: [:]) { result, x in
            result[x.key.value] = x.value
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
