//
//  MessagesViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/6/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CCKFNavDrawer.h"

@interface MessagesViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,CCKFNavDrawerDelegate,UIAlertViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *messagesTableView;

@property(nonatomic,strong)NSMutableArray* favoriteListArray;
@property (nonatomic,strong)NSMutableArray* distanceArray;

@property (weak, nonatomic) IBOutlet UILabel *noMessageLabel;

- (IBAction)drawerToggle:(id)sender;

@end
