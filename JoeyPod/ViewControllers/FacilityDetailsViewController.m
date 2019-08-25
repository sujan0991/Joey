//
//  FacilityDetailsViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/7/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "FacilityDetailsViewController.h"
#import "CheckInViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "FavoritesViewController.h"
#import "ReportProblemViewController.h"
#import "HexColors.h"
#import <AFNetworking.h>
#import "UIImageView+WebCache.h"
#import "Urls.h"
#import "RSSliderView.h"
#import "AllPhotosViewController.h"
#import "AllCommentViewController.h"
#import <Social/Social.h>
#import "HostPagerViewController.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"

@interface FacilityDetailsViewController ()<RSliderViewDelegate>{

    NSMutableArray *imageArray;
    NSMutableArray *commentArray;
    NSMutableArray *favoriteArray;
    NSMutableArray *ratingArray;
    NSMutableArray *amenitiesArray;
    NSString *amenitiestypeId;
    NSString* userId;
    
    NSString* hasWifi;
    NSString* hasElectricity;
    NSString* hasChanging;
    NSString* hasDaipers;
    
    CLLocationManager *locationManager;
    CLLocation *roomLocation;
    double distanceInmeters;
    CLLocationCoordinate2D currentLocation;
    
    RSSliderView *easySlider;
    RSSliderView *cleanSlider;
    RSSliderView *calmSlider;
    
    int isNeatCount;
    int isEasyFindCount;
    int isCalmCount;
    
    int isNeatNoCount;
    int isEasyFindNoCount;
    int isCalmNoCount;
    
    int favoriteCount;
    
    NSString* latitude;
    NSString* longitude;
    
    float tableheight;
    JTMaterialSpinner *spinner;
}

@end

@implementation FacilityDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
   
    self.roomDetails=[[NSMutableDictionary alloc] init];
    
    NSLog(@"distance :%@",self.distanceFromLocation);
    
    self.checkinTimeView.hidden =YES;
   // self.rateViewInNev.hidden = YES;
    
    self.temporaryLabel.hidden = YES;
    self.temporaryLabel.layer.cornerRadius = 5.0;
    self.temporaryLabel.layer.borderWidth = 1.1f;
    self.temporaryLabel.layer.borderColor= [[UIColor hx_colorWithHexString:@"C5006A"]CGColor];
    
    self.imagePicker = [[RBImagePickerController alloc] init];
    self.imagePicker.delegate = self;
    self.imagePicker.dataSource = self; // To control selection count
    self.imagePicker.selectionType = RBMultipleImageSelectionType;
    
    
    self.editDetailView.layer.cornerRadius = 5.0;
    self.commentWhatBtn.layer.cornerRadius = self.commentWhatBtn.frame.size.width/2;
    
//    self.ratingLabel.text = [NSString stringWithFormat:@"Rating:%.01f/5(From last 100 visitors)",self.rating];
    //self.joeyNameLabel.text = self.joeyName;
    
    NSLog(@"room id?????? : %@",self.roomID);
    
    self.detailView.hidden = YES;
    self.maineditDetailView.hidden =YES;
    self.editDetailView.hidden=YES;
    self.detailViewHeight.constant = 5;
    
   // NSLog(@"room list array  %@",self.roomListArray);
    
   // [self makeRequest];
    

    
}

//NSLog(@" .................... :%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"login"]);

-(void)viewDidAppear:(BOOL)animated{
    
    
    easySlider = [[RSSliderView alloc] initWithFrame:CGRectMake(0, 0, self.easySliderView.bounds.size.width, 21) andOrientation:Horizontal];
    // easySlider.delegate = self;
    easySlider.tag = 1;
    [easySlider setColorsForBackground:[UIColor hx_colorWithHexString:@"F5F8E9" alpha:1.0]
                            foreground:[UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0]
                                handle:[UIColor colorWithRed:0.0 green:205.0/255.0 blue:184.0/255.0 alpha:1.0]
                                border:[UIColor lightGrayColor]];
    
    [self.easySliderView addSubview:easySlider];
    [self.easySliderView bringSubviewToFront:self.easyToFindYescountLabel];
    [self.easySliderView bringSubviewToFront:self.easyToFindNocountLabel];
    
    NSLog(@"easySlider frame %f",easySlider.frame.size.width);
    NSLog(@"easySliderView frame %f",self.easySliderView.bounds.size.width);
    
    easySlider.userInteractionEnabled = NO;
    
    
    // If you don't need handle
    [easySlider hideHandle];
    // if you don't like round corners or border
    [easySlider removeRoundCorners:YES removeBorder:YES];
    
    cleanSlider = [[RSSliderView alloc] initWithFrame:CGRectMake(0, 0, self.cleanSliderView.bounds.size.width, 21) andOrientation:Horizontal];
    // cleanSlider.delegate = self;
    
    cleanSlider.tag = 2;
    [cleanSlider setColorsForBackground:[UIColor hx_colorWithHexString:@"F5F8E9" alpha:1.0]
                             foreground:[UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0]
                                 handle:[UIColor colorWithRed:0.0 green:205.0/255.0 blue:184.0/255.0 alpha:1.0]
                                 border:[UIColor lightGrayColor]];
    
    [self.cleanSliderView addSubview:cleanSlider];
    [self.cleanSliderView bringSubviewToFront:self.cleanYesCountLabel];
    [self.cleanSliderView bringSubviewToFront:self.cleanNoCountLabel];
    
    
    cleanSlider.userInteractionEnabled = NO;
    
    // If you don't need handle
    [cleanSlider hideHandle];
    // if you don't like round corners or border
    [cleanSlider removeRoundCorners:YES removeBorder:YES];
    
    calmSlider = [[RSSliderView alloc] initWithFrame:CGRectMake(0, 0, self.calmSliderView.bounds.size.width, 21) andOrientation:Horizontal];
    //calmSlider.delegate = self;
    calmSlider.tag = 3;
    [calmSlider setColorsForBackground:[UIColor hx_colorWithHexString:@"F5F8E9" alpha:1.0]
                            foreground:[UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0]
                                handle:[UIColor colorWithRed:0.0 green:205.0/255.0 blue:184.0/255.0 alpha:1.0]
                                border:[UIColor lightGrayColor]];
    
    [self.calmSliderView addSubview:calmSlider];
    [self.calmSliderView bringSubviewToFront:self.calmYesLabel];
    [self.calmSliderView bringSubviewToFront:self.calmNoLabel];
    
    
    calmSlider.userInteractionEnabled = NO;
    
    // If you don't need handle
    [calmSlider hideHandle];
    // if you don't like round corners or border
    [calmSlider removeRoundCorners:YES removeBorder:YES];
    

    NSLog(@"?????????????? :%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    
    [self makeRequest];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makeRequest{
    
    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NSLog(@"status %ld",(long)status);
    
    if(status == NotReachable)
    {
        
        [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
        
    }
    else{
        
    spinner.hidden = NO;
    [spinner beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital",
                            @"room_id": self.roomID};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
  
    [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"feeding-rooms/api-get-feeding-room-detail"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"...........%@",responseObject);
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        self.feedingRoomDetail =  (NSMutableDictionary *)responseObject;
        
        
        self.roomDetails = [self.feedingRoomDetail objectForKey:@"RoomDetail"];
        
      //  NSLog(@"Room Detail: %@",self.roomDetails);
        
        latitude = [self.roomDetails objectForKey:@"latitude"];
        longitude = [self.roomDetails objectForKey:@"longitude"];
        
        //calculate distance
        
        if (locationManager==nil)
        {
            locationManager = [[CLLocationManager alloc] init];
        }
        
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.headingFilter = 1;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        
        currentLocation = locationManager.location.coordinate;
        
        CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:currentLocation.latitude
                                                              longitude:currentLocation.longitude ];
        
        NSLog(@"current location in   %f  ,%f",currentLocation.latitude,currentLocation.longitude);
        
        roomLocation = [[CLLocation alloc] initWithLatitude:[[self.roomDetails objectForKey:@"latitude"]doubleValue]
                                                  longitude:[[self.roomDetails objectForKey:@"longitude"]doubleValue] ];
        
        
        distanceInmeters =(int) [userLocation distanceFromLocation:roomLocation];
        
        self.distanceFromLocation = [NSString stringWithFormat:@"%f",distanceInmeters];
        
        NSLog(@"distance in   %f",distanceInmeters);
        
        
        ///  !!!!!!!!!!!!!! Rating in nav
        
//        self.ratingLabel.text =[NSString stringWithFormat:@"%.01f/5",[[self.roomDetails objectForKey:@"rating"] floatValue]];

        self.rateViewInNev.notSelectedImage = [UIImage imageNamed:@"star_notselected.png"];
        self.rateViewInNev.halfSelectedImage = [UIImage imageNamed:@"star_half_selected.png"];
        self.rateViewInNev.fullSelectedImage = [UIImage imageNamed:@"star_selected.png"];
        self.rateViewInNev.rating = [[self.roomDetails  objectForKey:@"rating"]floatValue];
        self.rateViewInNev.editable = NO;
        self.rateViewInNev.maxRating = 5;
        self.rateViewInNev.delegate = self;
        
        NSLog(@"rating  %@",[self.roomDetails objectForKey:@"rating"]);
       
        self.joeyNameLabel.text = [self.roomDetails objectForKey:@"title"];
        
        //making shortdetail
        self.roomShortDetails = [[NSMutableDictionary alloc]init];
        
        [self.roomShortDetails setObject:[self.roomDetails objectForKey:@"id"] forKey:@"id"];
        [self.roomShortDetails setObject:[self.roomDetails objectForKey:@"title"] forKey:@"title"];
        [self.roomShortDetails setObject:[self.roomDetails objectForKey:@"rating"] forKey:@"ratings"];
        [self.roomShortDetails setObject:[self.roomDetails objectForKey:@"latitude"] forKey:@"latitude"];
        [self.roomShortDetails setObject:[self.roomDetails objectForKey:@"longitude"] forKey:@"longitude"];
        [self.roomShortDetails setObject:[self.roomDetails objectForKey:@"direction"] forKey:@"direction"];
        [self.roomShortDetails setObject:[self.roomDetails objectForKey:@"checkin_count"] forKey:@"checkin_count"];
        [self.roomShortDetails setObject:[self.roomDetails objectForKey:@"is_approved"] forKey:@"is_approved"];
        [self.roomShortDetails setObject:[self.roomDetails objectForKey:@"is_temporary"] forKey:@"is_temporary"];
        [self.roomShortDetails setObject:self.distanceFromLocation forKey:@"distance"];
        
        NSLog(@"new created shortdetail:  %@",self.roomShortDetails);
        
        
        self.editDetailRoomNameLabel.text = [NSString stringWithFormat:@"Edit Info About Amenities Available at %@",self.joeyNameLabel.text];
        
        commentArray =[[NSMutableArray alloc]initWithArray:[self.roomDetails objectForKey:@"checkins"]];
        imageArray = [self.roomDetails objectForKey:@"feeding_room_images"];
        ratingArray = [self.roomDetails objectForKey:@"ratings"];
        favoriteArray = [self.roomDetails objectForKey:@"favorites"];
        
        favoriteCount = favoriteArray.count;
        
        
        //favorite or not
        for (int i = 0; i< favoriteArray.count; i++) {
            
            NSMutableDictionary *singleFavorite = [favoriteArray objectAtIndex:i];
            NSString* userIdInFavorite = [singleFavorite objectForKey:@"user_id"];
            NSString* useridInApp = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
            int userIdiInInt = [useridInApp integerValue];
            
            NSLog(@"id.......%@",userIdInFavorite);
            NSLog(@"userid.......in app %d",userIdiInInt);
            
           if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"])
           {
            
               if ([userIdInFavorite integerValue] ==  userIdiInInt )
               {
                   self.isFavorite = [singleFavorite objectForKey:@"is_favorite"];
                   
                   NSLog(@"isfavorite   %@",self.isFavorite);
               }
            
           }
        }
        
        // for match rating

//        for (int i = 0; i< commentArray.count; i++) {
//            
//            NSMutableDictionary* commentDetail = [[commentArray objectAtIndex:i]mutableCopy];
//            
//            for (int j = 0; j < ratingArray.count; j++) {
//                
//              
//                NSMutableDictionary* ratingDetail = [ratingArray objectAtIndex:j];
//                
//                int userIdInComment = [commentDetail objectForKey:@"user_id"];
//                int userIdInRating = [ratingDetail objectForKey:@"user_id"];
//                
//                NSLog(@"id in comment%d",userIdInComment);
//                NSLog(@"id in rating%d",userIdInRating);
//                
//                if (userIdInComment == userIdInRating) {
//                    
//                  // NSMutableDictionary *singleComment = [[NSMutableDictionary alloc] init];
//                    
//                    [commentDetail setObject:[ratingDetail objectForKey:@"rating"] forKey:@"rating"];
//                    [commentArray replaceObjectAtIndex:i withObject:commentDetail];
//                    break;
//                }
//            }
//        }
        
        
      //  NSLog(@"comment array  %@",commentArray);
        
        NSString* isApproved = [self.roomDetails objectForKey:@"is_approved"];
        NSString* isTemporary = [self.roomDetails objectForKey:@"is_temporary"];
        
        if ([isTemporary integerValue] == 1) {
            self.temporaryLabel.hidden = NO;
        }
        
      //  NSLog(@"Comment array:%@",commentArray);
        
       // NSLog(@"Image array:%@",imageArray);
        
        
        //for collectionView dynamic height
       // self.photoCollectionHeight.constant=  ceil( (imageArray.count+1)/3)*(([UIScreen mainScreen].bounds.size.width-50)/3+10);
        //for maenities
        
        isEasyFindCount = 0;
        isNeatCount = 0;
        isCalmCount = 0;
        
        isNeatNoCount = 0;
        isEasyFindNoCount = 0;
        isCalmNoCount= 0;
        
        for (int i = 0; i < commentArray.count; i++) {
            
            NSMutableDictionary* singleComment = [commentArray objectAtIndex:i];
            
            NSString* isEasyToFind = [singleComment objectForKey:@"is_easy_find"];
            
            if ([isEasyToFind integerValue] == 1) {
                
                isEasyFindCount++;
                
            }else if ([isEasyToFind integerValue] == 0){
            
                isEasyFindNoCount++;
            }
            
            
            NSString* isClean = [singleComment objectForKey:@"is_neat"];
            
            if ([isClean integerValue] == 1) {
                
                isNeatCount++;
                
            }else if ([isClean integerValue] == 0){
                
                isNeatNoCount++;
            }
            
            NSString* isCalm = [singleComment objectForKey:@"is_quiet"];
            if ([isCalm integerValue] == 1) {
                
                isCalmCount++;
                
            }else if ([isCalm integerValue] == 0){
                
                isCalmNoCount++;
            }

        }
        
        NSLog(@"easy to find count %d",isEasyFindCount);
        NSLog(@"easy to find no count %d",isEasyFindNoCount);
        
        NSLog(@"clean count %d",isNeatCount);
        NSLog(@"clean no count %d",isNeatNoCount);
        NSLog(@" count %d",isCalmCount);
        NSLog(@" no count %d",isCalmNoCount);
        
        self.easyToFindYescountLabel.text = [NSString stringWithFormat:@"%d",isEasyFindCount];
        self.easyToFindNocountLabel.text = [NSString stringWithFormat:@"%d",isEasyFindNoCount];
        
        float easySliderValue = 0;
        
        NSLog(@"easySliderValue   %f",easySliderValue);
        
        if (isEasyFindCount+isEasyFindNoCount > 0) {
            
            easySliderValue = ((float)isEasyFindCount/(isEasyFindCount+isEasyFindNoCount));
            
            NSLog(@"easySliderValue   %f",easySliderValue);
        }
        
        
        
        if (commentArray.count == 0) {
            
            [easySlider setValue:0 withAnimation:YES completion:^(BOOL finished) {
                ;
            } ];
        }else{
            
        
            [easySlider setValue:easySliderValue withAnimation:YES completion:^(BOOL finished) {
                ;
            } ];
        
        }
        
      //  NSLog(@"clean to find count %d",isNeatCount);
      //  NSLog(@"clean to find no count %d",isNeatNoCount);
        
        self.cleanYesCountLabel.text =[NSString stringWithFormat:@"%d",isNeatCount];
        self.cleanNoCountLabel.text =[NSString stringWithFormat:@"%d",isNeatNoCount];
        
        float cleanSliderValue = 0;
        
        if ((isNeatCount + isNeatNoCount) > 0) {
            
            cleanSliderValue = ((float)isNeatCount/(isNeatCount + isNeatNoCount));
            
            NSLog(@"cleanSliderValue   %f",cleanSliderValue);
        }
       
        
        if (commentArray.count == 0) {
            
            [cleanSlider setValue:0 withAnimation:YES completion:^(BOOL finished) {
                ;
            } ];
        }else{
        [cleanSlider setValue:cleanSliderValue withAnimation:YES completion:^(BOOL finished) {
            ;
        } ];
        }
        
        
        self.calmYesLabel.text =[NSString stringWithFormat:@"%d",isCalmCount];
        self.calmNoLabel.text =[NSString stringWithFormat:@"%d",isCalmNoCount];
        
        float calmSliderValue =0;
        
        if ((isCalmCount+isCalmNoCount > 0 )) {
            
            calmSliderValue = ((float)isCalmCount/(isCalmCount+isCalmNoCount));
            
            NSLog(@"calmSliderValue   %f",calmSliderValue);
        }
        
        
        if (commentArray.count == 0) {
            
            [calmSlider setValue:0 withAnimation:YES completion:^(BOOL finished) {
                ;
            } ];
        }else{
        [calmSlider setValue:calmSliderValue withAnimation:YES completion:^(BOOL finished) {
            ;
        } ];
        }
        
        if(imageArray.count == 0){
            
            self.photoCollectionHeight.constant = 5;
            
        }else if (imageArray.count < 3) {
            self.photoCollectionHeight.constant= (([UIScreen mainScreen].bounds.size.width-40)/3);
        }else
        {
            self.photoCollectionHeight.constant= (([UIScreen mainScreen].bounds.size.width-40)/3)*2;
            
        }
        
   
        
        amenitiesArray = [self.roomDetails objectForKey:@"amenities"];
        
        for (int i= 0; i<amenitiesArray.count; i++) {
            
              NSMutableDictionary *amenitiesDetail = [amenitiesArray objectAtIndex:i];
              
              // NSLog(@"Amenity.....:%@",[amenitiesArray objectAtIndex:i]);
              
              amenitiestypeId = [amenitiesDetail objectForKey:@"id"];
              
              
              if ([amenitiestypeId integerValue]==1) {
                  
                  [self.wifiMainBtn setSelected:YES];
                  [self.wifiBtn setSelected:YES];
                  
              } else if([amenitiestypeId integerValue]==2){
                  
                  [self.electricalMainBtn setSelected:YES];
                  [self.electricalbtn setSelected: YES];
                  
              }else if([amenitiestypeId integerValue]==3){
                  
                  [self.changingMainBtn setSelected:YES];
                  [self.changingBtn setSelected: YES];
                  
              }else if([amenitiestypeId integerValue]==4){
                  
                  [self.freeDiaperMainBtn setSelected:YES];
                  [self.freeDiaperBtn setSelected: YES];
              }
              
          }
        //for credit
        
        NSMutableDictionary *nickName = [self.roomDetails objectForKey:@"user"];
        self.creditInfoLabel.text = [NSString stringWithFormat:@"This feeding room was added to map on %@ by",[self.roomDetails objectForKey:@"created"]];
        self.nickNameLabel.text = [nickName objectForKey:@"nickname"];
        
        //////
        
        self.locationLabel.text = [self.roomDetails objectForKey:@"direction"];
        self.photoLabel.text = [NSString stringWithFormat:@"Photos (%lu)",(unsigned long)imageArray.count];
        self.commentLabel.text = [NSString stringWithFormat:@"Visitor Comments (%lu)",(unsigned long)commentArray.count];
        
        userId = [self.roomDetails objectForKey:@"user_id"];
        
        
        
     //   NSLog(@"USER-ID:%@",userId);
        
     //   NSLog(@"self.commentTableHeight.constant%f",self.commentTableHeight.constant);
        
        tableheight = 100;
        
        if (commentArray.count < 3) {
            
            self.commentTableHeight.constant=  tableheight * commentArray.count;
            
     //       NSLog(@"commentTableHeight..........%f",tableheight);
            
        }else if (commentArray.count >=3){
            
            self.commentTableHeight.constant=  tableheight * 3;
      //         NSLog(@"self.commentTableHeight.constant..........%f",self.commentTableHeight.constant);
        }
        
        [self.actionCollectionView reloadData];
        [self.photoCollectionView reloadData];
        [self.commentTableView reloadData];
        [self.actionTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:self
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
        
//        alert.tag = 700;
//        
//        [alert show];
    }];
    
 }
}

-(void) calculateDistance {

    currentLocation = locationManager.location.coordinate;
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:currentLocation.latitude
                                                          longitude:currentLocation.longitude ];

    
    roomLocation = [[CLLocation alloc] initWithLatitude:[[self.roomDetails objectForKey:@"latitude"]doubleValue]
                                              longitude:[[self.roomDetails objectForKey:@"longitude"]doubleValue] ];
  

    distanceInmeters =(int) [userLocation distanceFromLocation:roomLocation];
    
    NSLog(@"distance in   %f",distanceInmeters);

}

#pragma mark - CollectionView data source

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    if (collectionView.tag == 1) {
        
        return  5;
        
    }else{
        if (imageArray.count <= 6) {
            
            return imageArray.count;
            
        }else{
            return 6;
        }
            
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (collectionView.tag == 1) {
        static NSString *identifier = @"actionCell";
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
        
        //NSDictionary *details = [self.roomDetails objectAtIndex:0];
  
        UIImageView *actionImage = (UIImageView*) [cell viewWithTag:1];
        UILabel *actionLabel = (UILabel*) [cell viewWithTag:2];
        
        if (indexPath.row ==0) {
            actionImage.image = [UIImage imageNamed:@"9icon"];
            
//            if([self.roomDetails objectForKey:@"checkin_count"] != [NSNull null])
//                actionLabel.text = [NSString stringWithFormat:@"%@",[self.roomDetails objectForKey:@"checkin_count"]];
//           else
            actionLabel.text=@"";
            if([self.roomDetails objectForKey:@"checkin_count"])
                actionLabel.text = [NSString stringWithFormat:@"%@",[self.roomDetails objectForKey:@"checkin_count"]];
            
        }else if (indexPath.row==1){
            if ([self.isFavorite integerValue] ==1) {
                
                actionImage.image = [UIImage imageNamed:@"10icon"];
                //actionLabel.text = @"";
                actionLabel.text = [NSString stringWithFormat:@"%d",favoriteCount];
                
            }else{
               
                actionImage.image = [UIImage imageNamed:@"loveicons"];
                //actionLabel.text = @"";
                actionLabel.text = [NSString stringWithFormat:@"%d",favoriteCount];
            }
     
        }else if (indexPath.row==2){
            actionImage.image = [UIImage imageNamed:@"11icon"];
            actionLabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)imageArray.count];
            
        }else if (indexPath.row==3){
            actionImage.image = [UIImage imageNamed:@"12icon"];
            actionLabel.text = @"";
            
        }else if (indexPath.row==4){
            actionImage.image = [UIImage imageNamed:@"13icon"];
            actionLabel.text = @"";
            
        }
        
        return cell;
        
    }else{
    
        static NSString *identifier = @"photoCell";
        
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
 
        NSMutableDictionary *details = [imageArray objectAtIndex:(imageArray.count - indexPath.row - 1)];
     
        NSString *imageUrl = [details objectForKey:@"image"];
        
        UIImageView *photoImageView = (UIImageView *)[cell viewWithTag:1];
        
  //  [photoImageView.image sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/%@",baseUrl,imageUrl]]  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        
        
        [photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",baseUrl,imageUrl]]];
       
        NSLog(@"IMAge URL:%@%@",baseUrl,imageUrl);
        
        UIButton *showAll =(UIButton*)[cell viewWithTag:2];
        showAll.layer.cornerRadius = 8.0;
        
        showAll.hidden = YES;
        
        
        if(imageArray.count>6 && indexPath.row==5)
        {
            showAll.hidden = NO;
            photoImageView.hidden = YES;
        }
        else
        {
            photoImageView.hidden = NO;
            showAll.hidden = YES;
        }
 
   
        
        return cell;
    
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
     if (collectionView.tag == 2)
     {
         NSLog(@" collection view %@ %lf",collectionView,([UIScreen mainScreen].bounds.size.width-36)/3);
         return CGSizeMake(([UIScreen mainScreen].bounds.size.width-36)/3, ([UIScreen mainScreen].bounds.size.width-36)/3);

     }
    else
    {
        return CGSizeMake(50,63 );
    }
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    if (collectionView.tag == 1) {
        
        NSLog(@"collectionview 1 clicked");
        
        
        if (indexPath.row == 0) {
            
            NSLog(@"time of checkin %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"CheckInTime"]);
            
            NSLog(@"room id  %@",self.roomID);
            
            NSString* checkInTime = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],self.roomID];
            
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:checkInTime] != [NSNull null])
            {
                
                 NSDate *endTime = [[[NSUserDefaults standardUserDefaults] objectForKey:checkInTime] dateByAddingTimeInterval:60*60*1];
                
//                if([[[NSUserDefaults standardUserDefaults] objectForKey:@"RoomId"] isEqualToString: self.roomID ]){
//                
//                  NSLog(@"same room");
//                    
//                }else{
                
                if(([[NSDate date] compare:endTime]  != NSOrderedAscending  ))
                {
                    
                    NSLog(@"allowed to checkin");
                    
                    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
                        
                        CheckInViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckInViewController"];
                        [self.navigationController pushViewController:vc animated:YES];
                        
                        vc.roomId = self.roomID;
                        vc.userId = userId;
                        
                        NSLog(@"user id in check:%@",vc.userId);
                        
                    }else{
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                        message:@"Please login or sign up to use this feature."
                                                                       delegate:self
                                                              cancelButtonTitle:@"Cancel"
                                                              otherButtonTitles:@"Sign up/Login", nil];
                        alert.tag = 200;
                        
                        [alert show];
                    }
                    
                    
                }
                else
                {
                    
                    
                    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMinute
                                                                        fromDate:[NSDate date]
                                                                          toDate:endTime
                                                                         options:NSCalendarWrapComponents];
                    
                    NSLog(@"not allowed to checkin within %ld",(long)[components minute]);
                    
                    self.checkinTimeView.hidden = NO;
                    self.checkinTimeLabel.text =[NSString stringWithFormat:@"You have already given check in for this room.Another check in is available in %d minutes.",[components minute]];
                    
                    [self performSelector:@selector(secondMethod) withObject:nil afterDelay:3.0 ];
                    
//                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                    message:[NSString stringWithFormat:@"You are not allowed to checkin within %d minutes",[components minute]]
//                                                                   delegate:nil
//                                                          cancelButtonTitle:@"Ok"
//                                                          otherButtonTitles: nil];
//                    
//                    
//                    [alert show];
                    
                    
                    
                }

//                }
            }
           

           
            
            
            
        }else if (indexPath.row == 1) {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
                
               // [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"favorite"];
                
                [self makeFavorite];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Please login or sign up to use this feature."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Sign up/Login", nil];
                alert.tag = 115;
                
                [alert show];
            }
            
           
        }else if (indexPath.row == 2) {
            
            self.imagePicker.roomId=self.roomID;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
           // [self.navigationController pushViewController:self.imagePicker animated:YES];
        }else if (indexPath.row == 3) {
            
            //Network connection
            
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            [reachability startNotifier];
            
            NetworkStatus status = [reachability currentReachabilityStatus];
            
            NSLog(@"status %ld",(long)status);
            
            if(status == NotReachable)
            {
                
                [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
                
            }
            else{

            NSString* sharedLocation = [NSString stringWithFormat:@"%@,%@",latitude,longitude];
            
            NSLog(@"%@",sharedLocation);
            
            NSString* urlString = [NSString stringWithFormat:@"http://maps.google.com/?q=%@",sharedLocation];
            
            NSLog(@"urlString     :%@",urlString);
            
            
            NSArray *Items = [NSArray arrayWithObjects:urlString, nil];
                              
                              UIActivityViewController *ActivityView =
                              [[UIActivityViewController alloc]
                               initWithActivityItems:Items applicationActivities:nil];
                              
                              [self presentViewController:ActivityView animated:YES completion:nil];
            
            }
            
        }else if (indexPath.row == 4) {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
                
                ReportProblemViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportProblemViewController"];
                
                vc.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
                vc.roomId = self.roomID;
                vc.roomName = self.joeyNameLabel.text;
                
                [self.navigationController pushViewController:vc animated:YES];
                
                NSLog(@"USER iD::::::::::::%@",vc.userId);
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Please login or sign up to use this feature."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Sign up/Login", nil];
                alert.tag = 116;
                
                [alert show];
            }
         
        }
    }else{
        
        AllPhotosViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllPhotosViewController"];
        
        vc.imageArray = imageArray;
        vc.roomName = self.joeyNameLabel.text;
        
        [self.navigationController pushViewController:vc animated:YES];
    
    
    
    }
    
}

-(void)secondMethod{
    
    self.checkinTimeView.hidden = YES;
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 115) {
        
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
           [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }
        
        
    }else if (alertView.tag == 116){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }
    }else if (alertView.tag == 120){
    
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
        }
    
    }else if (alertView.tag == 121){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"]; 
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
        }
        
    }else if (alertView.tag == 200){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
        }
        
    }else if (alertView.tag == 201){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
        }
        
    }else if (alertView.tag == 202){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
        }
        
    }else if (alertView.tag == 700){
        
        if (buttonIndex == [alertView cancelButtonIndex]) {
            
            NSLog(@"ok button clicked");
            
            [self makeRequest];
            
        }
        
    }



}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView.tag == 1) {
        
        if (commentArray.count < 3) {
             return commentArray.count;
            
        }else
        {
            
            return 3;
        }

        
        
       
        
    }else{
        
       return 5;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView.tag == 1) {
        static NSString *CellIdentifier = @"commentCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
            cell  = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        
        
        
        NSLog(@"..............%f",cell.contentView.frame.size.height);
        
        NSMutableDictionary *commentDetail =[commentArray objectAtIndex:(commentArray.count - indexPath.row - 1)];
        
        NSLog(@"commentdetail  %@",commentDetail);
        
        NSMutableDictionary* userInfo = [commentDetail objectForKey:@"user"];
        
        NSLog(@"user......%@",userInfo);
        
        NSString* nickName = [userInfo objectForKey:@"nickname"];
        

        UILabel *date= (UILabel*) [cell viewWithTag:1];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
        
        NSString* formatString = [commentDetail objectForKey:@"created"];
        
        [serverDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssz"];

        NSDate *commentdate = [serverDateFormatter dateFromString:formatString];
        
        [dateFormatter setDateFormat:@"EEE MMM d yyyy"];
        
        date.text =[dateFormatter stringFromDate:commentdate];
        
        UILabel *name = (UILabel*) [cell viewWithTag:2];
        //name.text =[user objectForKey:@"nickname"];
        name.text =[NSString stringWithFormat:@"%@",nickName];
        
        RateView *rateview = (RateView*) [cell viewWithTag:3];
        rateview.notSelectedImage = [UIImage imageNamed:@"star_notselected.png"];
        rateview.halfSelectedImage = [UIImage imageNamed:@"star_half_selected.png"];
        rateview.fullSelectedImage = [UIImage imageNamed:@"star_selected.png"];
        rateview.rating = [[commentDetail objectForKey:@"rating"]floatValue];
        rateview.editable = NO;
        rateview.maxRating = 5;
        rateview.delegate = self;
        
        NSLog(@"rating     in checkin %@",[commentDetail objectForKey:@"rating"]);
        
        UILabel *comment = (UILabel*) [cell viewWithTag:4];
        comment.text =[commentDetail objectForKey:@"comment"];
        
        return cell;
    }else{
    
        static NSString *CellIdentifier = @"actionCell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
            cell  = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
        
        UILabel *actionName = (UILabel*) [cell viewWithTag:2];
        
    
        UIImageView *actionImage = (UIImageView*) [cell viewWithTag:1];
        if (indexPath.row ==0) {
            actionImage.image = [UIImage imageNamed:@"14icon"];
            actionName.text =@"Check-in";
            UILabel *actionDetail = (UILabel*) [cell viewWithTag:3];
            actionDetail.text =@"Checking in and rating our feeding rooms will earn points to unlock rewards.";
            
        }else if (indexPath.row==1){
            actionImage.image = [UIImage imageNamed:@"15icon"];
            actionName.text =@"Bookmark";
            UILabel *actionDetail = (UILabel*) [cell viewWithTag:3];
            actionDetail.text =@"You can came back to this feeding room without having to search for it.";
        
        }else if (indexPath.row==2){
            actionImage.image = [UIImage imageNamed:@"16icon"];
            actionName.text =@"Add Photos";
            UILabel *actionDetail = (UILabel*) [cell viewWithTag:3];
            actionDetail.text =@"Photos give visitors a better idea of the feeding room. Good photos earn you points!";
            
        }else if (indexPath.row==3){
            actionImage.image = [UIImage imageNamed:@"17icon"];
            actionName.text =@"Report A Problem";
            UILabel *actionDetail = (UILabel*) [cell viewWithTag:3];
            actionDetail.text =@"Your feedback will help us improve the experience for you and other visitors.";
            
        }else if (indexPath.row==4){
            actionImage.image = [UIImage imageNamed:@"18icon"];
            actionName.text =@"Share With Your Friends";
            UILabel *actionDetail = (UILabel*) [cell viewWithTag:3];
            actionDetail.text =@"Let others know about this feeding room.";
        }
        
       
        return cell;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (tableView.tag == 1) {
        
        
    } else {
        
        if (indexPath.row == 0) {
            
            NSLog(@"time if checkin %@",[[NSUserDefaults standardUserDefaults]objectForKey:@"CheckInTime"]);
            
             NSString* checkInTime = [NSString stringWithFormat:@"%@%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],self.roomID];
            
            if([[NSUserDefaults standardUserDefaults] objectForKey:checkInTime] != [NSNull null])
            {
            
            NSDate *endTime = [[[NSUserDefaults standardUserDefaults] objectForKey:checkInTime] dateByAddingTimeInterval:60*60*1];
            
            
            
            if(( [[NSDate date] compare:endTime]  != NSOrderedAscending  ))
            {
                NSLog(@"allowed to checkin");
                
                if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
                    
                    CheckInViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CheckInViewController"];
                    [self.navigationController pushViewController:vc animated:YES];
                    
                    vc.roomId = self.roomID;
                    vc.userId = userId;
                    
                    NSLog(@"user id in check:%@",vc.userId);
                    
                }else{
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                    message:@"Please login or sign up to use this feature."
                                                                   delegate:self
                                                          cancelButtonTitle:@"Cancel"
                                                          otherButtonTitles:@"Sign up/Login", nil];
                    alert.tag = 201;
                    
                    [alert show];
                }
                
                
            }
            else
            {
                
                
                NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
                NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitMinute
                                                                    fromDate:[NSDate date]
                                                                      toDate:endTime
                                                                     options:NSCalendarWrapComponents];
                
                NSLog(@"not allowed to checkin within %d",[components minute]);
                
                self.checkinTimeView.hidden = NO;
                self.checkinTimeLabel.text =[NSString stringWithFormat:@"You have already given check in for this room.Another check in is available in %d minutes.",[components minute]];
                
                [self performSelector:@selector(secondMethod) withObject:nil afterDelay:3.0 ];
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                                message:[NSString stringWithFormat:@"You are not allowed to checkin within %d minutes",[components minute]]
//                                                               delegate:nil
//                                                      cancelButtonTitle:@"Ok"
//                                                      otherButtonTitles: nil];
//                
//                
//                [alert show];
                
            }
            }
            
        }else if (indexPath.row == 1) {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
                
                [self makeFavorite];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Please login or sign up to use this feature."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Sign up/Login", nil];
                alert.tag = 121;
                
                [alert show];
            }
            
        }else if (indexPath.row == 2) {
            
            self.imagePicker.roomId=self.roomID;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
            
            // [self.navigationController pushViewController:self.imagePicker animated:YES];
        }else if (indexPath.row == 3) {
            
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
                
                ReportProblemViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportProblemViewController"];
                
                vc.userId = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
                vc.roomId = self.roomID;
                vc.roomName = self.joeyNameLabel.text;
                [self.navigationController pushViewController:vc animated:YES];
                
                NSLog(@"USER iD::::::::::::%@",vc.userId);
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Please login or sign up to use this feature."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Sign up/Login", nil];
                alert.tag = 120;
                
                [alert show];
            }

            
            
        }else if (indexPath.row == 4) {
            
            //Network connection
            
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            [reachability startNotifier];
            
            NetworkStatus status = [reachability currentReachabilityStatus];
            
            NSLog(@"status %ld",(long)status);
            
            if(status == NotReachable)
            {
                
                [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
                
            }
            else{
            NSString* sharedLocation = [NSString stringWithFormat:@"%@,%@",latitude,longitude];
            
            NSLog(@"%@",sharedLocation);
            
            NSString* urlString = [NSString stringWithFormat:@"http://maps.google.com/?q=%@",sharedLocation];
            
            NSLog(@"urlString     :%@",urlString);
            
            
            NSArray *Items = [NSArray arrayWithObjects:urlString, nil];
            
            UIActivityViewController *ActivityView =
            [[UIActivityViewController alloc]
             initWithActivityItems:Items applicationActivities:nil];
            
            [self presentViewController:ActivityView animated:YES completion:nil];
            
            
            
          }
        }

        
        
    }
}

#pragma mark RWTRateViewDelegate

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    
    
}


- (IBAction)wifiButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;

}

- (IBAction)electricalButton:(UIButton *)sender {
    
     sender.selected = !sender.selected;}

- (IBAction)changingButton:(UIButton *)sender {
    
     sender.selected = !sender.selected;
}

- (IBAction)freeDiaperButton:(UIButton *)sender {
    
    sender.selected = !sender.selected;
}

- (IBAction)checkButton:(UIButton *)sender {
    
   
    
    if (sender.selected) {
        
        self.updateInfoBtn.backgroundColor = [UIColor lightGrayColor];
        self.updateInfoBtn.userInteractionEnabled = NO;
        self.updateInfoBtn.enabled = NO;
        
    }else if (!sender.selected){
        
        
        
        self.updateInfoBtn.backgroundColor = [UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
        self.updateInfoBtn.userInteractionEnabled = YES;
        self.updateInfoBtn.enabled = YES;
        
    }
      sender.selected = !sender.selected;
    
}

- (IBAction)updateInfoButton:(id)sender {
    
    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NSLog(@"status %ld",(long)status);
    
    if(status == NotReachable)
    {
        
        [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
        
    }
    else{
    
    if (self.wifiBtn.selected == YES) {
         hasWifi = @"1";
    } else {
         hasWifi = @"0";
    }
    
    if (self.electricalbtn.selected == YES) {
         hasElectricity = @"1";
    } else {
         hasElectricity = @"0";
    }
    
    if (self.changingBtn.selected == YES) {
         hasChanging = @"1";
    } else {
         hasChanging = @"0";
    }
    if (self.freeDiaperBtn.selected == YES) {
        hasDaipers = @"1";
    } else {
        hasDaipers = @"0";
    }
    
    NSLog(@"wifi  %@",hasWifi);
    
     spinner.hidden = NO;
     [spinner beginRefreshing];
        
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital",
                             @"room_id":self.roomID,
                             @"has_wifi":hasWifi,
                             @"has_electric_cable":hasElectricity,
                             @"has_changing_table":hasChanging,
                             @"has_free_diaper":hasDaipers};
        
    NSLog(@"params in updateinfo  %@",params);
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"amenities/api-add-amenities"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        self.maineditDetailView.hidden = YES;
        self.editDetailView.hidden=YES;
        
        [self.wifiMainBtn setSelected:self.wifiBtn.selected];
        [self.electricalMainBtn setSelected:self.electricalbtn.selected];
        [self.changingMainBtn setSelected:self.changingBtn.selected ];
        [self.freeDiaperMainBtn setSelected:self.freeDiaperBtn.selected];
   
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
        
        NSLog(@"operation: %@", operation.response);
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];
    }
    //[self viewDidLoad];
}

- (IBAction)showAllPhotoButton:(id)sender {
    
    AllPhotosViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AllPhotosViewController"];
    
    vc.imageArray = imageArray;
    vc.roomName = self.joeyNameLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)detailsButton:(UIButton*)sender {
 
    if (!sender.selected) {
        
        self.detailViewHeight.constant = 90;
        self.detailView.hidden = NO;
    }else if (sender.selected){
    
        self.detailViewHeight.constant = 5;
        self.detailView.hidden = YES;
    
    }
    
    sender.selected = !sender.selected;
    
    
    
}

- (IBAction)whatButton:(UIButton *)sender {
    
    if (!sender.selected) {
        
        self.commentHintViewHeight.constant = 75;
        self.commentHintView.hidden = NO;
    }else if (sender.selected){
        
        self.commentHintViewHeight.constant = 0;
        self.commentHintView.hidden = YES;
        
    }
    
    sender.selected = !sender.selected;
}

- (IBAction)editDetailButton:(id)sender {
    
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        
    self.maineditDetailView.hidden = NO;
    self.editDetailView.hidden=NO;
      
    [self.checkBtn setSelected:NO];
    self.updateInfoBtn.backgroundColor = [UIColor lightGrayColor];
    self.updateInfoBtn.userInteractionEnabled = NO;
    self.updateInfoBtn.enabled = NO;
    
    //Button round shape
    UIBezierPath *maskPath1;
    maskPath1 = [UIBezierPath bezierPathWithRoundedRect:self.updateInfoBtn.bounds
                                      byRoundingCorners:(UIRectCornerBottomRight|UIRectCornerBottomLeft)
                                            cornerRadii:CGSizeMake(5.0, 5.0)];
    
    CAShapeLayer *maskLayer1 = [[CAShapeLayer alloc] init];
    maskLayer1.frame = self.updateInfoBtn.bounds;
    maskLayer1.path = maskPath1.CGPath;
    self.updateInfoBtn.layer.mask = maskLayer1;
      
  }else{
  
      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                      message:@"Please login or sign up to use this feature."
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Sign up/Login", nil];
      alert.tag = 202;
      
      [alert show];
  
  
  }
}


- (IBAction)crossButton:(id)sender {
    
    
    
    self.maineditDetailView.hidden = YES;
    self.editDetailView.hidden=YES;
}

//ImagePicker delegate

-(void)imagePickerController:(RBImagePickerController *)imagePicker didFinishPickingImagesWithURL:(NSArray *)imageURLS{
    
    // the image picker is desmissed internally.
    for (NSURL *imageURL in imageURLS) {
        
        NSLog(@"image url %@", imageURL);
        
        
    }
    
}

-(void)imagePickerControllerDidCancel:(RBImagePickerController *)imagePicker{
    
    [imagePicker dismissViewControllerAnimated:YES completion:nil];
    
}

//ImagePicker Data source

-(NSInteger)imagePickerControllerMaxSelectionCount:(RBImagePickerController *)imagePicker
{
    
    return 5;
    
}

-(NSInteger)imagePickerControllerMinSelectionCount:(RBImagePickerController *)imagePicker
{
    
    return 0;
    
}

- (IBAction)backButton:(id)sender {
    
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


-(void)makeFavorite {

//    static NSString *identifier = @"actionCell";
//    
//    UICollectionViewCell *cell = [self.actionCollectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:1];
    
    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NSLog(@"status %ld",(long)status);
    
    if(status == NotReachable)
    {
        
        [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
        
    }
    else{
        
        spinner.hidden = NO;
        [spinner beginRefreshing];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"user_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                                 @"room_id": self.roomID };
        
        
        NSLog(@"params for favorite button:%@",params );
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"favorites/api-swap-favorite"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            NSMutableArray *favoriteRoom = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteroom"]];
            
            int roomid = [self.roomID integerValue];
            
            [[NSUserDefaults standardUserDefaults]setObject:self.roomID forKey:@"roomidInFavorite"];
            
            if ([self.isFavorite integerValue] == 1)
            {
                
                for (int i =0; i<favoriteRoom.count; i++)
                {
                    NSMutableDictionary *singleRoom = [favoriteRoom objectAtIndex:i];
                   
                    NSLog(@"Favorite singleRoom id:%@",[singleRoom objectForKey:@"id"]);
                    NSLog(@"Favorite roomShortDetails id:%d",roomid);
                    
                    if ([[singleRoom objectForKey:@"id"]integerValue] == roomid) {
                
                      [favoriteRoom removeObjectAtIndex:i];
                     
                      self.isFavorite = @"0";
                      
                      favoriteCount = favoriteCount - 1 ;
                      [self.actionCollectionView reloadData];
                    
                      [[NSUserDefaults standardUserDefaults]setObject:@"0" forKey:@"isFavorite"];
                        
                      [[NSUserDefaults standardUserDefaults]setObject:favoriteRoom forKey:@"favoriteroom"];
                        
                    //NSLog(@"Favorite array.............:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteroom"]);

                    break;
                }
            }
               
            }else
            {
                  
                         [favoriteRoom addObject:self.roomShortDetails];
                         
                         self.isFavorite = @"1";
                
                         favoriteCount = favoriteCount + 1 ;
                         [self.actionCollectionView reloadData];
                
                
                         [[NSUserDefaults standardUserDefaults]setObject:@"1"forKey:@"isFavorite"];
                
                         [[NSUserDefaults standardUserDefaults]setObject:favoriteRoom forKey:@"favoriteroom"];
 
            }

          
            NSLog(@"Favorite responce:%@",responseObject);
            NSLog(@"Favorite array:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteroom"]);
            
            //[self.actionTableView reloadData];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Sorry, we're facing issues with the network. Please try again"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }];
        
    }



}

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     AllCommentViewController *controller = (AllCommentViewController *)segue.destinationViewController;
     
     controller.commentArray = commentArray;
     controller.roomName = self.joeyNameLabel.text;
     
 }


@end
