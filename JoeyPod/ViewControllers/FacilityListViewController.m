//
//  FacilityListViewController.m
//  JoeyPod
//
//  Created by Sujan on 2/14/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "FacilityListViewController.h"
#import "FacilityListTableViewCell.h"
#import "FacilityDetailsViewController.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"

@interface FacilityListViewController (){

    
    NSString * joeyName;
    
    NSDictionary *favorite;
    
    NSString* favoriteButtonstate;
    
    NSString* isFavorite;
    
    NSString* roomName;
    
    JTMaterialSpinner* spinner;
    
}



@end

@implementation FacilityListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    
    self.facilityTableView.delegate =self;
    self.facilityTableView.dataSource =self;
    
    self.facilityTableView.estimatedRowHeight = 129.0;
    self.facilityTableView.rowHeight = UITableViewAutomaticDimension;
    
    self.roonCountLabel.text = [NSString stringWithFormat:@"%lu Feeding Rooms Found",(unsigned long)self.feedingRoomList.count];
    
     self.facilityTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.facilityTableView.frame.size.width, 1)];
    
 
  //  NSLog(@"favorite......?????...:%@",self.favoriteListArray);
     NSLog(@"room list......?????...:%@",self.feedingRoomList);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{

    int roomid;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"roomidInFavorite"]) {
        
        roomid = [[[NSUserDefaults standardUserDefaults]objectForKey:@"roomidInFavorite"]integerValue];
        
    }
   
    
      NSLog(@"????????????????roomid  %d",roomid);
    
    for (int i = 0; i < self.feedingRoomList.count; i++) {
        
        NSMutableDictionary *shortDetails = [self.feedingRoomList objectAtIndex:i];
        
        self.roomId = [shortDetails objectForKey:@"id"];
        
        if ([self.roomId integerValue] == roomid) {
            
            isFavorite = [[NSUserDefaults standardUserDefaults]objectForKey:@"isFavorite"];
            
            NSLog(@"????????????????%@",isFavorite);
            
            [shortDetails setObject:isFavorite forKey:@"favorites"];
            [self.feedingRoomList replaceObjectAtIndex:i withObject:shortDetails];
        }

    }
    
    [self.facilityTableView reloadData];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey: @"roomidInFavorite"];
   
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.feedingRoomList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FacilityListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"facilityCell"];
    
    [cell.favoriteBtn addTarget:self action:@selector(favoriteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSMutableDictionary *shortDetails = [self.feedingRoomList objectAtIndex:indexPath.row];
    
   // NSLog(@"%@",shortDetails);
    
    self.roomId = [shortDetails objectForKey:@"id"];
    
    NSLog(@"self.roomId   %@",self.roomId);
   
    roomName = [shortDetails objectForKey:@"title"];
    
    cell.joeyPodName.text = roomName;
    cell.joeyPodcheckIn.text =[NSString stringWithFormat:@"%@",[shortDetails objectForKey:@"checkin_count"]];
    joeyName = cell.joeyPodName.text;
    
    cell.addressLabel.text = [shortDetails objectForKey:@"direction"];
    cell.distance.text = [NSString stringWithFormat:@"%.01f kms",([[shortDetails objectForKey:@"distance"] floatValue]/1000)];
    
    cell.rateview.notSelectedImage = [UIImage imageNamed:@"star_notselected.png"];
    cell.rateview.halfSelectedImage = [UIImage imageNamed:@"star_half_selected.png"];
    cell.rateview.fullSelectedImage = [UIImage imageNamed:@"star_selected.png"];
    cell.rateview.rating =[[shortDetails objectForKey:@"ratings"]floatValue];
    cell.rateview.editable = NO;
    cell.rateview.maxRating = 5;
    cell.rateview.delegate = self;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
        
        cell.favoriteBtn.enabled=YES;
        cell.favoriteBtn.tag = indexPath.row;
        
        NSLog(@"FAVORITE BUTTON Tag :%d",(int)cell.favoriteBtn.tag);
        
       favoriteButtonstate = [shortDetails objectForKey:@"favorites"];
       
        NSLog(@"FAVORITE BUTTON STATE :%@",favoriteButtonstate);
        
        if ([favoriteButtonstate integerValue] ==1) {
            
            [cell.favoriteBtn setSelected:YES];
            
        }else{
            
           [cell.favoriteBtn setSelected:NO];
        }
       
    }
    else
        cell.favoriteBtn.enabled=NO;
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
  
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    NSMutableDictionary *shortDetails = [self.feedingRoomList objectAtIndex:indexPath.row];
    
    NSLog(@"selected details %@",shortDetails);
    
    NSMutableDictionary *singleRoomshortDetails = [self.feedingRoomList objectAtIndex:indexPath.row];
    
    // NSLog(@"%@",shortDetails);
    
    self.roomId = [singleRoomshortDetails objectForKey:@"id"];
    
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
    //controller.distanceFromLocation = [shortDetails objectForKey:@"distance"];
    controller.roomListArray = self.feedingRoomList;
    controller.distanceArray = self.distance;
    //controller.isFavorite = [shortDetails objectForKey:@"favorites"];
    controller.joeyName = roomName;
    
    NSLog(@"room........///.........:%@",controller.roomListArray);
//    NSLog(@"distance.........:%@",controller.distanceArray);
    
   [self.navigationController pushViewController:controller animated:YES];
    
    }
   // NSLog(@"rat.........:%f   %f",controller.rating,self.rating);

}


- (void)favoriteBtnClicked:(UIButton*)sender
{

    NSLog(@"favoriteButton clicked.");
    

    
    sender.enabled=NO;
   
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
        NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"user_id": [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                                 @"room_id": [[self.feedingRoomList objectAtIndex:sender.tag] objectForKey:@"id"]};
    
    
        NSLog(@"params for favorite button:%@",params );
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"favorites/api-swap-favorite"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            sender.enabled=YES;
    
             NSMutableArray *favoriteRoom = [[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteroom"]];
            
            NSMutableDictionary *shortDetails = [self.feedingRoomList objectAtIndex:sender.tag];
            
            if (sender.selected) {
               
                
                for (int i =0; i<favoriteRoom.count; i++) {
                    
                    NSMutableDictionary *singleRoom = [favoriteRoom objectAtIndex:i];
                    
                    if ([singleRoom objectForKey:@"id"] ==[[self.feedingRoomList objectAtIndex:sender.tag] objectForKey:@"id"]) {
                        
                        [favoriteRoom removeObjectAtIndex:i];
                        
                         [shortDetails setObject:[NSNumber numberWithInt:0] forKey:@"favorites"];
                        
                        [[NSUserDefaults standardUserDefaults]setObject:favoriteRoom forKey:@"favoriteroom"];

                        
                        break;
                    }
                    
                }
                
                
                
            }else{
                
                
                [favoriteRoom addObject:[self.feedingRoomList objectAtIndex:sender.tag]];
                
                [shortDetails setObject:[NSNumber numberWithInt:1] forKey:@"favorites"];
                
                [[NSUserDefaults standardUserDefaults]setObject:favoriteRoom forKey:@"favoriteroom"];
            
            }
            
            [self.feedingRoomList replaceObjectAtIndex:sender.tag withObject:shortDetails];
            
           
            
            
             sender.selected = !sender.selected;
            
            NSLog(@"Favorite responce:%@",responseObject);
    
            //[self.actionTableView reloadData];
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            sender.enabled=YES;
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Sorry, we're facing issues with the network. Please try again"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }];
    
    }
    
}

//[[NSUserDefaults standardUserDefaults]setObject:self.favoritesArray forKey:@"favoriteroom"];

#pragma mark RWTRateViewDelegate

- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating {
    
    
}



#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    

   
}

- (IBAction)addNewJoey:(UIButton *)sender {
    
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
    
     [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"addFeedingRoomMessage"];
     //[[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"InfoAddButton"];
    
      [self.navigationController popViewControllerAnimated:YES];
        
    }
}

- (IBAction)crossbutton:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}







@end
