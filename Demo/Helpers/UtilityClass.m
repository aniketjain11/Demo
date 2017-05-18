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

+(void)animatePageViewControl:(UIPageControl *)pageControl forScrollView:(UIScrollView*)scrollView{
    CGFloat pageWidth = scrollView.frame.size.width;
    int totalPages = floor(scrollView.contentSize.width/scrollView.frame.size.width);
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    if (totalPages > 5) {
        if ((page>2 && page<totalPages-2)||(page == 2 && page<pageControl.currentPage)) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = pageControl.frame;
                frame.origin.x = - ([pageControl sizeForNumberOfPages:page].width - [pageControl sizeForNumberOfPages:2].width);
                pageControl.frame = frame;
            } completion:^(BOOL finished) {
                pageControl.currentPage = page;
            }];
        }else{
            CGRect frame = pageControl.frame;
            if (page>2) {
                frame.origin.x = - ([pageControl sizeForNumberOfPages:totalPages].width - [pageControl sizeForNumberOfPages:5].width);
            }else{
                frame.origin.x = 0;
            }
            pageControl.frame = frame;
            pageControl.currentPage = page;
        }
    }else{
        pageControl.currentPage = page;
    }
}

@end
