[![](https://www.banuba.com/hubfs/Banuba_November2018/Images/Banuba%20SDK.png)](https://www.banuba.com/video-editor-sdk)

# Banuba ARCloudSDK. API Reference.

`ARCloudSDK` allows you to store your mask effects at server side. Sample integration is [here](https://app.gitbook.com/o/aA7b4CF3LLQIe3mrRHNn/s/k2cNUcDkN2oIE0fKtWIu/platforms/ios/api-samples/banuba-arcloudsdk-api-sample)

## `BanubaARCloud` is the main entity of ARCloudSDK.

### Background handler

```swift
/// This method needs to be called in the UIApplicationDelegate func application(_ application:, handleEventsForBackgroundURLSession identifier:, completionHandler: @escaping () -> Void)
  @objc static public func application(
    _ application: UIApplication,
    handleEventsForBackgroundURLSession identifier: String,
    completionHandler: @escaping () -> Void
  )
```

### Initializer

```swift
  /// Initialize AR cloud client with UUID string.
  /// - Parameters:
  ///   - effectsUrl: the effectsUrl is used to provide effects.
  @objc public required init(arCloudUrl: String)
```

### Get AR effects list

```swift
  /// Retrieve ar effects from cloud.
  @objc public func getAREffects(completion: @escaping ([AREffect]?, NSError?) -> Void)
```

### Get AR effect preview

```swift
  /// Retrieve the ar effect preview image
  @objc public func getArEffectPreview(
    _ effect: AREffect,
    completion: @escaping (UIImage?, NSError?) -> Void
  ) 
```

### Download AR effect

``` swift
  /// Download the ar effect to local storage
  @discardableResult
  @objc public func downloadArEffect(
    _ effect: AREffect,
    downloadProgress: ((Double) -> Void)?,
    completion: @escaping (URL?, NSError?) -> Void
  ) -> DownloadEffectRequestId
```

### Cancel AR effect downloading

```swift
  /// Cancel downloading effect with specific request id
  @objc public func cancelDownloadingEffect(
    withRequestId requestId: DownloadEffectRequestId
  )
```

### Storing folder URL

```swift
  /// Storing path to the folder witch storing downloaded effects
  @objc public static var effectsFolderURL: URL
```
