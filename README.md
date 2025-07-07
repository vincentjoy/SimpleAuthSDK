# SimpleAuthSDK

A lightweight, thread-safe authentication SDK for iOS that provides secure user authentication with configurable options.

## Features

- 🔐 **Secure Authentication**: Username/password based authentication with simulated async operations
- 🧵 **Thread-Safe**: Built using Swift's `actor` model for safe concurrent access
- 🔄 **Token Management**: Automatic token lifecycle management with refresh capabilities
- 📝 **Comprehensive Logging**: Integrated with LoggerSDK for robust logging capabilities
- ⚡ **Configurable**: Flexible configuration options for network delays and token expiry
- 🧪 **Well-Tested**: Comprehensive unit test suite included

## Requirements

- iOS 13.0+
- Swift 5.5+
- Xcode 13.0+
- LoggerSDK 1.0.0+

## Installation

### Swift Package Manager

Add the following to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/vincentjoy/SimpleAuthSDK.git", from: "1.0.4")
]
```

## Usage

### Basic Authentication

```swift
import SimpleAuthSDK

// Configure the SDK
let config = SimpleAuthConfig(apiKey: "your-api-key")
let auth = SimpleAuth(config: config)

// Login
do {
    let token = try await auth.login(username: "vincent", password: "pass123")
    print("Logged in successfully!")
    print("Access token: \(token.accessToken)")
} catch {
    print("Login failed: \(error)")
}
```

### Advanced Configuration

```swift
import LoggerSDK

// Create a logger instance
let logger = Logger(minimumLevel: .info)

// Configure with custom options
let config = SimpleAuthConfig(
    apiKey: "your-api-key",
    simulatedNetworkDelay: 2.0,        // 2 second delay
    tokenExpirySeconds: 7200,           // 2 hour expiry
    logger: logger,                     // Logger instance from LoggerSDK
    disableRandomErrors: false          // Enable random errors for testing
)

// Access logs later
let recentLogs = logger.getRecentLogs()
let errorLogs = logger.getRecentLogs(level: .error)
```

### Token Management

```swift
// Check login status
if await auth.isLoggedIn() {
    print("User is logged in")
}

// Get current token
if let token = await auth.getCurrentToken() {
    print("Token expires in: \(token.timeUntilExpiry) seconds")
}

// Refresh token
do {
    let newToken = try await auth.refreshToken()
    print("Token refreshed successfully")
} catch {
    print("Token refresh failed: \(error)")
}

// Logout
await auth.logout()
```

## API Reference

### SimpleAuth

The main SDK class providing authentication functionality.

#### Methods

- `init(config: SimpleAuthConfig)` - Initialize the SDK with configuration
- `login(username: String, password: String) async throws -> AuthToken` - Authenticate user
- `logout()` - Clear authentication state
- `isLoggedIn() -> Bool` - Check if user is authenticated
- `getCurrentToken() -> AuthToken?` - Get current valid token
- `refreshToken() async throws -> AuthToken` - Refresh authentication token

### SimpleAuthConfig

Configuration object for the SDK.

#### Properties

- `apiKey: String` - API key for SDK initialization
- `simulatedNetworkDelay: TimeInterval` - Network simulation delay (default: 1.0)
- `tokenExpirySeconds: TimeInterval` - Token validity duration (default: 3600)
- `logger: Logger?` - Optional Logger instance from LoggerSDK
- `disableRandomErrors: Bool` - Disable random server errors (default: false)

### AuthToken

Authentication token model.

#### Properties

- `accessToken: String` - Access token for API requests
- `refreshToken: String` - Refresh token for renewing access
- `expiresIn: TimeInterval` - Token validity duration
- `tokenType: String` - Token type (e.g., "Bearer")
- `createdAt: Date` - Token creation timestamp
- `expiryDate: Date` - Calculated expiry date
- `isExpired: Bool` - Check if token is expired
- `timeUntilExpiry: TimeInterval` - Remaining validity time

### AuthError

Authentication error cases.

- `invalidCredentials` - Invalid username or password
- `serverError(String)` - Server-side error with message
- `networkError(String)` - Network connectivity error
- `tokenExpired` - Authentication token expired
- `noTokenAvailable` - No token exists for operation
- `invalidConfiguration(String)` - Invalid SDK configuration
- `unknown` - Unknown error occurred

## Testing

The SDK includes a comprehensive test suite. To run tests:

```bash
swift test
```

### Test Credentials

For testing purposes, the SDK accepts these mock credentials:
- Username: `vincent`, Password: `pass123`
- Username: `admin`, Password: `admin123`
- Username: `test`, Password: `test123`

## Dependencies

This SDK depends on:
- [LoggerSDK](https://github.com/yourusername/LoggerSDK.git) - For comprehensive logging functionality

## Best Practices

1. **Error Handling**: Always handle authentication errors appropriately
2. **Token Storage**: The SDK manages tokens in memory only. For persistence, implement your own secure storage
3. **Logging**: Use LoggerSDK's features for debugging in development, configure appropriate log levels for production
4. **Thread Safety**: The SDK is thread-safe, safe to call from any thread/queue

## License

This SDK is available under the MIT license. See the LICENSE file for more info.
