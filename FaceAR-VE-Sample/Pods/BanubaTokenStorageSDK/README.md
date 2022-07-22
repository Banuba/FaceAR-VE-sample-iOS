[![](https://www.banuba.com/hubfs/Banuba_November2018/Images/Banuba%20SDK.png)](https://www.banuba.com/video-editor-sdk)

# Banuba TokenStorageSDK. API Reference.

`BanubaTokenStorageSDK` allows you to store your token at server side via module API. For example you could use interaction with [Firebase](https://app.gitbook.com/o/aA7b4CF3LLQIe3mrRHNn/s/k2cNUcDkN2oIE0fKtWIu/platforms/ios/api-samples/banuba-tokenstoragesdk-api-sample)

Following protocol requires creation of the instance inherited from it and then passed to `VideoEditorTokerProvider` init.

```swift
/// Alows you to create database manager with host application implementation.
public protocol TokenProvidable: AnyObject {
  /// Observes token from remote database with multiple events.
  /// - parameters:
  ///    - succesEvent: Succes completion with optional token recieving.
  ///    - errorEvent: Error completion whenever some issues occurs.
  func observeToken(
    succesEvent: @escaping (_ token: String?) -> Void,
    errorEvent:  @escaping (_ error: Error) -> Void
  )
}
```

## `VideoEditorTokenProvide` is the main API for token downloading usage.

### Initializer

```swift
  /// VideoEditorTokenProvider constructor
  /// - Parameters:
  ///   - tokenProvider: The instance of entity which extend by TokenProvidable interface.
  public init(
    tokenProvider: TokenProvidable?
  )
```

### Loading token

```swift
  /// Receiving token from local plist file or via remote database
  /// - Parameters:
  ///   - completion: The completion handler is called with optional token and some optional errors.
  ///   - error: Description of any error that might occur.
  ///   - token: Token used to initialize the BanubaVideoEditor.
  public func loadToken(
    completion: @escaping (_ error: TokenProviderErrorType?, _ token: String?) -> Void
  )
```


