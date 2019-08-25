//
//  FAQsViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/6/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "FAQsViewController.h"
#import "SKSTableViewCell.h"
#import "MapViewController.h"
#import "SettingViewController.h"
#import "FavoritesViewController.h"
#import "FAQsViewController.h"
#import "AboutJoeyViewController.h"
#import "ContactUsViewController.h"
#import "LeaderBoardViewController.h"
#import "MessagesViewController.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "HexColors.h"
#import "HostPagerViewController.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"
#import "SubRowTableViewCell.h"

@interface FAQsViewController (){

    
    NSDictionary* singleFaq;
    
    JTMaterialSpinner * spinner;
   
    
}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (strong,nonatomic) NSMutableArray* faqDetailArray;


@end

@implementation FAQsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.sksTableView.estimatedRowHeight = 70.0;
    self.sksTableView.rowHeight = UITableViewAutomaticDimension;
    
    //drawer
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    self.sksTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.sksTableView.frame.size.width, 1)];
    [self.sksTableView setSeparatorColor:[UIColor grayColor]];
  
    [self makerequest];
}

-(void)viewDidAppear:(BOOL)animated{
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginFromAlart"] isEqualToString:@"1"]) {
        
        
        NSLog(@"index  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
        [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"loginFromAlart"];
        
    }
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (alertView.tag == 107) {
        
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];

            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
        
        
    }else if (alertView.tag == 108){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];

            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
    }else if (alertView.tag == 503){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];

            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
    }else if (alertView.tag == 508){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];

            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)makerequest{

    
    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NSLog(@"status %ld",(long)status);
    
    if(status == NotReachable)
    {
        
        [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
        
    }
    else{
        
    spinner.hidden = NO;
    [spinner beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital"};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //http://192.168.1.2:8888/joey/faqs/api-get-faqs

    [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"faqs/api-get-faqs"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        
        NSDictionary * response =  (NSDictionary *)responseObject;
        
        NSLog(@"FAQ :%@",response);

        
        _faqDetailArray = [response objectForKey:@"Faqs"];

         self.sksTableView.SKSTableViewDelegate = self;
        
        [self.sksTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];
    
    
    }


}

#pragma mark - UITableViewDataSource   SKS


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        
    return _faqDetailArray.count;
    //return 2;
    //return 2;
}

- (NSInteger)tableView:(SKSTableView *)tableView numberOfSubRowsAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 1;
  
}

- (BOOL)tableView:(SKSTableView *)tableView shouldExpandSubRowsOfCellAtIndexPath:(NSIndexPath *)indexPath
{

    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        
        static NSString *CellIdentifier = @"SKSTableViewCell";
        
        SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (!cell)
            cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    
        singleFaq = [_faqDetailArray objectAtIndex:indexPath.row];
    
//        cell.numberLabel.text = [NSString stringWithFormat:@"%d",indexPath.row +1];
//        cell.numberLabel.layer.masksToBounds=YES;
//        cell.numberLabel.layer.cornerRadius = cell.numberLabel.frame.size.width/2;
//        cell.numberLabel.font = [UIFont fontWithName:@"Museo-500" size:17];
    
       [cell.numberButton setTitle:[NSString stringWithFormat:@"%d",indexPath.row +1]forState:UIControlStateNormal];
        cell.numberButton.layer.cornerRadius = cell.numberButton.frame.size.width/2;
    
        cell.questionLabel.text = [singleFaq objectForKey:@"question"];
        cell.questionLabel.font = [UIFont fontWithName:@"Museo-500" size:18];
    
        NSLog(@"question :  %@",[singleFaq objectForKey:@"question"]);
    
//         UIView *bgColorView = [[UIView alloc] init];
//         bgColorView.backgroundColor = [UIColor hx_colorWithHexString:@"F7F9ED" alpha:1];
//         [cell setSelectedBackgroundView:bgColorView];
    
        cell.expandable = YES;
    
    
    
        return cell;
  
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForSubRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
//    static NSString *CellIdentifier = @"expandableSubViewTableViewCell";
//    
//    ExpandableSubViewTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (!cell)
//        cell = [[ExpandableSubViewTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    static NSString *CellIdentifier = @"subRowCell";
    
    SubRowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell)
        cell = [[SubRowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
   
    
    
//    static NSString *CellIdentifier = @"SKSTableViewCell";
//    
//    SKSTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    
//    if (!cell)
//        cell = [[SKSTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    
//    
    singleFaq = [_faqDetailArray objectAtIndex:indexPath.row];
    
    
//    CGSize maximumLabelSize = CGSizeMake(120, FLT_MAX);
//    
//    NSAttributedString *attributedText =
//    [[NSAttributedString alloc] initWithString:[singleFaq objectForKey:@"answer"] attributes:@ {
//    NSFontAttributeName:[UIFont fontWithName:@"Museo-300" size:16]
//    }];
//    CGRect expectedLabelSize = [attributedText boundingRectWithSize:maximumLabelSize
//                                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
//                                                            context:nil];
//    
//    
//   CGRect newFrameforLabel=CGRectMake(5, 5, expectedLabelSize.size.width, expectedLabelSize.size.height);
    
    cell.answerLabel.text = [singleFaq objectForKey:@"answer"];
    cell.answerLabel.font = [UIFont fontWithName:@"Museo-300" size:16];
    cell.answerLabel.numberOfLines = 0;
    cell.answerLabel.textColor = [UIColor hx_colorWithHexString:@"ACACAC"];
    cell.answerLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    if (indexPath.row == 2) {

        cell.userInteractionEnabled=YES;

    }else{

        cell.userInteractionEnabled=NO;
        
    }
    
    PatternTapResponder urlTapAction = ^(NSString *tappedString){
        NSLog(@"You have tapped URL: %@",tappedString);
        
        [self openWebSite:tappedString];
    };
    
    [cell.answerLabel enableURLDetectionWithAttributes:@{NSForegroundColorAttributeName:[UIColor blueColor],
                                                              RLHighlightedBackgroundColorAttributeName:[UIColor clearColor],NSBackgroundColorAttributeName:[UIColor clearColor],RLHighlightedBackgroundCornerRadius:@5,
                                                              RLTapResponderAttributeName:urlTapAction}];
    
//    cell.numberButton.hidden = YES;
//    
//    cell.questionLabel.text = [singleFaq objectForKey:@"answer"];
//    cell.questionLabel.font = [UIFont fontWithName:@"Museo-500" size:16];
//    cell.questionLabel.numberOfLines = 0;
//    cell.questionLabel.textColor = [UIColor hx_colorWithHexString:@"ACACAC"];
//    cell.questionLabel.lineBreakMode = NSLineBreakByWordWrapping;
    //cell.userInteractionEnabled=NO;
    
//    cell.subViewLabel.frame=newFrameforLabel;
//    cell.subViewLabel.text = [singleFaq objectForKey:@"answer"];
//    cell.subViewLabel.font = [UIFont fontWithName:@"Museo-300" size:16];
////    cell.textLabel.textColor = [UIColor hx_colorWithHexString:@"ACACAC"];
//    cell.subViewLabel.numberOfLines = 0;
//    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
   // cell.userInteractionEnabled=NO;
    
    
   // NSLog(@"expectedLabelSize %lf",cell.subViewLabel.frame.size.height);
   // NSLog(@"cell.contentView %lf",cell.contentView.frame.size.height);
    
   // [cell.contentView addSubview:detailsLabel];
    //[self.view layoutIfNeeded];
    return cell;
}


- (void)tableView:(SKSTableView *)tableView didSelectSubRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

   
    NSLog(@"Section: %ld, Row:%ld, Subrow:%ld", (long)indexPath.section, (long)indexPath.row, (long)indexPath.subRow);
}

#pragma mark - Actions

- (void)collapseSubrows{
    
    [self.sksTableView collapseCurrentlyExpandedIndexPaths];
}
-(IBAction)openWebSite:(NSString*)url {
    
    NSLog(@"tap url");
    
   // [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/thejoeyapp/"]];

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];

}

- (IBAction)contectButton:(id)sender {
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"contactUs"];
        
        ContactUsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Please login or sign up to use this feature."
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"Sign up/Login", nil];
        alert.tag = 508;
        
        [alert show];
    }
}


- (IBAction)drawerToggle:(id)sender {
    
    [self.rootNav drawerToggle];
    
}

#pragma mark - CCKFNavDrawerDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection faq = %li", (long)selectionIndex);
    
    if (selectionIndex==0)
    {
        MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (selectionIndex==1)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
            
            FavoritesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
//            vc.favoriteListArray = self.favoriteListArray;
//            vc.distance = _distanceArray;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
            alert.tag = 107;
            
            [alert show];
        }
        
    } else if (selectionIndex==2)
    {
           [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"addFeedingRoomMessage"];
            MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            [self.navigationController pushViewController:vc animated:YES];
       
        
    }else if (selectionIndex==3)
    {
        LeaderBoardViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaderBoardViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (selectionIndex==4)
    {
        MessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if (selectionIndex==5)
    {
        
        [self makerequest];
        
        
    }else if (selectionIndex==6)
    {
        AboutJoeyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutJoeyViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
        
    }else if (selectionIndex==7)
    {
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
            
            ContactUsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactUsViewController"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
            alert.tag = 503;
            
            [alert show];
        }
        
    }else if (selectionIndex==8)
    {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
            
            SettingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            
//            vc.favoriteListArray = self.favoriteListArray;
//            vc.distanceArray = _distanceArray;
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
            alert.tag = 108;
            
            [alert show];
        }
        
        
        
    }

}
@end
