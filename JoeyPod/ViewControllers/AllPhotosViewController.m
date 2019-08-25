//
//  AllPhotosViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/7/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "AllPhotosViewController.h"
#import "UIImageView+WebCache.h"
#import "FullPhotoCollectionViewCell.h"
#import "Urls.h"


@interface AllPhotosViewController ()

@end

@implementation AllPhotosViewController{
    
    UIImageView *photoImageView;
    UIPinchGestureRecognizer *twoFingerPinch;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.joeyName.text = self.roomName;
    
    
    self.fullPhotoView.hidden = YES;
    //self.shadowView.hidden = YES;
    self.crossButton.layer.zPosition=101;
    
    self.fullPhotoCollectionView.delegate = self;
    self.fullPhotoCollectionView.dataSource = self;
    
    
}




#pragma mark - CollectionView data source

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
        
        return  self.imageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
        NSLog(@"count %lu",(unsigned long)self.imageArray.count);

    if (collectionView.tag == 1) {
        
        static NSString *identifier = @"allphotoCell";
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    
        NSDictionary *details = [self.imageArray objectAtIndex:(self.imageArray.count - indexPath.row - 1)];
    
        NSString *imageUrl = [details objectForKey:@"image"];
    
        photoImageView = (UIImageView *)[cell viewWithTag:2];
    
       [photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,imageUrl]]];
    
        return cell;
        
    }
    else if (collectionView.tag == 2){
    
    
        
        static NSString *identifier = @"fullImageCell";
        
        FullPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        
        NSDictionary *details = [self.imageArray objectAtIndex:(self.imageArray.count - indexPath.row - 1)];
        
        UIImageView *fullImage =[[UIImageView alloc]init];
        
        
        
        [fullImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,[details objectForKey:@"image"]]]];
        
        cell.pageImage = fullImage.image;
        
        [cell configueViewPhoto];
        
        
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
        
        NSString* formatString = [details objectForKey:@"created"];
        
        [serverDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssz"];
        
        NSDate *commentdate = [serverDateFormatter dateFromString:formatString];
        
        [dateFormatter setDateFormat:@"EEE MMM d, yyyy"];
        
        NSLog(@"date   ......%@",[dateFormatter stringFromDate:commentdate]);
        
        cell.dateLabel.text = [dateFormatter stringFromDate:commentdate];
        cell.feedingRoomLabel.text = self.roomName;
      
        
        
        return cell;
  
    }
    
    return nil;
}


#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    
    if (collectionView.tag == 1) {
        
        
        self.fullPhotoView.hidden = NO;

        
        [self.fullPhotoCollectionView reloadData];
        
        [self.fullPhotoCollectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        
        

    }
    
    
   

}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (collectionView.tag ==1) {
        
         return CGSizeMake(([UIScreen mainScreen].bounds.size.width-4)/3, ([UIScreen mainScreen].bounds.size.width-4)/3);
    }
    else
        
        return CGSizeMake(([UIScreen mainScreen].bounds.size.width), (self.fullPhotoCollectionView.bounds.size.height));
 
        
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)crossButton:(id)sender {
    
    NSLog(@"cross tapped");
    self.fullPhotoView.hidden = YES;
    //self.shadowView.hidden = YES;
    //self.singleImageView.hidden=YES;
    
    for (UIView *subView in self.view.subviews ) {
        if(subView.tag==301)
        {
            [subView removeFromSuperview];
        }
    }
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
