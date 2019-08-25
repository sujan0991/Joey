//
//  AllCommentViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/11/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "AllCommentViewController.h"
#import "CommentTableViewCell.h"
#import <AFNetworking.h>
#import "Urls.h"

@interface AllCommentViewController ()

@end

@implementation AllCommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.roomNameLabel.text = self.roomName;
    self.NavcommentLabel.text = [NSString stringWithFormat:@"Visitor Comments(%lu)",(unsigned long)self.commentArray.count];
    
    self.commenttable.estimatedRowHeight = 120.0;
    self.commenttable.rowHeight = UITableViewAutomaticDimension;
    
     self.commenttable.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.commenttable.frame.size.width, 1)];
    
    NSLog(@"comment%@",self.commentArray);
    
    if (_commentArray.count == 0) {
        
        self.commenttable.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

        return self.commentArray.count;

    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *CellIdentifier = @"commentCell";
    
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell  = [[CommentTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
    cell.responseLabel.layer.cornerRadius = 5.0;
    cell.responseLabel.layer.masksToBounds=YES;
    
    //NSDictionary* comment = [self.commentArray objectAtIndex:indexPath.row];
    //[anarray objectAtIndex:(anarray.count - indexPath.row - 1)];
    
    NSDictionary* comment = [self.commentArray objectAtIndex:(self.commentArray.count - indexPath.row - 1)];
    NSDictionary* userInfo = [comment objectForKey:@"user"];
    
    NSLog(@"user......%@",userInfo);
    
    NSString* nickName = [userInfo objectForKey:@"nickname"];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];

    NSString* formatString = [comment objectForKey:@"created"];
    
    [serverDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssz"];
    
    NSDate *commentdate = [serverDateFormatter dateFromString:formatString];
    
    [dateFormatter setDateFormat:@"EEE MMM d yyyy"];
    
    cell.dateLabel.text =[dateFormatter stringFromDate:commentdate];
    cell.dateLabel.font = [UIFont fontWithName:@"Museo-300" size:13];
    
    cell.userNameLabel.text =[NSString stringWithFormat:@"%@",nickName];
    
    cell.commentLabel.text = [comment objectForKey:@"comment"];
    
    NSArray *replyArray = [comment objectForKey:@"checkin_replies"];
//    
//    NSDictionary*reply = [replyArray objectAtIndex:0];
    
    cell.responseFromJoeyLabel.layer.masksToBounds=YES;
    cell.responseFromJoeyLabel.layer.cornerRadius = 5.0;
    
    if(replyArray.count == 0){
        
        cell.responseFromJoeyLabel.hidden = YES;
        cell.responseDetailLabel.hidden = YES;
        cell.responseDetailLabel.text=@"";
    }else{
    
        cell.responseFromJoeyLabel.hidden = NO;
        cell.responseDetailLabel.hidden = NO;
        [cell.responseDetailLabel setText:[[[comment objectForKey:@"checkin_replies"] objectAtIndex:0] objectForKey:@"reply" ]];
        
    
    }
    
    NSLog(@"rating  %f",[[comment objectForKey:@"rating"]floatValue]);
    
    cell.rateView.notSelectedImage = [UIImage imageNamed:@"star_notselected.png"];
    cell.rateView.halfSelectedImage = [UIImage imageNamed:@"star_half_selected.png"];
    cell.rateView.fullSelectedImage = [UIImage imageNamed:@"star_selected.png"];
    cell.rateView.rating = [[comment objectForKey:@"rating"]floatValue];
    cell.rateView.editable = NO;
    cell.rateView.maxRating = 5;
    cell.rateView.delegate = self;
    
    return cell;
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark RWTRateViewDelegate

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
