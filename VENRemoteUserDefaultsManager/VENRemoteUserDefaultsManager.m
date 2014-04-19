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
    if (!self.lastUpdateDate ||
        [self.lastUpdateDate timeIntervalSinceNow] > self.minimumUpdateInterval) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND,
                                                 (unsigned long)NULL), ^(void) {
            NSDictionary *remoteDefaultsDictionary = [[NSDictionary alloc] initWithContentsOfURL:self.plistURL];
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            if ([remoteDefaultsDictionary respondsToSelector:@selector(objectForKeyedSubscript:)]) {
                for (NSString *key in [remoteDefaultsDictionary allKeys]) {
                    NSObject *object = remoteDefaultsDictionary[key];
                    [userDefaults setObject:object forKey:key];
                }
            }
            [userDefaults synchronize];
            self.lastUpdateDate = [NSDate date];
        });
    }
}

@end
