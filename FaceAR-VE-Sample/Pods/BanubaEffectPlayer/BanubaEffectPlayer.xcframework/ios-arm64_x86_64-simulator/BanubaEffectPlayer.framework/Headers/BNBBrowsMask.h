// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from types.djinni

#import "BNBTransformedMaskByte.h"
#import <Foundation/Foundation.h>

@interface BNBBrowsMask : NSObject
- (nonnull instancetype)initWithLeft:(nonnull BNBTransformedMaskByte *)left
                               right:(nonnull BNBTransformedMaskByte *)right;
+ (nonnull instancetype)browsMaskWithLeft:(nonnull BNBTransformedMaskByte *)left
                                    right:(nonnull BNBTransformedMaskByte *)right;

@property (nonatomic, readonly, nonnull) BNBTransformedMaskByte * left;

@property (nonatomic, readonly, nonnull) BNBTransformedMaskByte * right;

@end