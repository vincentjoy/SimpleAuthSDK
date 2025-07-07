//
//  SimpleAuthConfig.swift
//  SimpleAuthSDK
//
//  Created by Vincent Joy on 07/07/25.
//

import Foundation
import LoggerSDK

/// Configuration object for initializing the SimpleAuth SDK
public struct SimpleAuthConfig {
    // MARK: - Properties
    
    /// API key for SDK initialization
    public let apiKey: String
    
    /// Simulated network delay in seconds (default: 1.0)
    public let simulatedNetworkDelay: TimeInterval
    
    /// Token expiry time in seconds (default: 3600 = 1 hour)
    public let tokenExpirySeconds: TimeInterval
    
    /// Optional logger for debugging
    public let logger: Logger?
    
    /// Disable random server errors for testing (default: false)
    public let disableRandomErrors: Bool
    
    // MARK: - Initialization
    
    /// Initializes the SDK configuration
    /// - Parameters:
    ///   - apiKey: API key for authentication
    ///   - simulatedNetworkDelay: Network delay simulation in seconds (default: 1.0)
    ///   - tokenExpirySeconds: Token expiry time in seconds (default: 3600)
    ///   - logger: Optional logger instance from LoggerSDK
    ///   - disableRandomErrors: Disable random server errors (default: false)
    public init(
        apiKey: String,
        simulatedNetworkDelay: TimeInterval = 1.0,
        tokenExpirySeconds: TimeInterval = 3600,
        logger: Logger? = nil,
        disableRandomErrors: Bool = false
    ) {
        self.apiKey = apiKey
        self.simulatedNetworkDelay = simulatedNetworkDelay
        self.tokenExpirySeconds = tokenExpirySeconds
        self.logger = logger
        self.disableRandomErrors = disableRandomErrors
    }
}
