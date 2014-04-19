VENRemoteUserDefaultsManager
============================

VENRemoteUserDefaultsManager enables remote creation and manipulation of NSUserDefaults:
- Enable and disable different routes in your app
- Rename UILabels, UIButtons, UIAlertview titles and messages to test user behavior without submitting a new app version
- User test new features in production and have the ability to remotely revert them in cases of unexpected consequences

### Usage
Create a .plist file with a root NSDictionary. Set the dictionary's keys and values. Save the .plist on a web server.

In your App Delegate's ```didFinishLaunchingWithOptions:``` delegate method, set the VENRemoteUserDefaultsManager's URL of the plist file. Also, set a minimum update time interval to avoid excess server requests. I.e: 

```objc
    NSURL *plistURL = [NSURL URLWithString:@"http://dasmersingh.com/VENRemoteUserDefaults/RemoteUserDefaults.plist"];
    [[VENRemoteUserDefaultsManager sharedManager] setPlistURL:plistURL];
    [[VENRemoteUserDefaultsManager sharedManager] setMinimumUpdateInterval:60*60*7]; // 7 Hours
 ```
To request a NSUserDefaults update from the network, call ```updateRemoteDefaults```. This will create a server request on a background thread if the time since last update is greater than the ```minimumUpdateInterval```. A good place to call this method may be in your App Delegate's ```didBecomeActive:``` delegate method. I.e:  
```objc
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[VENRemoteUserDefaultsManager sharedManager] updateRemoteDefaults];
}
 ```
On update, the key/value pairs from the remote plist will become key/value pairs in the ```[NSUserDefaults standardDefaults]```.


### Contributing

We'd love to see your ideas for improving VENRemoteUserDefaultsManager! The best way to contribute is by submitting a pull request. We'll do our best to respond to your patch as soon as possible. You can also submit a new Github issue if you find bugs or have questions. 

Please make sure to follow our general coding style and add test coverage for new features!

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request