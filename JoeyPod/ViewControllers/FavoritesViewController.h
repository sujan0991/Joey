//
//  FavoritesViewController.h
//  JoeyPod
//
//  Created by Sujan on 3/29/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"
#import "CCKFNavDrawer.h"

@interface FavoritesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,RateViewDelegate,CCKFNavDrawerDelegate>


@property (weak, nonatomic) IBOutlet UITableView *favoriteTableView;

@property(nonatomic,strong)NSMutableArray* favoriteListArray;
@property (nonatomic,strong)NSMutableArray* distance;
@property (strong,nonatomic) NSString* roomId;

@property (weak, nonatomic) IBOutlet UILabel *favoriteLabel;

- (IBAction)drawerToggle:(id)sender;

- (IBAction)backButton:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *drawerBtn;
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@end
