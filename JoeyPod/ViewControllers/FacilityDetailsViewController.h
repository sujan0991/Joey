//
//  FacilityDetailsViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/7/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "RBImagePickerController.h"
#import <CoreLocation/CoreLocation.h>
#import <GooglePlus/GPPShare.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKShareKit/FBSDKShareOpenGraphObject.h>





@interface FacilityDetailsViewController : UIViewController<CLLocationManagerDelegate,UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,RateViewDelegate,RBImagePickerDelegate, UINavigationControllerDelegate, RBImagePickerDataSource,UIAlertViewDelegate>


@property (strong, nonatomic) RBImagePickerController* imagePicker;

@property (strong,nonatomic) NSString* roomID;
@property(strong,nonatomic) NSString* isFavorite;
@property(strong,nonatomic) NSString* distanceFromLocation;


@property (strong)NSMutableDictionary *feedingRoomDetail;
@property (strong,nonatomic) NSMutableDictionary *roomDetails;
@property (strong,nonatomic) NSMutableDictionary *roomShortDetails;
@property float rating;
@property(strong) NSString* joeyName;
@property(nonatomic,strong) NSMutableArray* roomListArray;
@property(nonatomic,strong) NSMutableArray* distanceArray;

@property (weak, nonatomic) IBOutlet RateView *rateViewInNev;

@property (weak, nonatomic) IBOutlet UIView *detailView;

@property (weak, nonatomic) IBOutlet UIView *easySliderView;
@property (weak, nonatomic) IBOutlet UIView *cleanSliderView;
@property (weak, nonatomic) IBOutlet UIView *calmSliderView;


@property (weak, nonatomic) IBOutlet UICollectionView *actionCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *photoCollectionView;

@property (weak, nonatomic) IBOutlet UIView *commentHintView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentHintViewHeight;


@property (weak, nonatomic) IBOutlet UIView *maineditDetailView;

@property (weak, nonatomic) IBOutlet UIView *editDetailView;




@property (weak, nonatomic) IBOutlet UITableView *commentTableView;
@property (weak, nonatomic) IBOutlet UITableView *actionTableView;

@property (weak, nonatomic) IBOutlet UIButton *editdetailsBtn;
@property (weak, nonatomic) IBOutlet UIButton *showAllBtn;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailViewHeight;


@property (weak, nonatomic) IBOutlet UIButton *wifiMainBtn;
@property (weak, nonatomic) IBOutlet UIButton *changingMainBtn;
@property (weak, nonatomic) IBOutlet UIButton *electricalMainBtn;
@property (weak, nonatomic) IBOutlet UIButton *freeDiaperMainBtn;


@property (weak, nonatomic) IBOutlet UIButton *wifiBtn;
@property (weak, nonatomic) IBOutlet UIButton *electricalbtn;
@property (weak, nonatomic) IBOutlet UIButton *changingBtn;
@property (weak, nonatomic) IBOutlet UIButton *freeDiaperBtn;
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateInfoBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentWhatBtn;

@property (weak, nonatomic) IBOutlet UILabel *creditInfoLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *joeyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *photoLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *easyToFindYescountLabel;
@property (weak, nonatomic) IBOutlet UILabel *easyToFindNocountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cleanYesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *cleanNoCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *calmYesLabel;
@property (weak, nonatomic) IBOutlet UILabel *calmNoLabel;


@property (weak, nonatomic) IBOutlet UIButton *temporaryLabel;

@property (weak, nonatomic) IBOutlet UILabel *editDetailRoomNameLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoCollectionHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentTableHeight;

@property (weak, nonatomic) IBOutlet UIView *checkinTimeView;
@property (weak, nonatomic) IBOutlet UILabel *checkinTimeLabel;


- (IBAction)wifiButton:(UIButton *)sender;
- (IBAction)electricalButton:(UIButton *)sender;
- (IBAction)changingButton:(UIButton *)sender;
- (IBAction)freeDiaperButton:(UIButton *)sender;
- (IBAction)checkButton:(UIButton *)sender;
- (IBAction)updateInfoButton:(id)sender;
- (IBAction)showAllPhotoButton:(id)sender;



- (IBAction)detailsButton:(UIButton*)sender;

- (IBAction)whatButton:(UIButton *)sender;

- (IBAction)crossButton:(id)sender;

@end
