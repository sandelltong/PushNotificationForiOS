//
//  AppDelegate.h
//  MyDNVGLNotificationDemo
//
//  Created by Dnvgl on 27/05/2017.
//  Copyright © 2017 Dnvgl. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WindowsAzureMessaging/WindowsAzureMessaging.h>
#import "HubInfo.h"

#import "Notifications.h"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic) Notifications* notifications;

@end

