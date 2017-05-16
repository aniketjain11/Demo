//
//  DemoBaseTableViewController.m
//  Demo
//
//  Created by Aniket Jain on 16/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import "DemoBaseTableViewController.h"
#import "UtilityClass.h"
#import "SSSnackbar.h"
#import "AFNetworkReachabilityManager.h"


#define NETWORK_ERROR_NOTIFICATION @"NetworkErrorNotification"
#define ADD_NETWORK_ERROR_OBSERVER [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetworkError:) name:NETWORK_ERROR_NOTIFICATION  object:nil];
#define REMOVE_NETWORK_ERROR_OBSERVER [[NSNotificationCenter defaultCenter] removeObserver:self name:NETWORK_ERROR_NOTIFICATION object:nil];

#define SERVER_ERROR_NOTIFICATION @"ServerErrorNotification"
#define ADD_SERVER_ERROR_OBSERVER [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showServerError:) name:SERVER_ERROR_NOTIFICATION  object:nil];
#define REMOVE_SERVER_ERROR_OBSERVER [[NSNotificationCenter defaultCenter] removeObserver:self name:SERVER_ERROR_NOTIFICATION object:nil];

//Font Types
#define TC_MONSTERRAT_REGULAR @"Montserrat-Regular"
#define TC_MONSTERRAT_LIGHT @"Montserrat-Light"
#define TC_MONSTERRAT_SEMIBOLD @"Montserrat-SemiBold"


#define TC_LOCAL(LOCAL_TEXT) NSLocalizedString(LOCAL_TEXT,nil)


#define SHOW_NETWORK_ERRROR \
if(self.navigationController){\
[UtilityClass removeActivityIndicatorFromView:self.navigationController.view];\
}\
[UtilityClass removeActivityIndicatorFromView:[UIApplication sharedApplication].keyWindow];\
[UtilityClass removeActivityIndicatorFromView:self.view];\
if (notification.object) { \
SSSnackbar *snackbar = [SSSnackbar snackbarWithMessage:notification.object actionText:TC_LOCAL(@"SNACKBAR_ACTION_RETRY") duration:3 actionBlock:^(SSSnackbar *sender) { \
[self refreshView]; \
} dismissalBlock:nil]; \
[snackbar show]; \
if ([self respondsToSelector:NSSelectorFromString(@"snackbar")]) { \
[self setValue:snackbar forKey:@"snackbar"]; \
} \
}

#define SHOW_SERVER_ERRROR \
if(self.navigationController){\
[UtilityClass removeActivityIndicatorFromView:self.navigationController.view];\
}\
[UtilityClass removeActivityIndicatorFromView:[UIApplication sharedApplication].keyWindow];\
[UtilityClass removeActivityIndicatorFromView:self.view];\
if (notification.object) { \
[[SSSnackbar snackbarWithMessage:notification.object actionText:nil duration:3 actionBlock:nil dismissalBlock:nil] show]; \
}

#define REFRESH_VIEW  if ([AFNetworkReachabilityManager sharedManager].isReachable) {[UtilityClass removeActivityIndicatorFromView:self.view];[UtilityClass setDefaultActivityIndicatorAtView:self.view showJokes:false];[self viewDidLoad];[self viewWillAppear:YES];}

@interface DemoBaseTableViewController ()

@end

@implementation DemoBaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (void)viewWillAppear:(BOOL)animated {
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    ADD_NETWORK_ERROR_OBSERVER
    ADD_SERVER_ERROR_OBSERVER
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           [UIColor whiteColor], NSForegroundColorAttributeName,
                           [UIFont fontWithName:TC_MONSTERRAT_REGULAR size:17.0], NSFontAttributeName, nil];
    
    self.navigationController.navigationBar.titleTextAttributes = attrs;
    self.navigationController.navigationBar.topItem.title = @"";

}

- (void)viewWillDisappear:(BOOL)animated {
    REMOVE_NETWORK_ERROR_OBSERVER
    REMOVE_SERVER_ERROR_OBSERVER
    
}


- (void) showNetworkError:(NSNotification*)notification {
    SHOW_NETWORK_ERRROR
}

- (void) showServerError :(NSNotification*)notification {
    SHOW_SERVER_ERRROR
}

- (void) refreshView {
    REFRESH_VIEW
}

//- (void)showSearch {
//    
//    NSArray *viewControllers = self.navigationController.viewControllers;
//    NSMutableArray *newViewControllers = [[NSMutableArray alloc] init];
//    
//    SearchViewController *searchViewController;
//    for (UIViewController *viewController in viewControllers) {
//        if ([viewController isKindOfClass:[SearchViewController class]]) {
//            searchViewController = (SearchViewController *)viewController;
//        }else{
//            [newViewControllers addObject:viewController];
//        }
//    }
//    
//    if (searchViewController) {
//        [newViewControllers addObject:searchViewController];
//        [self.navigationController setViewControllers:newViewControllers animated:true];
//    }else{
//        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Search" bundle: nil];
//        SearchViewController *destinationViewController = (SearchViewController *)[mainStoryboard instantiateViewControllerWithIdentifier: @"SVC"];
//        [TealiumHelper trackTealiumSearchEvent];
//        [self.navigationController pushViewController:destinationViewController animated:YES];
//    }
//    
//}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}


@end
