// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from spal.djinni

#import "BNBSimpleFullImageData.h"
#import <Foundation/Foundation.h>
@class BNBSimpleFramesProvider;


@interface BNBSimpleFramesProvider : NSObject

+ (nullable BNBSimpleFramesProvider *)create:(nonnull NSString *)path;

/** @return `null` if there is no more frames. */
- (nullable BNBSimpleFullImageData *)nextImage;

- (double)getFov;

- (nonnull NSDictionary<NSString *, NSString *> *)getDeviceInfo;

@end