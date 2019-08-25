//
//  DrawerView.h
//  JoeyPod
//
//  Created by Sujan on 3/2/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerView : UIView


@property (weak, nonatomic) IBOutlet UITableView *drawerTable;

@property (weak, nonatomic) IBOutlet UIButton *loginButton;


//@property (weak, nonatomic) IBOutlet UILabel *welcomeLabel;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLabel;


@end
