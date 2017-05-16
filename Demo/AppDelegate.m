//
//  AppDelegate.m
//  Demo
//
//  Created by Aniket Jain on 16/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import "AppDelegate.h"
#import "DrawerViewController.h"
#import "MMDrawerController.h"
#import "MMDrawerVisualState.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    return YES;
}

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    [self setApplicationStartingViewController];
    
    return YES;
}

-(void)setApplicationStartingViewController{
    
    UIStoryboard *drawerStoryboard = [UIStoryboard storyboardWithName:@"Drawer" bundle: nil];
    
    UIViewController *centerController;
        
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    centerController = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier: @"HomeNC"];
    
    DrawerViewController *drawerViewController = (DrawerViewController *) [drawerStoryboard instantiateViewControllerWithIdentifier: @"DrawerVC"];
    
    MMDrawerController *mm_drawerController = [[MMDrawerController alloc]
                                               initWithCenterViewController:centerController
                                               leftDrawerViewController:drawerViewController
                                               rightDrawerViewController:nil];
    
    [mm_drawerController setMaximumLeftDrawerWidth:280.0];
    [mm_drawerController setOpenDrawerGestureModeMask:MMOpenDrawerGestureModeAll];
    [mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    [mm_drawerController setCenterHiddenInteractionMode:MMDrawerOpenCenterInteractionModeNone];
    [mm_drawerController setShowsShadow:YES];
    [mm_drawerController setShadowOffset:CGSizeMake(12, -3)];
    [mm_drawerController setShouldStretchDrawer:NO];
    
    // Set a parallax animation for opening drawer
    [mm_drawerController setDrawerVisualStateBlock:[MMDrawerVisualState slideVisualStateBlock]];
    
    [mm_drawerController setGestureCompletionBlock:^(MMDrawerController *drawerController, UIGestureRecognizer *gesture) {
        [drawerController.centerViewController.view endEditing:YES];
    }];
    
    
    //self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.window setRootViewController:mm_drawerController];
    
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


@end
