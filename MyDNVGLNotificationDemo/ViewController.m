//
//  ViewController.m
//  MyDNVGLNotificationDemo
//
//  Created by Dnvgl on 27/05/2017.
//  Copyright © 2017 Dnvgl. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"
#import "Notifications.h"
@interface ViewController ()

@end


//static NSMutableArray* GArray = [NSMutableArray array];

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // This updates the UI on startup based on the status of previously saved categories.
    
    Notifications* notifications = [(AppDelegate*)[[UIApplication sharedApplication]delegate] notifications];
    
    NSSet* categories = [notifications retrieveCategories];
    
    
    
    self.GArray = [NSMutableArray array];

    if([categories count]>0){
        NSEnumerator *enu = [categories objectEnumerator];
        NSString *temp = @"";
        while(temp = [enu nextObject]){
            [self.GArray addObject:temp];
        }
    }
    
    
    //Create UISwitch
    UISwitch *WorldSwitch =[[UISwitch alloc] initWithFrame:CGRectMake(180,30,100,30)];
    WorldSwitch.tag = 1;
    [self.view addSubview:WorldSwitch];
    [WorldSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    
    
    UISwitch *PoliticsSwitch =[[UISwitch alloc] initWithFrame:CGRectMake(180,90,100,30)];
    PoliticsSwitch.tag = 2;
    [self.view addSubview:PoliticsSwitch];
    [PoliticsSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    
    UISwitch *SportsSwitch =[[UISwitch alloc] initWithFrame:CGRectMake(180,160,100,30)];
    SportsSwitch.tag = 3;
    [self.view addSubview:SportsSwitch];
    [SportsSwitch addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    
    
   
    
    if ([categories containsObject:@"2572ddea-551d-4361-a08b-739256809383"]){
        WorldSwitch.on = true;
    }
    if ([categories containsObject:@"fd3dedb8-0212-4222-8232-6b593af020db"]){
        PoliticsSwitch.on = true;
    }
    if ([categories containsObject:@"851d2ca8-6f2c-486a-be4e-6d0cee37ff7e"]){
        SportsSwitch.on = true;
    }
      
        
//    CGRect buttonFrame = CGRectMake(55,220,100,30);
//    UIButton *button = [[UIButton alloc] initWithFrame:buttonFrame];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(80,220,100,30)];
    [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:@"Subscribe" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor whiteColor]];
                                   [button setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
                                   [self.view addSubview:button];

    [button addTarget:self action:@selector(subscribe:) forControlEvents:UIControlEventTouchUpInside];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)switchChange:(id)sender{
    UISwitch *mySwitch = (UISwitch *)sender;
    
    
    if(mySwitch.tag == 1){
        if(mySwitch.isOn == true){
          [self.GArray addObject:@"2572ddea-551d-4361-a08b-739256809383"];
        }else{
            [self.GArray removeObject:@"2572ddea-551d-4361-a08b-739256809383"];
        }
    }else if(mySwitch.tag == 2){
        if(mySwitch.isOn == true){
            [self.GArray addObject:@"fd3dedb8-0212-4222-8232-6b593af020db"];
        }else{
            [self.GArray removeObject:@"fd3dedb8-0212-4222-8232-6b593af020db"];
        }
    }else if(mySwitch.tag == 3){
        if(mySwitch.isOn == true){
            [self.GArray addObject:@"851d2ca8-6f2c-486a-be4e-6d0cee37ff7e"];
        }else{
            [self.GArray removeObject:@"851d2ca8-6f2c-486a-be4e-6d0cee37ff7e"];
        }
    }
}


- (IBAction)subscribe:(id)sender{
    NSMutableArray* categories = [[NSMutableArray alloc] init];
    
    [categories addObjectsFromArray:self.GArray];
    
//    if (self.WorldSwitch.isOn) [categories addObject:@"World"];
//    if (self.PoliticsSwitch.isOn) [categories addObject:@"Politics"];
//    if (self.SportsSwitch.isOn) [categories addObject:@"Sports"];
    
    Notifications* notifications = [(AppDelegate*)[[UIApplication sharedApplication]delegate] notifications];
    
    [notifications storeCategoriesAndSubscribeWithCategories:categories completion: ^(NSError* error) {
        if (!error) {
//            [(AppDelegate*)[[UIApplication sharedApplication]delegate] MessageBox:@"Notification" message:@"Subscribed!"];
            
            [self MessageBox:@"Notification" message:@"Subscribed!"];
        } else {
            NSLog(@"Error subscribing: %@", error);
        }
    }];
}


//
//- (void)SendNotificationRESTAPI:(NSString*)categoryTag
//{
//    NSURLSession* session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration
//                                                                    defaultSessionConfiguration] delegate:nil delegateQueue:nil];
//    
//    NSString *json;
//    
//    
//    
//    // Construct the messages REST endpoint
//    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/messages/%@", HUBLISTENACCESS,
//                                       HUBNAME]];
//    
//    // Generated the token to be used in the authorization header.
//    NSString* authorizationToken = [self generateSasToken:[url absoluteString]];
//    
//    //Create the request to add the template notification message to the hub
//    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
//    [request setHTTPMethod:@"POST"];
//    
//    // Add the category as a tag
//    [request setValue:categoryTag forHTTPHeaderField:@"ServiceBusNotification-Tags"];
//    
//    // Template notification
//    json = [NSString stringWithFormat:@"{\"messageParam\":\"Breaking %@ News : %@\"}",
//            categoryTag, self.notificationMessage.text];
//    
//    // Signify template notification format
//    [request setValue:@"template" forHTTPHeaderField:@"ServiceBusNotification-Format"];
//    
//    // JSON Content-Type
//    [request setValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
//    
//    //Authenticate the notification message POST request with the SaS token
//    [request setValue:authorizationToken forHTTPHeaderField:@"Authorization"];
//    
//    //Add the notification message body
//    [request setHTTPBody:[json dataUsingEncoding:NSUTF8StringEncoding]];
//    
//    // Send the REST request
//    NSURLSessionDataTask* dataTask = [session dataTaskWithRequest:request
//                                                completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//                                      {
//                                          NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*) response;
//                                          if (error || httpResponse.statusCode != 200)
//                                          {
//                                              NSLog(@"\nError status: %d\nError: %@", httpResponse.statusCode, error);
//                                          }
//                                          if (data != NULL)
//                                          {
//                                              //xmlParser = [[NSXMLParser alloc] initWithData:data];
//                                              //[xmlParser setDelegate:self];
//                                              //[xmlParser parse];
//                                          }
//                                      }];
//    
//    [dataTask resume];
//}


-(void)MessageBox:(NSString *)title message:(NSString *)messageText
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:messageText delegate:self
                                          cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [alert show];
}



@end
