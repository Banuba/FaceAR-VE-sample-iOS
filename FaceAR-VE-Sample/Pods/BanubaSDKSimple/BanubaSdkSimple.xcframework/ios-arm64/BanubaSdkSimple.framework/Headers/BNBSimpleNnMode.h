// AUTOGENERATED FILE - DO NOT MODIFY!
// This file generated by Djinni from effect_player.djinni

#import <Foundation/Foundation.h>

/**
 * Describes strategies for features which depend on Neural Networks
 * automatically means automatically decision, based on device performance and compatibility of NN's player with current platform
 * enable means enable NN's when current platform compatible with NN's player
 * disable means disable in any case
 */
typedef NS_ENUM(NSInteger, BNBSimpleNnMode)
{
    BNBSimpleNnModeAutomatically,
    BNBSimpleNnModeEnable,
    BNBSimpleNnModeDisable,
};
