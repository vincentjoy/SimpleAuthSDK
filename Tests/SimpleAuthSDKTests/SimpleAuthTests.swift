//
//  SimpleAuthTests.swift
//  SimpleAuthSDK
//
//  Created by Vincent Joy on 07/07/25.
//

import XCTest
import LoggerSDK
@testable import SimpleAuthSDK

@available(iOS 13.0, *)
final class SimpleAuthTests: XCTestCase {
    
    var auth: SimpleAuth!
    var config: SimpleAuthConfig!
    var logger: Logger!
    
    override func setUp() async throws {
        logger = Logger(minimumLevel: .info)
        config = SimpleAuthConfig(
            apiKey: "test-api-key",
            simulatedNetworkDelay: 0.1, // Fast for tests
            tokenExpirySeconds: 3600,
            logger: logger,
            disableRandomErrors: true // Disable random errors for predictable tests
        )
        auth = SimpleAuth(config: config)
    }
    
    override func tearDown() async throws {
        auth = nil
        config = nil
        logger = nil
    }
    
    // MARK: - Login Tests
    
    func testLoginSuccess() async throws {
        // Given
        let username = "vincent"
        let password = "pass123"
        
        // When
        let token = try await auth.login(username: username, password: password)
        
        // Then
        XCTAssertFalse(token.accessToken.isEmpty)
        XCTAssertFalse(token.refreshToken.isEmpty)
        XCTAssertEqual(token.tokenType, "Bearer")
        XCTAssertEqual(token.expiresIn, 3600)
        XCTAssertFalse(token.isExpired)
        
        // Verify logging
        let logs = logger.getRecentLogs()
        XCTAssertTrue(logs.contains { $0.message.contains("Login successful") })
    }
    
    func testLoginFailureInvalidCredentials() async throws {
        // Given
        let username = "invalid"
        let password = "wrong"
        
        // When/Then
        do {
            _ = try await auth.login(username: username, password: password)
            XCTFail("Expected login to fail")
        } catch {
            XCTAssertEqual(error as? AuthError, .invalidCredentials)
        }
        
        // Verify logging
        let logs = logger.getRecentLogs(level: .error)
        XCTAssertTrue(logs.contains { $0.message.contains("invalid credentials") })
    }
    
    func testLoginFailureEmptyCredentials() async throws {
        // Test empty username
        do {
            _ = try await auth.login(username: "", password: "password")
            XCTFail("Expected login to fail with empty username")
        } catch {
            XCTAssertEqual(error as? AuthError, .invalidCredentials)
        }
        
        // Test empty password
        do {
            _ = try await auth.login(username: "username", password: "")
            XCTFail("Expected login to fail with empty password")
        } catch {
            XCTAssertEqual(error as? AuthError, .invalidCredentials)
        }
    }
    
    // MARK: - Logout Tests
    
    func testLogout() async throws {
        // Given - logged in user
        _ = try await auth.login(username: "vincent", password: "pass123")
        XCTAssertTrue(await auth.isLoggedIn())
        
        // When
        await auth.logout()
        
        // Then
        XCTAssertFalse(await auth.isLoggedIn())
        XCTAssertNil(await auth.getCurrentToken())
        
        // Verify logging
        let logs = logger.getRecentLogs()
        XCTAssertTrue(logs.contains { $0.message.contains("User logged out") })
    }
    
    // MARK: - Token State Tests
    
    func testIsLoggedIn() async throws {
        // Initially not logged in
        XCTAssertFalse(await auth.isLoggedIn())
        
        // After login
        _ = try await auth.login(username: "vincent", password: "pass123")
        XCTAssertTrue(await auth.isLoggedIn())
        
        // After logout
        await auth.logout()
        XCTAssertFalse(await auth.isLoggedIn())
    }
    
    func testGetCurrentToken() async throws {
        // Initially nil
        XCTAssertNil(await auth.getCurrentToken())
        
        // After login
        let loginToken = try await auth.login(username: "vincent", password: "pass123")
        let currentToken = await auth.getCurrentToken()
        XCTAssertNotNil(currentToken)
        XCTAssertEqual(currentToken?.accessToken, loginToken.accessToken)
    }
    
    // MARK: - Token Refresh Tests
    
    func testRefreshTokenSuccess() async throws {
        // Given - logged in user
        let originalToken = try await auth.login(username: "vincent", password: "pass123")
        
        // When
        let newToken = try await auth.refreshToken()
        
        // Then
        XCTAssertNotEqual(newToken.accessToken, originalToken.accessToken)
        XCTAssertEqual(newToken.refreshToken, originalToken.refreshToken)
        XCTAssertTrue(await auth.isLoggedIn())
    }
    
    func testRefreshTokenFailureNoToken() async throws {
        // Given - not logged in
        
        // When/Then
        do {
            _ = try await auth.refreshToken()
            XCTFail("Expected refresh to fail")
        } catch {
            XCTAssertEqual(error as? AuthError, .noTokenAvailable)
        }
    }
    
    // MARK: - Thread Safety Tests
    
    func testConcurrentLoginAttempts() async throws {
        // Test multiple concurrent login attempts
        await withTaskGroup(of: Result<AuthToken, Error>.self) { group in
            for i in 0..<10 {
                group.addTask {
                    do {
                        let token = try await self.auth.login(
                            username: i % 2 == 0 ? "vincent" : "admin",
                            password: i % 2 == 0 ? "pass123" : "admin123"
                        )
                        return .success(token)
                    } catch {
                        return .failure(error)
                    }
                }
            }
            
            var successCount = 0
            for await result in group {
                if case .success = result {
                    successCount += 1
                }
            }
            
            XCTAssertEqual(successCount, 10)
        }
    }
    
    // MARK: - Edge Cases
    
    func testTokenExpiry() async throws {
        // Create auth with very short expiry
        let shortExpiryLogger = Logger(minimumLevel: .info)
        let shortExpiryConfig = SimpleAuthConfig(
            apiKey: "test",
            simulatedNetworkDelay: 0.1,
            tokenExpirySeconds: 0.5, // 0.5 seconds
            logger: shortExpiryLogger,
            disableRandomErrors: true
        )
        let shortExpiryAuth = SimpleAuth(config: shortExpiryConfig)
        
        // Login
        let token = try await shortExpiryAuth.login(username: "vincent", password: "pass123")
        XCTAssertFalse(token.isExpired)
        
        // Wait for expiry
        try await Task.sleep(nanoseconds: 600_000_000) // 0.6 seconds
        
        // Check expiry
        XCTAssertTrue(token.isExpired)
        XCTAssertFalse(await shortExpiryAuth.isLoggedIn())
        XCTAssertNil(await shortExpiryAuth.getCurrentToken())
    }
    
    func testMultipleUsersLogin() async throws {
        // Test different valid users
        let users = [
            ("vincent", "pass123"),
            ("admin", "admin123"),
            ("test", "test123")
        ]
        
        for (username, password) in users {
            let token = try await auth.login(username: username, password: password)
            XCTAssertFalse(token.accessToken.isEmpty)
            await auth.logout()
        }
    }
}
