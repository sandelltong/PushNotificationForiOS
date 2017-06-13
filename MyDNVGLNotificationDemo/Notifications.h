//
//  Notifications.h
//  MyDNVGLNotificationDemo
//
//  Created by Dnvgl on 01/06/2017.
//  Copyright © 2017 Dnvgl. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notifications : NSObject
@property NSData* deviceToken;

- (id)initWithConnectionString:(NSString*)listenConnectionString HubName:(NSString*)hubName;

- (void)storeCategoriesAndSubscribeWithCategories:(NSArray*)categories
                                       completion:(void (^)(NSError* error))completion;

- (void)subscribeWithCategories:(NSSet*)categories completion:(void (^)(NSError *))completion;

- (void) storeCategoriesAndSubscribeWithLocale:(int) locale categories:(NSSet*) categories completion: (void (^)(NSError* error))completion;

- (void) subscribeWithLocale:(int) locale categories:(NSSet*) categories completion:(void (^)(NSError *))completion;

- (NSSet*) retrieveCategories;

- (int) retrieveLocale;
@end
