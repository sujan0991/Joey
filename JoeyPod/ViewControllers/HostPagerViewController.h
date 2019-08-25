//
//  HostPagerViewController.h
//  JoeyPod
//
//  Created by Sujan on 2/25/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "ViewPagerController.h"
#import <QuartzCore/QuartzCore.h>
#import "CCKFNavDrawer.h"

@interface HostPagerViewController : ViewPagerController<CCKFNavDrawerDelegate>

@property(nonatomic,strong)NSMutableArray* favoriteListArray;
@property (nonatomic,strong)NSMutableArray* distanceArray;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;
@property (weak, nonatomic) IBOutlet UIButton *drawerBtn;

- (IBAction)drawerToggle:(id)sender;


- (IBAction)backButton:(id)sender;

@end
