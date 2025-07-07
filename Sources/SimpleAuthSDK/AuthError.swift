//
//  AuthError.swift
//  SimpleAuthSDK
//
//  Created by Vincent Joy on 07/07/25.
//

import Foundation

/// Authentication-related errors that can occur during SDK operations
public enum AuthError: LocalizedError, Equatable {
    /// Invalid username or password provided
    case invalidCredentials
    
    /// Server returned an error
    case serverError(String)
    
    /// Network request failed
    case networkError(String)
    
    /// Token has expired
    case tokenExpired
    
    /// No token available for the requested operation
    case noTokenAvailable
    
    /// Invalid configuration provided
    case invalidConfiguration(String)
    
    /// Unknown error occurred
    case unknown
    
    // MARK: - LocalizedError
    
    public var errorDescription: String? {
        switch self {
        case .invalidCredentials:
            return "Invalid username or password"
        case .serverError(let message):
            return "Server error: \(message)"
        case .networkError(let message):
            return "Network error: \(message)"
        case .tokenExpired:
            return "Authentication token has expired"
        case .noTokenAvailable:
            return "No authentication token available"
        case .invalidConfiguration(let message):
            return "Invalid configuration: \(message)"
        case .unknown:
            return "An unknown error occurred"
        }
    }
    
    public var failureReason: String? {
        switch self {
        case .invalidCredentials:
            return "The provided credentials do not match any user account"
        case .serverError:
            return "The authentication server encountered an error"
        case .networkError:
            return "Unable to connect to the authentication server"
        case .tokenExpired:
            return "The authentication session has expired"
        case .noTokenAvailable:
            return "User is not authenticated"
        case .invalidConfiguration:
            return "The SDK configuration is invalid"
        case .unknown:
            return "An unexpected error occurred"
        }
    }
    
    public var recoverySuggestion: String? {
        switch self {
        case .invalidCredentials:
            return "Please check your username and password and try again"
        case .serverError:
            return "Please try again later"
        case .networkError:
            return "Please check your internet connection and try again"
        case .tokenExpired:
            return "Please log in again to continue"
        case .noTokenAvailable:
            return "Please log in to continue"
        case .invalidConfiguration:
            return "Please check the SDK configuration"
        case .unknown:
            return "Please try again or contact support"
        }
    }
}
