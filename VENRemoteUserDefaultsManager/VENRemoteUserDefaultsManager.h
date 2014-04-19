#import <Foundation/Foundation.h>

@interface VENRemoteUserDefaultsManager : NSObject

///The minimum number of seconds before requesting a location ping.
@property (nonatomic, assign) NSInteger minimumUpdateInterval;


/**
 * Returns the shared manager responsible for updating userDefaults from the specified URL
 * @return A VENRemoteUserDefaultsManager object.
 */
+ (instancetype)sharedManager;


/**
 * Sets the URL of the remote plist of user defaults
 */
- (void)setPlistURL:(NSURL *)plistURL;


/**
 * Updates the userDefaults in a background queue if the time since last update is greater than the minimumUpdateInterval.
 */
- (void)updateRemoteDefaults;

/**
 * Updates the userDefaults in a background queue. The completion block will always be called. SUCCESS is NO if the time since last update is greater than the minimumUpdateInterval, or if the plist file is not a valid NSDictionary, and YES otherwise.
 */
- (void)updateRemoteDefaultsWithCompletionBlock:(void(^)(BOOL success))completionBlock;

@end
