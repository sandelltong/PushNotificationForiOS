//
//  Notifications.m
//  MyDNVGLNotificationDemo
//
//  Created by Dnvgl on 01/06/2017.
//  Copyright © 2017 Dnvgl. All rights reserved.
//

#import "Notifications.h"
#import <WindowsAzureMessaging/WindowsAzureMessaging.h>

@implementation Notifications
SBNotificationHub* hub;

- (id)initWithConnectionString:(NSString*)listenConnectionString HubName:(NSString*)hubName{
    
    hub = [[SBNotificationHub alloc] initWithConnectionString:listenConnectionString
                                          notificationHubPath:hubName];
    
    return self;
}

- (void)storeCategoriesAndSubscribeWithCategories:(NSSet *)categories completion:(void (^)(NSError *))completion {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[categories allObjects] forKey:@"BreakingNewsCategories"];
    
    [self subscribeWithCategories:categories completion:completion];
}


- (void) storeCategoriesAndSubscribeWithLocale:(int) locale categories:(NSSet *)categories completion:(void (^)(NSError *))completion {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:[categories allObjects] forKey:@"BreakingNewsCategories"];
    [defaults setInteger:locale forKey:@"BreakingNewsLocale"];
    [defaults synchronize];
    
    [self subscribeWithLocale: locale categories:categories completion:completion];
}


- (NSSet*)retrieveCategories {
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray* categories = [defaults stringArrayForKey:@"BreakingNewsCategories"];
    
    if (!categories) return [[NSSet alloc] init];
    
    return [[NSSet alloc] initWithArray:categories];
}



- (void) subscribeWithLocale: (int) locale categories:(NSSet *)categories completion:(void (^)(NSError *))completion{
    SBNotificationHub* hub = [[SBNotificationHub alloc] initWithConnectionString:@"<connection string>" notificationHubPath:@"<hub name>"];
    
    NSString* localeString;
    switch (locale) {
        case 0:
            localeString = @"English";
            break;
        case 1:
            localeString = @"French";
            break;
        case 2:
            localeString = @"Mandarin";
            break;
    }
    
    NSString* template = [NSString stringWithFormat:@"{\"aps\":{\"alert\":\"$(News_%@)\"},\"inAppMessage\":\"$(News_%@)\"}", localeString, localeString];
    
    [hub registerTemplateWithDeviceToken:self.deviceToken name:@"localizednewsTemplate" jsonBodyTemplate:template expiryTemplate:@"0" tags:categories completion:completion];
}

//
//- (int) retrieveLocale {
//    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
//    
//    int locale = [defaults integerForKey:@"BreakingNewsLocale"];
//    
//    return locale < 0?0:locale;
//}

- (void)subscribeWithCategories:(NSSet *)categories completion:(void (^)(NSError *))completion
{
    //[hub registerNativeWithDeviceToken:self.deviceToken tags:categories completion: completion];
    
    NSString* templateBodyAPNS = @"{\"aps\":{\"alert\":\"$(Message)\"}}";
    
    NSMutableArray* catArray = [[NSMutableArray alloc] init];
    for(NSString *category in categories.allObjects)
    {
        NSMutableString *final = [[NSMutableString alloc] initWithString:@"channel:"];
        [final appendString:category];
        [catArray addObject: final];
    }
    [catArray addObject: @"user:8fe2b116-68fb-4629-8c31-2ccc9b063066"];
    NSSet *tags = [NSSet setWithArray:catArray];
    
    NSError *error=nil;
    bool result = [hub unregisterAllWithDeviceToken: self.deviceToken error: &error];
    if (!result) {
        NSLog(@"Error to unregistering for notifications: %@", error);
    }
    
    result = [hub registerTemplateWithDeviceToken:self.deviceToken name:@"simpleAPNSTemplate"
                                 jsonBodyTemplate:templateBodyAPNS expiryTemplate:@"0" tags:tags error:&error];
    if (!result) {
        NSLog(@"Error to unregistering for notifications: %@", error);
    }
    
    if (completion) completion(error);
    //[hub unregisterAllWithDeviceToken: self.deviceToken completion: ^(NSError* error)  {
    //    if (error != nil) {
    //        NSLog(@"Error to unregistering for notifications: %@", error);
    //    }
    //}];
    
    //[hub registerTemplateWithDeviceToken:self.deviceToken name:@"simpleAPNSTemplate"
    //                    jsonBodyTemplate:templateBodyAPNS expiryTemplate:@"0" tags:tags completion: ^(NSError* error)
    //{
    //    if (error != nil) {
    //        NSLog(@"Error registering tags for notifications: %@", error);
    //    }
    //}];

}



//This class uses local storage to store and retrieve the categories of news that this device will receive. Also, it contains a method to register for these categories using a [Template](notification-hubs-templates-cross-platform-push-messages.md) registration.
@end
