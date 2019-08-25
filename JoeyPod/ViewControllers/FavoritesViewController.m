//
//  FavoritesViewController.m
//  JoeyPod
//
//  Created by Sujan on 3/29/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "FavoritesViewController.h"
#import "FacilityListTableViewCell.h"
#import "SettingViewController.h"
#import "MapViewController.h"
#import "MessagesViewController.h"
#import "FAQsViewController.h"
#import "AboutJoeyViewController.h"
#import "ContactUsViewController.h"
#import "LeaderBoardViewController.h"
#import "FacilityDetailsViewController.h"
#import "Urls.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"

@interface FavoritesViewController (){

      NSArray *joeyPodName;
    
      NSDictionary *favorite;
 
     JTMaterialSpinner * spinner;
}

@property (strong, nonatomic) CCKFNavDrawer *rootNav;

@end

@implementation FavoritesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    //[self.favoriteTableView reloadData];
    
    self.backBtn.hidden = YES;
    self.drawerBtn.hidden = NO;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"favorite"] isEqualToString:@"1"]) {
        
        self.backBtn.hidden = NO;
        self.drawerBtn.hidden = YES;
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"favorite"];
    }else
    {
        self.rootNav = (CCKFNavDrawer *)self.navigationController;
        [self.rootNav setCCKFNavDrawerDelegate:self];
        
        
    }
   
    self.favoriteTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.favoriteTableView.frame.size.width, 1)];
    
    self.favoriteTableView.estimatedRowHeight = 125.0;
    self.favoriteTableView.rowHeight = UITableViewAutomaticDimension;
  
}

-(void)viewDidAppear:(BOOL)animated{
    
    NSLog(@"...............ffffff%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteroom"]);
    
    self.favoriteListArray = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteroom"]];
    
    NSLog(@"...............ffffff          %@",self.favoriteListArray);
    
    if (self.favoriteListArray.count == 0) {
        
        self.favoriteTableView.hidden =YES;
    }else{
        
        self.favoriteTableView.hidden =NO;
        
    }
    [self.favoriteTableView reloadData];
    
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
    
    return self.favoriteListArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FacilityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"facilityCell"];
    
    
    
    NSDictionary *shortDetails = [self.favoriteListArray objectAtIndex:indexPath.row];
    
    cell.joeyPodName.text = [shortDetails objectForKey:@"title"];
    cell.joeyPodcheckIn.text =[NSString stringWithFormat:@"%@",[shortDetails objectForKey:@"checkin_count"]];
    cell.addressLabel.text = [shortDetails objectForKey:@"direction"];
    cell.distance.text =[NSString stringWithFormat:@"%.02f meters",[[shortDetails objectForKey:@"distance"] floatValue]] ;
    
    //[NSString stringWithFormat:@"%@ meters"
    
    NSLog(@"Title         %@",[shortDetails objectForKey:@"title"]);
    NSLog(@"direction      %@",[shortDetails objectForKey:@"direction"]);
    
    
    cell.rateview.notSelectedImage = [UIImage imageNamed:@"star_notselected.png"];
    cell.rateview.halfSelectedImage = [UIImage imageNamed:@"star_half_selected.png"];
    cell.rateview.fullSelectedImage = [UIImage imageNamed:@"star_selected.png"];
    cell.rateview.rating =[[shortDetails objectForKey:@"ratings"]floatValue];
    cell.rateview.editable = NO;
    cell.rateview.maxRating = 5;
    cell.rateview.delegate = self;
    
    cell.favoriteBtn.tag=indexPath.row;
    
    [cell.favoriteBtn addTarget:self action:@selector(favoriteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSDictionary *shortDetails = [self.favoriteListArray objectAtIndex:indexPath.row];
    
    NSLog(@"selected details %@",shortDetails);
    
    self.roomId = [shortDetails objectForKey:@"id"];
    
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
    
    FacilityDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FacilityDetailsViewController"];
    controller.roomID = self.roomId;
    controller.rating = [[shortDetails objectForKey:@"ratings"]floatValue];
    
    NSLog(@"room id ..........%@",controller.roomID);
    NSLog(@"rating ..........%f",controller.rating);
    
    [self.navigationController pushViewController:controller animated:YES];
    
    }
}



- (void)favoriteButtonClicked:(UIButton*)sender
{
    
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
        
    NSLog(@"favoriteButton clicked.");
    sender.enabled=NO;
        
    spinner.hidden= NO;
    [spinner beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital",
                             @"user_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                             @"room_id": [[self.favoriteListArray objectAtIndex:sender.tag] objectForKey:@"id"]};
    
    
    NSLog(@"params for favorite button:%@",params );
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
    [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"favorites/api-swap-favorite"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        sender.enabled=YES;
        spinner.hidden= YES;
        [spinner endRefreshing];
        
        
        favorite  =  (NSDictionary *)responseObject;
        
        //
        NSLog(@"Favorite responce:%@",responseObject);
        
        [self.favoriteListArray removeObjectAtIndex:sender.tag];
        

        [[NSUserDefaults standardUserDefaults]setObject:self.favoriteListArray forKey:@"favoriteroom"];
        
        if (self.favoriteListArray.count==0) {
            
            self.favoriteTableView.hidden = YES;
            
        }
        
        [self.favoriteTableView reloadData];
        
        
        
        
        
        //[self.actionTableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        sender.enabled=YES;
        
        spinner.hidden= YES;
        [spinner endRefreshing];
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];
    
    }
//    sender.selected = !sender.selected;
    
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

- (IBAction)drawerToggle:(id)sender {
    
    
    [self.rootNav drawerToggle];
    
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - CCKFNavDrawerDelegate

-(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
{
    NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
    
    if (selectionIndex==0)
    {
        
        MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (selectionIndex==1)
    {
       
        [self.favoriteTableView reloadData];
        
        
    }else if (selectionIndex==2)
    {
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"addFeedingRoomMessage"];
            MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
            [self.navigationController pushViewController:vc animated:YES];
            
        
        
    }else if (selectionIndex==3)
    {
        LeaderBoardViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaderBoardViewController"];
        
        vc.favoriteListArray = self.favoriteListArray;
        vc.distanceArray = self.distance;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
    }else if (selectionIndex==4)
    {
        MessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"];
        
        vc.favoriteListArray = self.favoriteListArray;
        vc.distanceArray = self.distance;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if (selectionIndex==5)
    {
        FAQsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FAQsViewController"];
        
        vc.favoriteListArray = self.favoriteListArray;
        vc.distanceArray = self.distance;
        
        [self.navigationController pushViewController:vc animated:YES];
        
        
        
    }else if (selectionIndex==6)
    {
        AboutJoeyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutJoeyViewController"];
        
        vc.favoriteListArray = self.favoriteListArray;
        vc.distanceArray = self.distance;
        
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
            alert.tag = 504;
            
            [alert show];
        }
        
    }else if (selectionIndex==8)
    {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
            
            SettingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
            
//            vc.favoriteListArray = self.favoriteListArray;
//            vc.distanceArray = self.distance;
//            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"addFeedingRoomMessage"];
            
            [self.navigationController pushViewController:vc animated:YES];
            
        }else{
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        

        
    }
}

@end
