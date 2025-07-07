//
//  AuthToken.swift
//  SimpleAuthSDK
//
//  Created by Vincent Joy on 07/07/25.
//

import Foundation

/// Authentication token containing access credentials and metadata
public struct AuthToken: Equatable, Codable {
    // MARK: - Properties
    
    /// The access token string
    public let accessToken: String
    
    /// The refresh token string
    public let refreshToken: String
    
    /// Token expiry time in seconds from creation
    public let expiresIn: TimeInterval
    
    /// Token type (e.g., "Bearer")
    public let tokenType: String
    
    /// Timestamp when the token was created
    public let createdAt: Date
    
    // MARK: - Computed Properties
    
    /// The exact expiry date of the token
    public var expiryDate: Date {
        createdAt.addingTimeInterval(expiresIn)
    }
    
    /// Checks if the token has expired
    public var isExpired: Bool {
        Date() >= expiryDate
    }
    
    /// Time remaining until token expires (in seconds)
    public var timeUntilExpiry: TimeInterval {
        max(0, expiryDate.timeIntervalSinceNow)
    }
    
    // MARK: - Initialization
    
    /// Initializes an AuthToken
    /// - Parameters:
    ///   - accessToken: The access token string
    ///   - refreshToken: The refresh token string
    ///   - expiresIn: Token validity duration in seconds
    ///   - tokenType: Type of token (default: "Bearer")
    ///   - createdAt: Token creation timestamp (default: current time)
    public init(
        accessToken: String,
        refreshToken: String,
        expiresIn: TimeInterval,
        tokenType: String = "Bearer",
        createdAt: Date = Date()
    ) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.expiresIn = expiresIn
        self.tokenType = tokenType
        self.createdAt = createdAt
    }
}

// MARK: - Extensions

extension AuthToken: CustomStringConvertible {
    public var description: String {
        """
        AuthToken:
        - Access Token: \(String(accessToken.prefix(10)))...
        - Refresh Token: \(String(refreshToken.prefix(10)))...
        - Type: \(tokenType)
        - Created: \(createdAt)
        - Expires: \(expiryDate)
        - Is Expired: \(isExpired)
        """
    }
}
