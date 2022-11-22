// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from scene.djinni

#import <Foundation/Foundation.h>
@class BNBImage;


@interface BNBRenderTarget : NSObject

- (nonnull NSString *)getName;

- (void)setSamplesCount:(int32_t)samples;

- (int32_t)getSamplesCount;

- (void)setExtent:(int32_t)width
           height:(int32_t)height;

- (int32_t)getWidth;

- (int32_t)getHeight;

- (void)setScale:(float)width
          height:(float)height;

- (float)getWidthScale;

- (float)getHeightScale;

- (void)addAttachment:(nullable BNBImage *)attachment;

- (void)removeAttachment:(nullable BNBImage *)attachment;

- (nonnull NSArray<BNBImage *> *)getAttachments;

@end