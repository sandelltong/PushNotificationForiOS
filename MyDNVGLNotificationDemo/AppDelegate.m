//
//  AppDelegate.m
//  MyDNVGLNotificationDemo
//
//  Created by Dnvgl on 27/05/2017.
//  Copyright © 2017 Dnvgl. All rights reserved.
//
#define SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#import "AppDelegate.h"
#import <UserNotifications/UserNotifications.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.notifications = [[Notifications alloc] initWithConnectionString:HUBLISTENACCESS HubName:HUBNAME];
    
    // Override point for customization after application launch.
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound |
                                            UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
    
    [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    //UILocalNotification *localNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey];
    
    return YES;
}

- (void)registerForRemoteNotifications {
    if(SYSTEM_VERSION_GRATERTHAN_OR_EQUALTO(@"10.0")){
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if(!error){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    else {
        // Code for old versions
        //UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeSound |
                                                //UIUserNotificationTypeAlert | UIUserNotificationTypeBadge categories:nil];
        
        //[[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        //[[UIApplication sharedApplication] registerForRemoteNotifications];
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *) deviceToken {
    
    SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:HUBLISTENACCESS
                                                             notificationHubPath:HUBNAME];

    self.notifications.deviceToken = deviceToken;
    
    // Retrieves the categories from local storage and requests a registration for these categories
    // each time the app starts and performs a registration.
    
    //NSSet* categories = [self.notifications retrieveCategories];
    //[self.notifications subscribeWithCategories:categories completion:^(NSError* error) {
    //    if (error != nil) {
    //        NSLog(@"Error registering for notifications: %@", error);
    //    }
    //    else {
    //        [self MessageBox:@"Registration Status" message:@"Registered"];
    //    }
    //}];
}


// Handle any failure to register
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:
(NSError *)error {
    NSLog(@"Failed to register for remote notifications: %@", error);
}



- (void)application:(UIApplication *)application didReceiveRemoteNotification: (NSDictionary *)userInfo {
    NSLog(@"%@", userInfo);
    NSString *alert=[[userInfo objectForKey:@"aps"] valueForKey:@"alert"];
    NSString *action=[[userInfo objectForKey:@"aps"] valueForKey:@"action"];
    NSString *type=[[userInfo objectForKey:@"aps"] valueForKey:@"type"];
    
    NSString *messageText = [alert stringByAppendingString:@"\n\naction:"];
    if (action != nil) {
        messageText = [messageText stringByAppendingString:action];
    }
    messageText = [messageText stringByAppendingString:@"\n\ntype:"];
    if (type != nil) {
        messageText = [messageText stringByAppendingString:type];
    }
    [self MessageBox:@"Notification" message: messageText];
}


-(void)MessageBox:(NSString *)title message:(NSString *)messageText
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:messageText delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
    //UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:messageText preferredStyle:UIAlertControllerStyleAlert];
    //UIAlertAction * okButton = [UIAlertAction actionWithTitle:@"OK" style: UIAlertActionStyleDefault handler:
    //                            ^(UIAlertAction * action) {}];
    //[alert addAction:okButton];
}

@end
