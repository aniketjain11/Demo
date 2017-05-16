//
//  UtilityClass.m
//  Demo
//
//  Created by Aniket Jain on 16/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import "UtilityClass.h"

@implementation UtilityClass


+(void)removeActivityIndicatorFromView : (UIView *)jokesView{
//    [MBProgressHUD hideHUDForView:jokesView animated:true];
//    [MBProgressHUD hideAllHUDsForView:jokesView animated:true];
}

+(void)setDefaultActivityIndicatorAtView:(UIView *)view showJokes:(BOOL)showJokes{
    
//    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:true];
//    
//    if (showJokes) {
//        hud.bezelView.color = [UIColor clearColor];
//        hud.activityIndicatorColor = [UIColor darkGrayColor];
//        hud.detailsLabel.textColor = [UIColor darkGrayColor];
//        
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:@"jokes" ofType:@"json"];
//        NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
//        NSArray *jokesArray = (NSArray *)[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:nil];
//        [self setQuestionOnHUD:hud fromArray:jokesArray];
//    }
}
@end
