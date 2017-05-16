//
//  DemoBaseViewController.m
//  Demo
//
//  Created by Aniket Jain on 16/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import "DemoBaseViewController.h"
#import "UtilityClass.h"
#import "SSSnackbar.h"
#import "AFNetworkReachabilityManager.h"

#define NETWORK_ERROR_NOTIFICATION @"NetworkErrorNotification"
#define ADD_NETWORK_ERROR_OBSERVER [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showNetworkError:) name:NETWORK_ERROR_NOTIFICATION  object:nil];
#define REMOVE_NETWORK_ERROR_OBSERVER [[NSNotificationCenter defaultCenter] removeObserver:self name:NETWORK_ERROR_NOTIFICATION object:nil];

#define SERVER_ERROR_NOTIFICATION @"ServerErrorNotification"
#define ADD_SERVER_ERROR_OBSERVER [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showServerError:) name:SERVER_ERROR_NOTIFICATION  object:nil];
#define REMOVE_SERVER_ERROR_OBSERVER [[NSNotificationCenter defaultCenter] removeObserver:self name:SERVER_ERROR_NOTIFICATION object:nil];

#define REGISTER_KEYBOARD_NOTIFICATIONS \
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];\
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillBeHidden:) name:UIKeyboardWillHideNotification object:nil];

#define UNREGISTER_KEYBOARD_NOTIFICATIONS \
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];\
[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];

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


@interface DemoBaseViewController ()

@end

@implementation DemoBaseViewController{
    UITextField *activeField;
    UITextView *activeTextView;
    UISearchBar *activeSearchBar;
}
- (void)viewWillAppear:(BOOL)animated {
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    ADD_NETWORK_ERROR_OBSERVER
    ADD_SERVER_ERROR_OBSERVER
    
    REGISTER_KEYBOARD_NOTIFICATIONS
    
    NSDictionary *attrs = [NSDictionary dictionaryWithObjectsAndKeys:
                           [UIColor whiteColor], NSForegroundColorAttributeName,
                           [UIFont fontWithName:TC_MONSTERRAT_REGULAR size:17.0], NSFontAttributeName, nil];
    
    
    self.navigationController.navigationBar.titleTextAttributes = attrs;
    self.navigationController.navigationBar.topItem.title = @"";
    
}

- (void)viewWillDisappear:(BOOL)animated {
    REMOVE_NETWORK_ERROR_OBSERVER
    REMOVE_SERVER_ERROR_OBSERVER
    
    UNREGISTER_KEYBOARD_NOTIFICATIONS
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void) showNetworkError:(NSNotification*)notification {
    SHOW_NETWORK_ERRROR
}

- (void) showServerError:(NSNotification*)notification {
    SHOW_SERVER_ERRROR
}

- (void) refreshView {
    REFRESH_VIEW
}


- (void) resignKeyboard {
    if (activeField) {
        [activeField resignFirstResponder];
    }
    
    if (activeTextView) {
        [activeTextView resignFirstResponder];
    }
    
    if (activeSearchBar) {
        [activeSearchBar resignFirstResponder];
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    activeSearchBar = searchBar;
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    activeSearchBar = nil;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    activeSearchBar = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    activeField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    activeField = nil;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (!searchBar.inputAccessoryView) {
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
        
        NSArray *itemsArray = @[flexible, doneButton];
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setBarStyle:UIBarStyleDefault];
        [toolbar sizeToFit];
        [toolbar setItems:itemsArray];
        
        searchBar.inputAccessoryView = toolbar;
    }
    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (!textField.inputAccessoryView) {
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
        
        NSArray *itemsArray = @[flexible, doneButton];
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setBarStyle:UIBarStyleDefault];
        [toolbar sizeToFit];
        [toolbar setItems:itemsArray];
        
        textField.inputAccessoryView = toolbar;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    activeTextView = textView;
}

- (void)textViewDidEndEditing:(UITextField *)textView
{
    activeTextView = nil;
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if (!textView.inputAccessoryView) {
        
        UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(resignKeyboard)];
        
        NSArray *itemsArray = @[flexible, doneButton];
        
        UIToolbar *toolbar = [[UIToolbar alloc] init];
        [toolbar setBarStyle:UIBarStyleDefault];
        [toolbar sizeToFit];
        [toolbar setItems:itemsArray];
        
        textView.inputAccessoryView = toolbar;
    }
    return YES;
}

- (UIScrollView *) getScrollView
{
    
    if ([self.view isKindOfClass:[UIScrollView class]]) {
        return (UIScrollView *) self.view;
    }
    
    return nil;
}

//- (UITextField *) getActiveField
//{
//    return nil;
//}

- (void)keyboardWasShown:(NSNotification*)aNotification {
    NSLog(@"BaseViewController keyboardWasShown...........");
    
    UIScrollView *scrollView = [self getScrollView];
    if (scrollView) {
        NSLog(@"BaseViewController got scrollview...........");
        NSDictionary* info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(scrollView.contentInset.top, scrollView.contentInset.left, kbSize.height, scrollView.contentInset.right);
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
        
        //UITextField *activeField = [self getActiveField];
        if (activeField) {
            CGRect aRect = self.view.frame;
            aRect.size.height = aRect.size.height - kbSize.height;
            
            //            UIView *v = activeField.superview;
            //            while (v != scrollView) {
            //                v = v.superview;
            //                NSLog(@"v.class=%@", NSStringFromClass([v class]));
            //            }
            CGRect fieldFrame = [activeField.superview convertRect:activeField.frame toView:scrollView];
            //            NSLog(@"aRect=%@", NSStringFromCGRect(aRect));
            //            NSLog(@"fieldframe=%@", NSStringFromCGRect(fieldFrame));
            //            NSLog(@"contains=%d", !CGRectContainsPoint(aRect, fieldFrame.origin));
            //fieldFrame.origin.y += 90;
            if (!CGRectContainsPoint(aRect, fieldFrame.origin)) {
                [scrollView scrollRectToVisible:fieldFrame animated:YES];
            }
        }
        
        if (activeTextView) {
            CGRect aRect = scrollView.frame;
            aRect.size.height = aRect.size.height - kbSize.height;
            CGRect fieldFrame = [activeTextView.superview convertRect:activeTextView.frame toView:scrollView];
            if (!CGRectContainsPoint(aRect, fieldFrame.origin) ) {
                [scrollView scrollRectToVisible:fieldFrame animated:YES];
            }
        }
        
        if (activeSearchBar) {
            CGRect aRect = scrollView.frame;
            aRect.size.height = aRect.size.height - kbSize.height;
            CGRect fieldFrame = [activeSearchBar.superview convertRect:activeSearchBar.frame toView:scrollView];
            if (!CGRectContainsPoint(aRect, fieldFrame.origin) ) {
                [scrollView scrollRectToVisible:fieldFrame animated:YES];
            }
        }
    }
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification {
    NSLog(@"BaseViewController keyboardWillBeHidden...........");
    
    UIScrollView *scrollView = [self getScrollView];
    if (scrollView) {
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        scrollView.contentInset = contentInsets;
        scrollView.scrollIndicatorInsets = contentInsets;
    }
}

- (void)showSearch {
    
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
//        [self.navigationController pushViewController:destinationViewController animated:YES];
//    }
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
