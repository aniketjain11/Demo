//
//  DrawerViewController.m
//  Demo
//
//  Created by Aniket Jain on 16/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import "DrawerViewController.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import <MMDrawerController.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
#define APP_TINT_COLOR UIColorFromRGB(0xA9143C)

@interface DrawerViewController ()

@end

@implementation DrawerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"DrawerCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UIImageView *icon = (UIImageView *) [cell viewWithTag:1];
    UILabel *label = (UILabel *) [cell viewWithTag:2];
    
    
    [icon setImageWithURL:[NSURL URLWithString:@""] placeholderImage:nil usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    
    label.text = @"asdf";
    label.textColor = APP_TINT_COLOR;
    //label.textColor = [UIColor colorWithRed:30.0/255.0 green:29.0/255.0 blue:39.0/255.0 alpha:1.0];
    return cell;
}


- (IBAction)onTapDrawerHeader:(id)sender {
    
    UIStoryboard *loginStoryboard = [UIStoryboard storyboardWithName:@"Entry" bundle: nil];
    UINavigationController *navigationController = (UINavigationController *)[loginStoryboard instantiateViewControllerWithIdentifier:@"EntryNC"];
    //LoginViewController *loginViewController = (LoginViewController *)[[navigationController viewControllers] objectAtIndex:0];
//    loginViewController.delegate = (DrawerViewController *) self.mm_drawerController.leftDrawerViewController;
    
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    [self presentViewController:navigationController animated:YES completion:nil];

}



- (void) didLoginWithSuccess
{
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
