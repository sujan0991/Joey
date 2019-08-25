//
//  AllCommentViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/11/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface AllCommentViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,RateViewDelegate>


@property (weak, nonatomic) IBOutlet UITableView *commenttable;

@property(nonatomic,strong)NSMutableArray* commentArray;

@property(nonatomic,strong)NSString* roomName;

@property (weak, nonatomic) IBOutlet UILabel *roomNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *NavcommentLabel;

@property (weak, nonatomic) IBOutlet UILabel *noCommentLabel;


@end
