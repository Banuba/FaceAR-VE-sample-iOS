#import <Foundation/Foundation.h>
#import <CoreVideo/CoreVideo.h>

#if __has_include(<BNBSimpleCameraOrientation.h>)
#import <BNBSimpleCameraOrientation.h>
#else
#import "BNBSimpleCameraOrientation.h"
#endif

NS_ASSUME_NONNULL_BEGIN

@interface BNBSimpleFullImageData : NSObject

- (instancetype)init:(CVPixelBufferRef)buffer
    cameraOrientation:(BNBSimpleCameraOrientation)cameraOrientation
     requireMirroring:(BOOL)requireMirroring
      faceOrientation:(NSInteger)faceOrientation;

@property(nonatomic, readonly) uint32_t width;
@property(nonatomic, readonly) uint32_t height;
@property(nonatomic, readonly) BNBSimpleCameraOrientation cameraOrientation;
@property(nonatomic, readonly) BOOL requireMirroring;
@property(nonatomic, readonly) int faceOrientation;

@property(nonatomic, readonly) __nullable CVPixelBufferRef pixelBuffer;

@end

NS_ASSUME_NONNULL_END
