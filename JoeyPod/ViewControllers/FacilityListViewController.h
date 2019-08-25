//
//  FacilityListViewController.h
//  JoeyPod
//
//  Created by Sujan on 2/14/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface FacilityListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RateViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *facilityTableView;

@property (weak, nonatomic) IBOutlet UILabel *roonCountLabel;

@property (strong,nonatomic) NSMutableArray* feedingRoomList;

@property (strong,nonatomic) NSMutableArray* distance;
@property(nonatomic,strong) NSMutableArray* favoriteListArray;




@property (strong,nonatomic) NSString* roomId;

- (IBAction)crossbutton:(UIButton *)sender;

- (IBAction)favoriteButton:(UIButton *)sender;

@end
