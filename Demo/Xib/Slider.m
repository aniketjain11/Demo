//
//  Slider.m
//  Demo
//
//  Created by Aniket Jain on 17/05/17.
//  Copyright © 2017 Aniket Jain. All rights reserved.
//

#import "Slider.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"
#import "UtilityClass.h"


#define CMS_IMAGE_HOST @"asdf"

@implementation Slider{

    NSArray *images;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)awakeFromNib{
    [super awakeFromNib];
    
    images  = [NSArray arrayWithObjects:@"https://www.w3schools.com/css/img_fjords.jpg",@"https://www.w3schools.com/css/trolltunga.jpg",@"https://www.w3schools.com/css/img_fjords.jpg",@"https://www.w3schools.com/css/trolltunga.jpg", nil];
    
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"ProductCell"];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return 4;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProductCell" forIndexPath:indexPath];
    
    [[cell subviews] makeObjectsPerformSelector: @selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, cell.frame.size.height)];
    [imageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", images[indexPath.row]]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    [cell addSubview:imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self.collectionView.layer removeAllAnimations];
    [UtilityClass animatePageViewControl:self.pageControl forScrollView:scrollView];
}

- (void)itemTapped:(UITapGestureRecognizer *)gestureRecognizer{
    
   
}


@end
