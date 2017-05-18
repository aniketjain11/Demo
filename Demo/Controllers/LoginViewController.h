//
//  LoginViewController.h
//  Demo
//
//  Created by Aniket Jain on 17/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DemoBaseViewController.h"

@protocol LoginDelegate <NSObject>
@required
- (void)didLoginWithSuccess;
@end


@interface LoginViewController : DemoBaseViewController

@property (assign, nonatomic) id<LoginDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end
