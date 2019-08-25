//
//  FAQsViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/6/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SKSTableView.h"
#import "CCKFNavDrawer.h"

@interface FAQsViewController : UIViewController<SKSTableViewDelegate,UITableViewDataSource,UITableViewDelegate,CCKFNavDrawerDelegate>


@property (weak, nonatomic) IBOutlet SKSTableView *sksTableView;

@property(nonatomic,strong)NSMutableArray* favoriteListArray;
@property (nonatomic,strong)NSMutableArray* distanceArray;


- (IBAction)drawerToggle:(id)sender;

@end
