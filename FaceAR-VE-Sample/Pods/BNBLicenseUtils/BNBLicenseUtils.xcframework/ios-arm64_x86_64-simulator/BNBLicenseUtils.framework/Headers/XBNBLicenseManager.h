// AUTOGENERATED FILE - DO NOT MODIFY!
// This file was generated by Djinni from license_utils.djinni

#import <Foundation/Foundation.h>
@class XBNBLicenseManager;


/** This class incapsulates information about Client Token. */
__attribute__((__visibility__("default"))) @interface XBNBLicenseManager : NSObject

/** Creates *new* `LicenceManager`. This metod won't change Banuba SDK internal state. */
+ (nullable XBNBLicenseManager *)create:(nonnull NSString *)clientToken;

/**
 * Returns the instance used by Banuba SDK to check licence.
 * This istance was created by `UtilityManager.initialize`.
 */
+ (nullable XBNBLicenseManager *)instance;

/** Checks if Client Token is expired. */
- (BOOL)isExpired;

/** Returns decoded content of Client Token */
- (nonnull NSString *)getJson;

@end
