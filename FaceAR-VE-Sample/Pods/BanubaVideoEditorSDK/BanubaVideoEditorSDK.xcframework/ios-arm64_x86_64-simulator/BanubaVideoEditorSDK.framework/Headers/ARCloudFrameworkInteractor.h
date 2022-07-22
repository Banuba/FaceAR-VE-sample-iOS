//
//  ARCloudFrameworkInteractor.h
//  BanubaVideoEditorSDK
//
//  Created by Andrei Sak on 6.01.21.
//  Copyright © 2021 Banuba. All rights reserved.
//

@import UIKit;

// MARK:- AREffectWrapper

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(AREffectWrapper)
__attribute__((weak_import)) @interface AREffectWrapper : NSObject

@property (readonly, copy) NSString *title;
@property (readonly, nullable, copy) NSString *type;
@property (readonly, copy) NSURL *previewImage;
@property (readonly, copy) NSURL *downloadLink;
@property (readonly) BOOL isDownloaded;
@property (readwrite, nullable, copy, nonatomic) NSURL *localURL;

- (instancetype)init: (NSString *) title
                type: (NSString * _Nullable) type
        previewImage: (NSURL *) previewImage
        downloadLink: (NSURL *) downloadLink
        isDownloaded: (BOOL) isDownloaded
            localURL: (NSURL * _Nullable) localURL;
@end

NS_ASSUME_NONNULL_END

// MARK:- ARCloudFrameworkInteractor
NS_ASSUME_NONNULL_BEGIN

typedef void (^getAREffectsCompletion)(NSArray<AREffectWrapper *> * _Nullable effects, NSError * _Nullable error);
typedef void (^getArEffectPreviewCompletion)(UIImage * _Nullable image, NSError * _Nullable error);
typedef void (^downloadProgress)(double downloadProgress);
typedef void (^downloadArEffectCompletion)(NSURL * _Nullable url, NSError * _Nullable error);

NS_SWIFT_NAME(ARCloudFrameworkInteractor)
__attribute__((weak_import)) @interface ARCloudFrameworkInteractor : NSObject

+ (BOOL)isFrameworkAvailable;

- (instancetype)init: (NSString *) arCloudUrl
   embeddedEffectURLs: (NSArray<NSURL *> * _Nullable) embeddedEffectsURLs;

- (void) getAREffects: (getAREffectsCompletion) completion;
- (void) cancelDownloadingEffect: (NSUInteger) requestId;

- (void) getArEffectPreview: (AREffectWrapper * _Nonnull) effect
                 completion: (getArEffectPreviewCompletion) completion;

- (NSUInteger) downloadArEffect: (AREffectWrapper * _Nonnull) effect
               downloadProgress: (downloadProgress) downloadProgress
                     completion: (downloadArEffectCompletion) completion;

+ (NSURL * _Nullable) getEffectFolderURL;
@end

NS_ASSUME_NONNULL_END
