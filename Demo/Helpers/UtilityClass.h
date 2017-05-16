//
//  UtilityClass.h
//  Demo
//
//  Created by Aniket Jain on 16/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UtilityClass : NSObject



+(void)removeActivityIndicatorFromView : (UIView *)jokesView;
+(void)setDefaultActivityIndicatorAtView:(UIView *)view showJokes:(BOOL)showJokes;

@end
