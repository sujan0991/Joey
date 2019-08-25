//
//  FacilityListTableViewCell.h
//  JoeyPod
//
//  Created by Sujan on 2/14/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface FacilityListTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *joeyPodName;
@property (weak, nonatomic) IBOutlet UILabel *joeyPodcheckIn;


@property (weak, nonatomic) IBOutlet RateView *rateview;

@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *distance;

@property (weak, nonatomic) IBOutlet UIButton *favoriteBtn;


- (IBAction)favoriteBtn:(id)sender;

@end
