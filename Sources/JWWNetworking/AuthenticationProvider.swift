import Foundation

/// A type that handles authentication challenges for an `HTTPClient`.
public protocol AuthenticationProvider: Actor {
    /// The access token to use for authentication.
    var accessToken: String { get async throws }

    /// Request a new access token using a refresh token.
    func refreshAccessToken(refreshToken: String) async throws -> String
}
