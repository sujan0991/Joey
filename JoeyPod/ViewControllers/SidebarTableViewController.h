//
//  SidebarTableViewController.h
//  JoeyPod
//
//  Created by Sujan on 2/22/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SidebarTableViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *slideTable;


@end
