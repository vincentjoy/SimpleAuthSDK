//
//  SimpleAuthConfig.swift
//  SimpleAuthSDK
//
//  Created by Vincent Joy on 07/07/25.
//

import Foundation

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
    ///   - logger: Optional logger implementation
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

// MARK: - Logger Protocol

/// Protocol for implementing custom logging functionality
public protocol Logger {
    /// Logs a message with the specified level
    /// - Parameters:
    ///   - message: The message to log
    ///   - level: The log level
    func log(_ message: String, level: LogLevel)
}

/// Log levels for the Logger protocol
public enum LogLevel {
    case debug
    case info
    case warning
    case error
}

// MARK: - Default Logger Implementation

/// Default console logger implementation
public class ConsoleLogger: Logger {
    public init() {}
    
    public func log(_ message: String, level: LogLevel) {
        let timestamp = DateFormatter.localizedString(from: Date(), dateStyle: .none, timeStyle: .medium)
        print("[\(timestamp)] [SimpleAuth] [\(level)] \(message)")
    }
}
