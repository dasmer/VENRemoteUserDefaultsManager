#import "VENRemoteUserDefaultsManager.h"

@interface VENRemoteUserDefaultsManager ()

@property (nonatomic, strong) NSURL *plistURL;
@property (nonatomic, strong) NSDate *lastUpdateDate;

@end

@implementation VENRemoteUserDefaultsManager

+ (instancetype)sharedManager {
    static VENRemoteUserDefaultsManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}


- (void)updateRemoteDefaults {
    [self updateRemoteDefaultsWithCompletionBlock:nil];
}


- (void)updateRemoteDefaultsWithCompletionBlock:(void (^)(BOOL success))completionBlock {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,
                                             (unsigned long)NULL), ^(void) {
        if (!self.lastUpdateDate ||
            [[NSDate date] timeIntervalSinceDate:self.lastUpdateDate] > self.minimumUpdateInterval) {

            NSDictionary *remoteDefaultsDictionary = [[NSDictionary alloc] initWithContentsOfURL:self.plistURL];
            if ([remoteDefaultsDictionary isKindOfClass:[NSDictionary class]]) {
                [self populateUserDefaultsWithDictionary:remoteDefaultsDictionary];
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionBlock) {
                        completionBlock(YES);
                    }
                });
            }
            else {
                //Response not an NSDictionary
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (completionBlock) {
                        completionBlock(NO);
                    }
                });
            }
            self.lastUpdateDate = [NSDate date];
        }
        else {
            //Time since last update < Minimum Update Interval
            dispatch_async(dispatch_get_main_queue(), ^{
                if (completionBlock) {
                    completionBlock(NO);
                }
            });
        }
    });
}

- (void)populateUserDefaultsWithDictionary:(NSDictionary *)dictionary {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];

    for (NSString *key in [dictionary allKeys]) {
        NSObject *object = dictionary[key];
        [userDefaults setObject:object forKey:key];
    }
    [userDefaults synchronize];
    
}

@end
