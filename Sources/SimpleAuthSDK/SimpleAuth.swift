//
//  SimpleAuth.swift
//  SimpleAuthSDK
//
//  Created by Vincent Joy on 07/07/25.
//

import Foundation

/// The main authentication SDK class that provides secure user authentication
/// with configurable options and thread-safe operations.
@available(iOS 13.0, *)
public actor SimpleAuth {
    // MARK: - Properties
    
    /// Configuration for the SDK
    private let config: SimpleAuthConfig
    
    /// Current authentication token
    private var currentToken: AuthToken?
    
    /// Logger instance for debugging
    private let logger: Logger?
    
    /// Mock credentials for simulation
    private let validCredentials = [
        "vincent": "pass123",
        "admin": "admin123",
        "test": "test123"
    ]
    
    // MARK: - Initialization
    
    /// Initializes the SimpleAuth SDK with the provided configuration
    /// - Parameter config: Configuration object containing SDK settings
    public init(config: SimpleAuthConfig) {
        self.config = config
        self.logger = config.logger
        logger?.log("SimpleAuth initialized with API key: \(config.apiKey)", level: .info)
    }
    
    // MARK: - Public Methods
    
    /// Authenticates a user with username and password
    /// - Parameters:
    ///   - username: The user's username
    ///   - password: The user's password
    /// - Returns: An AuthToken containing access token and expiry information
    /// - Throws: AuthError if authentication fails
    public func login(username: String, password: String) async throws -> AuthToken {
        logger?.log("Attempting login for user: \(username)", level: .info)
        
        // Validate input
        guard !username.isEmpty, !password.isEmpty else {
            logger?.log("Login failed: empty credentials", level: .error)
            throw AuthError.invalidCredentials
        }
        
        // Simulate network delay
        let delay = config.simulatedNetworkDelay
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        // Simulate random server errors (5% chance)
        if Double.random(in: 0...1) < 0.05 && !config.disableRandomErrors {
            logger?.log("Login failed: simulated server error", level: .error)
            throw AuthError.serverError("Simulated server error")
        }
        
        // Check credentials
        guard validCredentials[username] == password else {
            logger?.log("Login failed: invalid credentials for user: \(username)", level: .error)
            throw AuthError.invalidCredentials
        }
        
        // Generate token
        let token = AuthToken(
            accessToken: generateAccessToken(),
            refreshToken: generateRefreshToken(),
            expiresIn: config.tokenExpirySeconds,
            tokenType: "Bearer"
        )
        
        // Store token
        currentToken = token
        logger?.log("Login successful for user: \(username)", level: .info)
        
        return token
    }
    
    /// Logs out the current user by clearing the stored token
    public func logout() {
        logger?.log("User logged out", level: .info)
        currentToken = nil
    }
    
    /// Checks if a user is currently logged in
    /// - Returns: true if a valid token exists, false otherwise
    public func isLoggedIn() -> Bool {
        guard let token = currentToken else {
            return false
        }
        return !token.isExpired
    }
    
    /// Gets the current authentication token if available and valid
    /// - Returns: The current AuthToken or nil if not logged in or expired
    public func getCurrentToken() -> AuthToken? {
        guard let token = currentToken, !token.isExpired else {
            return nil
        }
        return token
    }
    
    /// Refreshes the current authentication token
    /// - Returns: A new AuthToken with updated expiry
    /// - Throws: AuthError if no valid token exists to refresh
    public func refreshToken() async throws -> AuthToken {
        guard let currentToken = currentToken else {
            throw AuthError.noTokenAvailable
        }
        
        guard !currentToken.isExpired else {
            throw AuthError.tokenExpired
        }
        
        logger?.log("Refreshing token", level: .info)
        
        // Simulate network delay
        let delay = config.simulatedNetworkDelay * 0.5 // Refresh is faster
        try await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
        
        // Generate new token
        let newToken = AuthToken(
            accessToken: generateAccessToken(),
            refreshToken: currentToken.refreshToken, // Keep same refresh token
            expiresIn: config.tokenExpirySeconds,
            tokenType: "Bearer"
        )
        
        self.currentToken = newToken
        logger?.log("Token refreshed successfully", level: .info)
        
        return newToken
    }
    
    // MARK: - Private Methods
    
    private func generateAccessToken() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let tokenLength = 32
        return String((0..<tokenLength).map { _ in characters.randomElement()! })
    }
    
    private func generateRefreshToken() -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let tokenLength = 64
        return String((0..<tokenLength).map { _ in characters.randomElement()! })
    }
}
