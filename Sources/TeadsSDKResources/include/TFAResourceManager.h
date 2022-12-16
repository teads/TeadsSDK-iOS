//
//  TFAResourceManager.h
//  TeadsSDK
//
//  Created by Paul Nicolas on 15/12/2022.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface TFAResourceManager : NSObject

@property (class, nonatomic, strong, readonly) NSURL *resourceBundleURL;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END
