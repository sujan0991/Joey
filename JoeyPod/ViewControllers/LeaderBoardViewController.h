//
//  LeaderBoardViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/6/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"

@interface LeaderBoardViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CCKFNavDrawerDelegate,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *leaderTableView;

@property(nonatomic,strong)NSMutableArray* favoriteListArray;
@property (nonatomic,strong)NSMutableArray* distanceArray;

@property (weak, nonatomic) IBOutlet UILabel *noUserLabel;

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;


- (IBAction)drawerToggle:(id)sender;

@end
