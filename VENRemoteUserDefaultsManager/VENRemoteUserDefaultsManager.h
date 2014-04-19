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

- (void)updateRemoteDefaultsWithCompletionBlock:(void(^)(BOOL success))completionBlock;

@end
