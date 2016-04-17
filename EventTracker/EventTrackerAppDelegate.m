//
//  EventTrackerAppDelegate.m
//  EventTracker
//
//  Created by Kevin McCafferty on 27/03/2013.
//  Copyright (c) 2013 Kevin McCafferty. All rights reserved.
//

#import "EventTrackerAppDelegate.h"
#import "Event.h"


@implementation EventTrackerAppDelegate


-(void)customiseAppearance
{
    
    //[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackTranslucent animated:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    
    //NSString* boldFontName = @"GillSans-Bold";
    NSString* boldFontName = @"Sansation_Regular";
    
    [self styleNavigationBarWithFontName:boldFontName];
    
        
    
    
    // Customize the title text for *all* UINavigationBars
    [[UINavigationBar appearance] setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:1.0],
      NSForegroundColorAttributeName,
      [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.8],
      [NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
      [UIFont fontWithName:@"Sansation_Regular" size:24.0],
       NSFontAttributeName,
        nil]];
    
}






-(void)styleNavigationBarWithFontName:(NSString*)navigationTitleFont{
    
    
    CGSize size = CGSizeMake(320, 10);
    
    UIColor *color = [UIColor whiteColor];
    
    UIGraphicsBeginImageContext(size);
    CGContextRef currentContext = UIGraphicsGetCurrentContext();
    CGRect fillRect = CGRectMake(0,0,size.width,size.height);
    CGContextSetFillColorWithColor(currentContext, color.CGColor);
    CGContextFillRect(currentContext, fillRect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    UINavigationBar* navAppearance = [UINavigationBar appearance];
    
    [navAppearance setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
    
    [navAppearance setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor redColor], NSForegroundColorAttributeName,
                                           [UIFont fontWithName:navigationTitleFont size:18.0f], NSFontAttributeName,
                                           nil]];
    
    
}







- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self seedItems];
    
    [self customiseAppearance];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor redColor]}];
    // kev [[UINavigationBar appearance] setTintColor:[UIColor redColor]];
    
    UINavigationBar *navBar = [UINavigationBar appearance];
    // This works in DP3
    navBar.barTintColor = [UIColor redColor];
    [[self window] setTintColor:[UIColor redColor]];
    [[UIBarButtonItem appearance] setTintColor:[UIColor redColor]];
    
    NSString* boldFontName = @"Sansation_Regular";
    
    [navBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIColor redColor], NSForegroundColorAttributeName,
                                           [UIFont fontWithName:boldFontName size:24.0f], NSFontAttributeName,
                                           nil]];
    
    return YES;
}



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)seedItems
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    if (![ud boolForKey:@"SLUserDefaultsSeedItems"]) {
        // Load Seed Items
        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"seed" ofType:@"plist"];
        NSArray *seedItems = [NSArray arrayWithContentsOfFile:filePath];
        // Items
        NSMutableArray *items = [NSMutableArray array];
        // Create list of items
        for (int i=0; i < [seedItems count]; i++) {
            NSDictionary *seedItem = [seedItems objectAtIndex:i];
            // Create Item
            Event *item = [Event createEventWithName:[seedItem objectForKey:@"name"]
                                detail:[seedItem objectForKey:@"detail"]
                                Date:[seedItem objectForKey:@"date"]
                                         andCalendar:[seedItem objectForKey:@"calendar"]];
            
            // Add item to items
            [items addObject:item];
        }
        // Items path
        NSString *itemsPath = [[self documentsDirectory] stringByAppendingPathComponent:@"events.plist"];
        // Write to file
        if ([NSKeyedArchiver archiveRootObject:items toFile:itemsPath])
        {
            [ud setBool:YES forKey:@"SLUserDefaultsSeedItems"];
        }
    }
}

-(NSString *)documentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}


@end
