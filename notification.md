---
Title: Notification service
Author: "Tong, Xiao Gang Tony"
Contributors: ""
---
##Notification Service

###What is a notification?
A notification is a short message to a customer telling him that we have some new information that we think is relevant for him to know. The notification can have links to further information or an action we want the customer to do but it should not be a lengthy text.

Examples:

- A new DNV GL service specification (SE) Qualification of manufacturers of special materials(DNVGL-SE-0079) has been published.
- Item Your vessel survey is soon due, please book a survey here

A notification is not an action/task but some notifications could be notifying you that an action might be needed.

A notification should not be used as general information newsletters or for marketing purposes. Using our online marketing tool Eloqua is better suited for this purpose.

###How does it work? 

When our customers are using a specific digital service they can also subcribe to notifications related to this service, if the service is offering notifications.The customers can set their notification preferences, do they want to subscribe to notifications from a service or not? How do they want the notification delivered?

We are offering delivery of notifications on different user interfaces/devices:

- Receive notification through web (Visible in MyDNVGL gateway and in the web pages of the digital service)
- Receive notification through email, currently with the frequency options immediately, daily or weekly
- Receive push notification to a native mobile app that is related to a My DNV GL service (will be available in June 2017)
- Receive notification as SMS (will be available later)

The digital services can then use this notification channel to reach either all customers who subscribe to the channel or specific customers who subscribe to the channel.

Based on the customers preferences on how they want the notification delivered My DNV GL wil deliver the notification.

If a digital service are offering different kind of notifications these can be set up as separate notification channels so that the customer can subscribe to them independently.

###How to send notification through Notification Service

Service API has provided the API methods to use the notification service, you can find the details there.

###How to develop mobile apps to use push notification

Notification Service can support to send push notification to native mobile apps in all kinds of different devices like Android, iOS, Windows phone etc. To be able to use the push notification from Veracity, you need to do below two things:

-  In your native app, register notification template in MyDNVGL notification hub when the app starts and implement the display of notification if the notification is received while the app is active.
- In your back-end application which is supposed to send notification, it needs to call MyDNVGL Notification API to send broadcast notification to all users of the app or notification to specified users

#### How to connect your app to MyDNVGL notification hub

- iOS development

1. If you don't have any idea on Notification Hub and iOS development, please read through this  [**guide**](https://docs.microsoft.com/en-us/azure/notification-hubs/notification-hubs-ios-apple-push-notification-apns-get-started) on how to develop an mobile app on iOS to register notification template and receive notification.
2. When register your app for push notifications:
  - If you are using explicit app id, then it means you need a separated notification hub for your app to send push notification. please generate a certification for your app id through Apple Developer Center. After you get the certification, please send it to Veracity team. Someone in Veracity team will create a notification hub for your app and config the apple notification service to use the certificate to send push notification. He can also send you the notification hub name and connection string that you will use them in your native app.
  - If you are using wildcard app id, please check with Veracity team whether this app id has already been registered in  Notification Service. If it is already registered, you can ask for the notification hub name and connection string for this wildcard app id. if it hasn't been registered yet, please generate a certification for your app id through Apple Developer Center. Then you can ask Veracity team to create notification hub and send you back the hub name and connection string.
  -  Now we have provided below notification hubs (it will be updated when we created more):


3. MyDNVGL Notification Service uses templates to send platform-agnostic notifications targeting all devices across platforms, see more info here. So you need to define your notification template that you would like to use for your app users, here is the example:
``` Object C: 
NSString* templateBodyAPNS = @"{\"aps\":{\"alert\":\"$(Message)\", \"action\":\"$(action)\", \"type\":\"$(type)\"}}";
```
when you send notification through MyDNVGL Notification API, you can provide the value for those template parameters. 
4. For broadcast notification, you need to get the Channel Id which you need to ask from your service admin. Then you need to use the Channel Id ("channel:<GUID>") as tags when register template in notification hub. Here is an example:
``` Object C:
NSMutableArray* catArray = [[NSMutableArray alloc] init];
for(NSString *category in categories.allObjects)
{
  NSMutableString *final = [[NSMutableString alloc] initWithString:@"channel:"];
  [final appendString:category];
  [catArray addObject: final];
}
NSSet *tags = [NSSet setWithArray:catArray];
result = [hub registerTemplateWithDeviceToken:self.deviceToken name:@"simpleAPNSTemplate" jsonBodyTemplate:templateBodyAPNS expiryTemplate:@"0" tags:tags error:&error];
```
5. For sending notification to specified users, you need to register the user id after the user log into your app. Then you can register the user id ("user:<GUID>") as additional tag on Channel Id.
6. How to show the notification when it's received while the app is active, you need to implement the method didReceiveRemoteNotification on AppDelegate.m as the demo application.

- Android development

1. If you don't have any idea on Notification Hub and Android development, please read through this guide on how to develop an mobile app on Android to register notification template and receive notification.
2. When register your app for push notifications:
Please check with MYDNVGL team and ask for th notification hub name,sender id and connection string.
Now we have provided below notification hubs (it will be updated when we create more).
3. MyDNVGL Notification Service uses templates to send platform-agnostic notifications targeting all devices across platforms and we can push notifications by using tags, see more info here. And on android side you should define template to accept the message:
```
 String templateBodyGCM = "{\"data\":{\"message\":\"$(message)\",\"open_type\":\"$(open_type)\"}}";  
 ```
 when you send notification through MyDNVGL Notification API, you can provide the value for those template parameters. 
 
 4.  For broadcast notification, you need to get the Channel Id which you need to ask from your service admin. We can register this channel id ("channel:<GUID>") as a basic tag for receiving broadcast notifications
 
 5.  For sending notification to specified users, you need to register the user id after the user log into your app. Then you can register the user id ("user:<GUID>") as additional tag on Channel Id.  
 
 ``` 
public void subscribeToCategories(final Set<String> categories) {
  new AsyncTask<Object, Object, Object>() {
  @Override
  protected Object doInBackground(Object... params) {
  try {
  if(!categories.contains(NotificationSettings.BasicChannelID)){
  categories.add(NotificationSettings.BasicChannelID);
  }
  String regid = gcm.register(senderId);
  String templateBodyGCM = "{\"data\":{\"message\":\"$(message)\",\"open_type\":\"$(open_type)\"}}";
  hub.registerTemplate(regid,"simpleGCMTemplate", templateBodyGCM,
  categories.toArray(new String[categories.size()]));
  } catch (Exception e) {
  Log.e("MainActivity", "Failed to register - " + e.getMessage());
  return e;
  }
  return null;
  }
  protected void onPostExecute(Object result) {
  String message = "Subscribed for categories: "+ categories.toString();
  Toast.makeText(context, message,
  Toast.LENGTH_LONG).show();
  cts = categories;
  }
  }.execute(null, null, null);
}
```                       
6. How to show the notification when it's received while the app is active, you need to implement the method onReceive on MyHandler.java as the demo application.

####How to send notification through your back-end application
It needs to call Send Message API to send notification, please refer Service API for Notification. 
