//
//  MessagesDetailViewController.h
//  JoeyPod
//
//  Created by Sujan on 4/6/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessagesDetailViewController : UIViewController


@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;

@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UIWebView *detailMessage;

@property(nonatomic,strong)NSString* messageId;
@property(nonatomic,strong)NSString* subject;
@property(nonatomic,strong)NSString* date;
@property int typeId;



@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loader;


- (IBAction)deletebutton:(id)sender;


@end
