//
//  AppDelegate.m
//  JoeyPod
//
//  Created by Sujan on 2/18/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "Flurry.h"

#import "AppDelegate.h"
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocompleteQuery.h>
@import GoogleMaps;
#import "TutorialSlideViewController.h"

@interface AppDelegate ()


@end

@implementation AppDelegate

//static NSString *const kHNKDemoGooglePlacesAutocompleteApiKey = @"AIzaSyDftr5YlgLFLs1cGlD-E6mYjC_-gzhU8Ks";

static NSString *const kHNKDemoGooglePlacesAutocompleteApiKey = @"AIzaSyAqSWzZW_UDMwexQWhCPBjIpnPuzT7EjM0";

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
      [Flurry startSession:@"M65JV6JKWK87VJ755VVW"];
    
    [NSThread sleepForTimeInterval:2];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor blackColor];
    [self.window.rootViewController.view addSubview:view];
    
    
    //for drawer
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selectedIndex"];
    
    
    //for tutorial //not going to show after 2 times
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"GuideLine"] isEqualToString:@"2"]) {
//        NSLog(@"in 3");
//        UIStoryboard *iPhoneV6Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        UIViewController *initialViewController = [iPhoneV6Storyboard instantiateViewControllerWithIdentifier:@"SignInViewController"];
//        
//        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
//        self.window.rootViewController  = initialViewController;
//        [self.window makeKeyAndVisible];
        
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"GuideLine"] isEqualToString:@"1"])
        {
            NSLog(@"in 1");
            [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"GuideLine"];
            UIStoryboard *iPhoneV6Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *initialViewController = [iPhoneV6Storyboard instantiateViewControllerWithIdentifier:@"TutorialSlideViewController"];
            
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController  = initialViewController;
            [self.window makeKeyAndVisible];
            
        }
        else
        {
            NSLog(@"in 0");
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"GuideLine"];
            
            UIStoryboard *iPhoneV6Storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            UIViewController *initialViewController = [iPhoneV6Storyboard instantiateViewControllerWithIdentifier:@"TutorialSlideViewController"];
            
            self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
            self.window.rootViewController  = initialViewController;
            [self.window makeKeyAndVisible];
        }
        
    }
    
   // [GMSServices provideAPIKey:@"AIzaSyDhGQAONfM9Q8E5AEhZkium3TAL4IppWdU"];ios key:
    
    [GMSServices provideAPIKey:@"AIzaSyCyCgodBoiADfK0aSvFz8kMCzo3uW9f6YA"];
    
    [HNKGooglePlacesAutocompleteQuery setupSharedQueryWithAPIKey: kHNKDemoGooglePlacesAutocompleteApiKey];
    
    [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"addFeedingRoomMessage"];
    [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"InfoAddButton"];
    [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"contactUs"];
    
    
     //for google
    NSError* configureError;
    [[GGLContext sharedInstance] configureWithError: &configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    [GIDSignIn sharedInstance].delegate = self;
    
    
    //for facebook
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    



    
    return YES;
}

//- (BOOL)application:(UIApplication *)app
//            openURL:(NSURL *)url
//            options:(NSDictionary *)options {
//    
//    return [[GIDSignIn sharedInstance] handleURL:url
//                               sourceApplication:options[UIApplicationOpenURLOptionsSourceApplicationKey]
//                                      annotation:options[UIApplicationOpenURLOptionsAnnotationKey]];
//}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    NSLog(@"URL Google%@",url);
    
    
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginType"] isEqualToString:@"fb"])
    {
        NSLog(@"URL facebook%@",url);
       
        return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                              openURL:url
                                                    sourceApplication:sourceApplication
                                                           annotation:annotation];
    }else
        
    
        return [[GIDSignIn sharedInstance] handleURL:url
                               sourceApplication:sourceApplication
                                      annotation:annotation];
    
 
    
}


- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    // Perform any operations on signed in user here.
    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *fullName = user.profile.name;
    NSString *givenName = user.profile.givenName;
    NSString *familyName = user.profile.familyName;
    NSString *email = user.profile.email;
    
    NSLog(@"user email from google %@",user.profile);
    // ...
    
    NSMutableDictionary* userInfo = [[NSMutableDictionary alloc]init];
    
    
    
    if(user.profile)
    {
        [userInfo setObject:email forKey:@"email"];
        [userInfo setObject:fullName forKey:@"fullName"];
        [userInfo setObject:givenName forKey:@"givenName"];
        
        if([[[NSUserDefaults standardUserDefaults] objectForKey:@"viewController"] isEqualToString:@"signup"])
        {
             NSLog(@"signup with google fron signupViewcontroller");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"googleSignUp" object:self userInfo:userInfo];
            
            
        }else{
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"googleLogin" object:self userInfo:userInfo];
            
            
        }
        
        [[NSUserDefaults standardUserDefaults ] removeObjectForKey:@"viewController"];

    }
    
    
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user
     withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
    NSLog(@"disconnecting");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    
     NSLog(@"selec   %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
    [self performSelector:@selector(delayTime) withObject:nil afterDelay:1.5];
    
    
    
    
}

-(void)delayTime{

    
    NSLog(@"ncfbhnfghndfg");
    NSLog(@"selected index %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] integerValue] == 0 ) {
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMapWhenActive" object:self];
        
         NSLog(@"???????????");
        
    }else if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]integerValue]== 2) {
        
         [[NSNotificationCenter defaultCenter]postNotificationName:@"reloadMapWhenActive" object:self];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"addRoom" object:self];
        
         NSLog(@"..................");
        
    }
}

//|| ![[NSUserDefaults standardUserDefaults] objectForKey:@"viewController"]

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
