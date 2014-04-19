#import "VENRemoteUserDefaultsManager.h"

SpecBegin(VENRemoteUserDefaultsManager)

__block VENRemoteUserDefaultsManager *defaultsManager;
__block NSURL *plistURL;

const NSInteger NumberOfKeysInNewUserDefaults = 121;

describe(@"updateRemoteDefaults", ^{
    it(@"should call updateRemoteDefaultsWithCompletionBlock:", ^{
        VENRemoteUserDefaultsManager *testManager = [[VENRemoteUserDefaultsManager alloc] init];
        id mock = [OCMockObject partialMockForObject:testManager];
        [[mock expect] updateRemoteDefaultsWithCompletionBlock:nil];
        [((VENRemoteUserDefaultsManager *)mock) updateRemoteDefaults];
        [mock verify];
    });
});


describe(@"updateRemoteDefaultsWithCompletionBlock:", ^{

    beforeEach(^{
        NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
        [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
        defaultsManager = [[VENRemoteUserDefaultsManager alloc] init];
    });

    afterEach(^{
        plistURL = nil;
        defaultsManager = nil;
    });

    it(@"should set user defaults from test1.plist", ^AsyncBlock{
        plistURL = [[NSBundle mainBundle]
                        URLForResource: @"test1" withExtension:@"plist"];
        [defaultsManager setPlistURL:plistURL];
        [defaultsManager updateRemoteDefaultsWithCompletionBlock:^{
            expect([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] count]).to.equal(NumberOfKeysInNewUserDefaults + 3);
            expect([[NSUserDefaults standardUserDefaults] stringForKey:@"NavigationBarColor"]).to.equal(@"green");
            expect([[NSUserDefaults standardUserDefaults] boolForKey:@"ForgotPasswordWebView"]).to.beTruthy();
            expect([[NSUserDefaults standardUserDefaults] integerForKey:@"MaxRecentFriends"]).to.equal(10);
            done();
        }];

    });

    it(@"should not set user defaults if plist file does not exist", ^AsyncBlock{
        plistURL = [[NSBundle mainBundle]
                    URLForResource: @"noTestHere" withExtension:@"plist"];
        [defaultsManager setPlistURL:plistURL];
        [defaultsManager updateRemoteDefaultsWithCompletionBlock:^{
            expect([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] count]).to.equal(NumberOfKeysInNewUserDefaults);
            expect([[NSUserDefaults standardUserDefaults] stringForKey:@"NavigationBarColor"]).to.beNil;
            expect([[NSUserDefaults standardUserDefaults] boolForKey:@"ForgotPasswordWebView"]).to.beFalsy();
            expect([[NSUserDefaults standardUserDefaults] integerForKey:@"MaxRecentFriends"]).to.equal(0);
            done();
        }];
    });

    it(@"should set user defaults from test2.plist", ^AsyncBlock{
        plistURL = [[NSBundle mainBundle]
                    URLForResource: @"test2" withExtension:@"plist"];
        [defaultsManager setPlistURL:plistURL];
        [defaultsManager updateRemoteDefaultsWithCompletionBlock:^{
            expect([[[NSUserDefaults standardUserDefaults] dictionaryRepresentation] count]).to.equal(NumberOfKeysInNewUserDefaults + 3);
            expect([[NSUserDefaults standardUserDefaults] stringForKey:@"NavigationBarColor"]).to.equal(@"blue");
            expect([[NSUserDefaults standardUserDefaults] boolForKey:@"ForgotPasswordWebView"]).to.beFalsy();
            expect([[NSUserDefaults standardUserDefaults] integerForKey:@"MaxRecentFriends"]).to.equal(5);
            done();
        }];
    });

});

SpecEnd