//
//  AudioBrowserInteractor.h
//  BanubaVideoEditorSDK
//
//  Created by Gleb Markin on 2/22/21.
//  Copyright © 2021 Banuba. All rights reserved.
//

@import UIKit;
@import Foundation;

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(AudioBrowserTrackWrapper)

//MARK: - AudioBrowserTrackAdapter
__attribute__((weak_import)) @interface AudioBrowserTrackWrapper : NSObject

@property (nonatomic) int32_t trackId;
@property (strong, nonatomic, nullable) NSString *name;
@property (strong, nonatomic) NSString *additionalName;
@property (strong, nonatomic) NSURL *url;

- (instancetype)init: (int32_t) trackId
                name: (NSString *) name
      additionalName: (NSString * _Nullable) additionalName
                 url: (NSURL * _Nullable) url;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
NS_SWIFT_NAME(AudioBrowserFrameworkInteractor)

// MARK: - Audio browser framework interactor
__attribute__((weak_import)) @interface AudioBrowserFrameworkInteractor : NSObject

+ (BOOL)isFrameworkAvailable;
+ (void)setMubertPat: (NSString *) pat;

- (instancetype)initWithTransitionDelegate: (id<UIViewControllerTransitioningDelegate>) transitionDelegate
                             selectedTrack: (AudioBrowserTrackWrapper * _Nullable) selectedTrack;

-(UIViewController * _Nullable) getAudioBrowserController;

@end
NS_ASSUME_NONNULL_END
