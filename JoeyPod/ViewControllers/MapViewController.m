//
//  MapViewController.m
//  JoeyPod
//
//  Created by Sujan on 2/22/16.
//  Copyright © 2016 Sujan. All rights reserved.
//CROSS BLACK

#import "MapViewController.h"
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;
#import "CLPlacemark+HNKAdditions.h"
#import "SettingViewController.h"
#import "FavoritesViewController.h"
#import "ReportProblemViewController.h"
#import "ContactUsViewController.h"
#import "AboutJoeyViewController.h"
#import "FAQsViewController.h"
#import "MessagesViewController.h"
#import "LeaderBoardViewController.h"
#import "FacilityListViewController.h"
#import "HexColors.h"
#import <AFNetworking/AFNetworking.h>
#import "Reachability.h"
#import "Urls.h"
#import "FacilityDetailsViewController.h"
#import "HostPagerViewController.h"
#import "DrawerView.h"
#import "JTMaterialSpinner.h"

static NSString *const kHNKDemoSearchResultsCellIdentifier = @"Cell";


@interface MapViewController (){

        CLLocationManager *locationManager;
        CLLocationCoordinate2D longpressedCoordinate;
        GMSMarker *previousMarker;
    
        NSMutableArray *nearRoomLocations;
        NSMutableArray* distancesArray;
       // NSMutableArray* favoriteRoomdistancesArray;
        CLLocation *roomLocation;
        CLLocation *favoriteRoomLocation;

        int numberOfPlace;
        double distanceInmeters;
        double distanceForFavoriteRoom;
        int total;
    
        UITextView *roomAddress;
        UILabel *hintLabel;
        UIButton *addButton;
        BOOL userMarkerTapped;
        CGFloat actualYPointOfDisplayView;
        NSString* isApproved;
        NSString* isTemporary;
        GMSMarker *longpressedmarker;
        GMSMarker *searchMarker;
        GMSMarker *approvedMarker;
    
        NSMutableArray* locationArray ;
    
        JTMaterialSpinner * spinner;
    
        NSString* googleMarkerLat;
        NSString* googleMarkerLong;
    
}
@property(nonatomic,strong) GMSMarker *userMarker;
@property (strong, nonatomic) CCKFNavDrawer *rootNav;
@property (strong, nonatomic) DrawerView *drawerView;



// this will hold the custom info window we're displaying
@property (strong, nonatomic) UIView *displayedInfoWindow;

/* these three will be used to guess the state of the map animation since there's no
 delegate method to track when the camera update ends */
@property BOOL markerTapped;
@property BOOL cameraMoving;
@property BOOL idleAfterMovement;

/* Since I'm creating the info window based on the marker's position in the
 mapView:idleAtCameraPosition: method, I need a way for that method to know
 which marker was most recently tapped, so I'm using this to store that most
 recently tapped marker */
@property (strong, nonatomic) GMSMarker *currentlyTappedMarker;




@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    isTemporary = @"0";
    
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(setMap) name:@"reloadMapWhenActive" object:nil];
    [[NSNotificationCenter defaultCenter ]addObserver:self selector:@selector(addRoom) name:@"addRoom" object:nil];
    
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSLog(@"USERID.........:%@",userid);
    
    //for drawer
    
    self.rootNav = (CCKFNavDrawer *)self.navigationController;
    [self.rootNav setCCKFNavDrawerDelegate:self];
    
    NSLog(@"root nav %@",self.rootNav);

    [self.rootNav setIndexToRow:0];

    
    //searchBar
    
    self.searchBar.delegate=self;
    self.searchBar.placeholder = @"Search For a Location";
    [self.searchBar setTintColor:[UIColor hx_colorWithHexString:@"C1C1C1"]];
    [self.searchBar setBackgroundImage:[[UIImage alloc]init]];
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[UIFont fontWithName:@"Museo-500" size:14]];
    
    
    self.netWarningView.hidden = YES;

    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    
    
    if(status == NotReachable)
      {
        self.netWarningView.hidden = NO;
        self.showListinfoView.hidden = YES;
        self.howToAddInfoView.hidden = YES;
        self.longPressInfoView.hidden = YES;
        self.howToAddCompleteInfoView.hidden = YES;
        
      }else{
     
        
        [self setMap];
    
      }
    
    //addRoomHintView1
    
    self.howToAddInfoView.hidden =YES;
    
    
    //addrommHontView2
    
    self.howToAddCompleteInfoView.hidden = YES;
    
    
    //showListinfoView
    
    
    //self.showListinfoView.hidden = YES;
    
    self.showListinfoLabel.font = [UIFont fontWithName:@"Museo-300" size:15];
    
    self.showListButton.font = [UIFont fontWithName:@"Museo-500" size:15];
    self.showListButton.layer.borderWidth = 1.1f;
    self.showListButton.layer.borderColor= [[UIColor whiteColor]CGColor];
    
    
    //longpressInfoView
    
    self.longPressInfoView.hidden = YES;
    self.nextBtn.layer.borderWidth = 1.1f;
    self.nextBtn.layer.borderColor= [[UIColor whiteColor]CGColor];
    
    self.addRoomButton.layer.borderWidth = 1.1f;
    self.addRoomButton.layer.borderColor= [[UIColor whiteColor]CGColor];
    
    self.noFeedingRoomView.hidden = YES;
    //self.addRoomRequestInfoView.hidden =YES;
    
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.layer.zPosition = 101;
    self.searchQuery = [HNKGooglePlacesAutocompleteQuery sharedQuery];
    
    self.searchTableView.hidden = YES;
  
    self.markerTapped = NO;
    self.cameraMoving = NO;
    self.idleAfterMovement = NO;
    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"addFeedingRoomMessage"] isEqualToString:@"0"]) {
//        
//        self.displayedInfoWindow.hidden = YES;
//    }
    
    [_rootNav setLoginButtonStat];


}


-(void)dealloc{


    [[NSNotificationCenter defaultCenter] removeObserver:self];

}

-(void)setMap{

    
    if (!self.displayedInfoWindow.hidden) {
        
        [self.displayedInfoWindow removeFromSuperview];
        self.displayedInfoWindow = nil;
    }
    
    //Map
    
    self.mapView.delegate = self;

    
    if (locationManager==nil)
    {
        locationManager = [[CLLocationManager alloc] init];
    }
    
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.headingFilter = 1;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    
    if([CLLocationManager locationServicesEnabled]){
        
        [locationManager startUpdatingLocation];
        
        NSLog(@"Enable");
    }

    
    [locationManager requestWhenInUseAuthorization];
    
    
    NSLog(@"current Device %lf",[[[UIDevice currentDevice] systemName] floatValue]);
    
    if ([[[UIDevice currentDevice] systemName] floatValue] >= 8.0)
    {
        [locationManager requestWhenInUseAuthorization];
        // NSLog(@"Requested");
    }
    else
    {
        [locationManager requestWhenInUseAuthorization];
        [locationManager startUpdatingLocation];
    }
    
    
    
    
 //   [locationManager startUpdatingLocation];
    
    currentLocation = locationManager.location.coordinate;
    
    NSLog(@"Current Location = %f, %f",currentLocation.latitude,currentLocation.longitude);
    
        self.userMarker.map = nil;

        self.userMarker = [[GMSMarker alloc] init];
        
        self.userMarker.position = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
        
        self.userMarker.icon = [UIImage imageNamed:@"user_location.png"];
        
        self.userMarker.map = self.mapView;
    
        
        
        [self.mapView setSelectedMarker:self.userMarker];
  
 
    //Api Call
    
    
    [self makeRequest];
    
    
}

//Network connection
//
//Reachability *reachability = [Reachability reachabilityForInternetConnection];
//[reachability startNotifier];
//
//NetworkStatus status = [reachability currentReachabilityStatus];
//
//self.netWarningView.hidden = YES;
//
//if(status == NotReachable)



-(void)viewDidAppear:(BOOL)animated{
    
     NSLog(@"selected index in map%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
    
    NSString * userid = [[NSUserDefaults standardUserDefaults] objectForKey:@"userId"];
    NSLog(@"USERID......... in Appear:%@",userid);
    NSLog(@"loginFromAlart value  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"loginFromAlart"]);
    
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"addFeedingRoomMessage"] isEqualToString:@"1"]) {
        
        [self.rootNav setIndexToRow:2];
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"selectedIndex"];
        
        if (status == NotReachable) {
            
             self.netWarningView.hidden = NO;
            
        }else{
            
            self.userMarker.map = nil;
            
            if(previousMarker)
            {
                previousMarker.map = nil;
            }
            
            longpressedmarker = [[GMSMarker alloc] init];
            [longpressedmarker setDraggable: YES];
            longpressedmarker.position = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
            
            longpressedCoordinate = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
            
            NSLog(@"longpressed coordinate:%f   ,%f",longpressedCoordinate.latitude,longpressedCoordinate.longitude);
            // marker.title = placemark.name;
            //longpressedmarker.icon = [UIImage imageNamed:@"temp_joye.png"];
            longpressedmarker.map = self.mapView;
            
            previousMarker = longpressedmarker;
            
            
           
            self.longPressInfoView.hidden=NO;
            self.noFeedingRoomView.hidden = YES;
            self.showListinfoView.hidden=YES;
            self.netWarningView.hidden = YES;
            self.howToAddInfoView.hidden = YES;
            self.howToAddCompleteInfoView.hidden = YES;
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.latitude longitude:currentLocation.longitude zoom:13.5];
            
            [self.mapView animateToCameraPosition:camera];
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"addFeedingRoomMessage"];
            
        }
        
    }else{
       
            [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"searchLocation"];
            self.longPressInfoView.hidden=YES;
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loginFromAlart"] isEqualToString:@"1"]) {
            
            
            NSLog(@"index  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"loginFromAlart"];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue] == 2) {
                
                NSLog(@"?????????????");
                
                self.longPressInfoView.hidden=NO;
            }
            
        }

        
    }
    
 
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status{
    
    
    [locationManager startUpdatingLocation];
    
    if([CLLocationManager locationServicesEnabled]){
        
         self.mapView.myLocationEnabled = YES;
        
        [locationManager startUpdatingLocation];
        
        
       // NSLog(@"Enable");
    }
   
    self.mapView.settings.myLocationButton = YES;

    
    
    
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations{
    
    // NSLog(@"delagate mathod of CLlocation");
    
   //  self.netWarningView.hidden = YES;
    
    CLLocation *currentPostion=locations.lastObject;
    
    //CLLocation *currentPostion=locations.lastObject;
    currentLocation.latitude=currentPostion.coordinate.latitude;
    currentLocation.longitude=currentPostion.coordinate.longitude;
    
    NSLog(@"got the location");
   
    NSLog(@"current location in update location %f  %f",currentLocation.latitude,currentLocation.longitude);
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]integerValue]== 2){
    
         NSLog(@"index is 2 ,so camera is not updateing");
        
    }else{
    
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.latitude longitude:currentLocation.longitude zoom:13.5];
        
        [self.mapView animateToCameraPosition:camera];
        
        self.howToAddInfoView.hidden =YES;
        
        [manager stopUpdatingLocation];
    
    }
    


    
}


- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    
    
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    
      if(!self.longPressInfoView.hidden || [[[NSUserDefaults standardUserDefaults] objectForKey:@"InfoAddButton"] isEqualToString:@"1"] ){
     
             if(previousMarker)
             {
                 previousMarker.map = nil;
             }
     
             longpressedmarker = [[GMSMarker alloc] init];
             [longpressedmarker setDraggable: YES];
             longpressedmarker.position = coordinate;
     
             longpressedCoordinate = coordinate;
     
             NSLog(@"longpressed coordinate:%f   ,%f",longpressedCoordinate.latitude,longpressedCoordinate.longitude);
             // marker.title = placemark.name;
            //longpressedmarker.icon = [UIImage imageNamed:@"temp_joye.png"];
            longpressedmarker.map = self.mapView;
     
             previousMarker = longpressedmarker;
             
     
            }
    
}

- (UIView *)mapView:(GMSMapView *)mapView markerInfoWindow:(GMSMarker *)marker
{
    if (marker == longpressedmarker) {
        
        return nil;
        
    }else{
    
        UIView *view = [[UIView alloc] init];
        view.frame = CGRectMake(0, 0, 120, 25);
        view.layer.cornerRadius = 5.0;
        view.backgroundColor = [UIColor hx_colorWithHexString:@"000000" alpha:0.6];
        
        UILabel *title=[[UILabel alloc]init];
        title.frame = CGRectMake(5, 2, 110, 20);
        title.numberOfLines = 0;
        title.font= [UIFont fontWithName:@"Museo-300" size:13];
        title.textAlignment =UITextAlignmentCenter;
        title.textColor = [UIColor whiteColor];
        
        if (marker == self.userMarker) {
            title.text = @"You are here";
        }else{
            title.text = self.currentlyTappedMarker.title;
        }

        
        CGSize maximumLabelSize = CGSizeMake(120, FLT_MAX);
        
        NSAttributedString *attributedText =
        [[NSAttributedString alloc] initWithString:title.text attributes:@ {
        NSFontAttributeName: title.font
        }];
        CGRect expectedLabelSize = [attributedText boundingRectWithSize:maximumLabelSize
                                                                options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                                context:nil];
        
        CGRect newFrameforView=CGRectMake(0, 0, expectedLabelSize.size.width+10, expectedLabelSize.size.height+10);
        CGRect newFrameforLabel=CGRectMake(5, 5, expectedLabelSize.size.width, expectedLabelSize.size.height);
        
        
        view.frame=newFrameforView;
        title.frame=newFrameforLabel;
    
        [view addSubview:title];
        
        return view;
    }
   
}

// Since we want to display our custom info window when a marker is tapped, use this delegate method
- (BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    
    // A marker has been tapped, so set that state flag
    self.markerTapped = YES;
    
    // If a marker has previously been tapped and stored in currentlyTappedMarker, then nil it out
    if(self.currentlyTappedMarker) {
        self.currentlyTappedMarker = nil;
    }
    
    // make this marker our currently tapped marker
    self.currentlyTappedMarker = marker;
    
  //  NSLog(@"current taped marker:%@",marker.userData);
    
    [self.mapView setSelectedMarker:marker];
    
    
   
    
    
    if (marker == self.userMarker) {
        
//         GMSCameraUpdate *cameraUpdate = [GMSCameraUpdate setTarget:marker.position];
//        [self.mapView animateWithCameraUpdate:cameraUpdate];
        
 //       userMarkerTapped = YES;
        
//        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
//            
//           [self addRoomView];
        
//        }
        
        
   
    }else if(marker.userData == nil) {
    
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Please reload Map"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    
 
    }else{
        
        //Network connection
        
        Reachability *reachability = [Reachability reachabilityForInternetConnection];
        [reachability startNotifier];
        
        NetworkStatus status = [reachability currentReachabilityStatus];
        
        //NSLog(@"status %ld",(long)status);
        
        if(status == NotReachable)
        {
            
            [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection." duration:2.0f];
            
        }
        else{
    
        FacilityDetailsViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FacilityDetailsViewController"];
        controller.roomID = marker.userData;
        [self.navigationController pushViewController:controller animated:YES];
    
        }
    }
    
    // if our custom info window is already being displayed, remove it and nil the object out
//    if([self.displayedInfoWindow isDescendantOfView:self.view]) {
//        [self.displayedInfoWindow removeFromSuperview];
//        self.displayedInfoWindow = nil;
//    }
    
    /* animate the camera to center on the currently tapped marker, which causes
     mapView:didChangeCameraPosition: to be called */

    
    return YES;
}



-(void)mapView:(GMSMapView *)mapView didEndDraggingMarker:(GMSMarker *)marker{
    
        NSLog(@"marker dragged to location: %f,%f", marker.position.latitude, marker.position.longitude);
    
       longpressedCoordinate.latitude = marker.position.latitude;
       longpressedCoordinate.longitude = marker.position.longitude;
    
       NSLog(@"marker dragged to location: %f,%f", longpressedCoordinate.latitude, longpressedCoordinate.longitude);
    
}

- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    /* if we got here after we've previously been idle and displayed our custom info window,
     then remove that custom info window and nil out the object */
//    if(self.idleAfterMovement ) {
//        if([self.displayedInfoWindow isDescendantOfView:self.view]) {
//            [self.displayedInfoWindow removeFromSuperview];
//            self.displayedInfoWindow = nil;
//        }
//    }
    
    // if we got here after a marker was tapped, then set the cameraMoving state flag to YES
    if(self.markerTapped) {
        self.cameraMoving = YES;
        
    }
    
 
    
}

// This method gets called whenever the map was moving but has now stopped
- (void)mapView:(GMSMapView *)mapView idleAtCameraPosition:(GMSCameraPosition *)position
{
    
    /* if we got here and a marker was tapped and our animate method was called, then it means we're ready
     to show our custom info window */
    if(self.markerTapped && self.cameraMoving) {
        
        
        
        // reset our state first
        self.cameraMoving = NO;
        self.markerTapped = NO;
        self.idleAfterMovement = YES;
        
        if (self.currentlyTappedMarker == self.userMarker) {
            
      

        }
        
    }
}

-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    if (alertView.tag == 101){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
        
            NSLog(@"index  %@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
        
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
        
        
        }
        
        
    }else if (alertView.tag == 102){
        
        if (buttonIndex == [alertView firstOtherButtonIndex]) {
            
            NSLog(@"login button clicked");
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"login"];
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"loginFromAlart"];
            
            HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
            
            [self.navigationController pushViewController:hostPager animated:YES];
            
        }else if (buttonIndex == [ alertView cancelButtonIndex]){
            
            
            [self.rootNav setIndexToRow:[[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue]];
            
            
        }
    }else if (alertView.tag == 501){
        
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
-(void)addRoomView{
    

    [self.displayedInfoWindow removeFromSuperview];

    NSLog(@"INside inside");
    // create our custom info window UIView and set the color to blueish
    self.displayedInfoWindow = [[UIView alloc] init];
    self.displayedInfoWindow.backgroundColor = [UIColor whiteColor];
    
    /* pointForCoordinate: takes a lat/lng and converts it into that lat/lngs current equivalent screen point.
     We'll use this to offset the display of the bottom of the custom info window so it doesn't overlap
     the marker icon. */
//    CGPoint markerPoint = [self.mapView.projection pointForCoordinate:self.currentlyTappedMarker.position];
//    
//    CGFloat addViewOrginY;
//    if(markerPoint.y-125<=110)
//    {
//        addViewOrginY=110;
//    }
//    else
//    {
//        addViewOrginY=markerPoint.y-125;
//    }
//    self.displayedInfoWindow.frame = CGRectMake(10, addViewOrginY, self.view.frame.size.width - 20, 150);
    self.displayedInfoWindow.frame = CGRectMake(10, 130, self.view.frame.size.width - 20, 150);
    self.displayedInfoWindow.layer.borderWidth = .5f;
    self.displayedInfoWindow.layer.borderColor=[[UIColor lightGrayColor] CGColor];
    self.displayedInfoWindow.layer.cornerRadius = 5.0;
    self.displayedInfoWindow.layer.zPosition = 100;
    
    roomAddress = [[UITextView alloc]init];
    roomAddress.delegate = self;
    roomAddress.frame =  CGRectMake(10, 5, 240, 100);
    roomAddress.font= [UIFont fontWithName:@"Museo-300" size:14];
    
    
    [self.displayedInfoWindow addSubview:roomAddress];
    
    
    hintLabel = [[UILabel alloc]init];
    hintLabel.frame =  CGRectMake(10, 5, 250, 90);
    hintLabel.numberOfLines = 0;
    hintLabel.textAlignment = UITextAlignmentLeft;
    hintLabel.font= [UIFont fontWithName:@"Museo-300" size:14];
    hintLabel.text =[NSString stringWithFormat:@"Example:\nThe Joey Mall\n2nd Floor\nNext to the Joey shop near the carpark entrance"];
    hintLabel.textColor = [UIColor lightGrayColor];
    [self.displayedInfoWindow addSubview:hintLabel];
    
    // Create a button and add a target - something we can't do with the default info window
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(self.displayedInfoWindow.frame.size.width-40, 5, 30, 30);
    [button addTarget:self action:@selector(crossButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [button setBackgroundImage:[UIImage imageNamed:@"CROSS BLACK"] forState:UIControlStateNormal];
    [self.displayedInfoWindow addSubview:button];
    
    UIView *singleLine = [[UIView alloc]init];
    singleLine.frame = CGRectMake(10, 110, self.view.frame.size.width - 40, 1);
    singleLine.backgroundColor = [UIColor lightGrayColor];
    [self.displayedInfoWindow addSubview:singleLine];
    
    UIButton *checkButton = [UIButton buttonWithType:UIButtonTypeSystem];
    checkButton.frame = CGRectMake(10, 115, 30, 30);
    checkButton.tintColor = [UIColor clearColor];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"box_btn"] forState:UIControlStateNormal];
    [checkButton setBackgroundImage:[UIImage imageNamed:@"box_btn_clicked"] forState:UIControlStateSelected];
    [checkButton addTarget:self action:@selector(checkbuttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.displayedInfoWindow addSubview:checkButton];
    
    UILabel *temporaryLabel = [[UILabel alloc]init];
    temporaryLabel.frame = CGRectMake(45, 115, self.displayedInfoWindow.frame.size.width - 110, 30);
    temporaryLabel.text = @"This is a temporary room";
    temporaryLabel.font =[UIFont fontWithName:@"Museo-300" size:15];
    temporaryLabel.textColor = [UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
    [self.displayedInfoWindow addSubview:temporaryLabel];
    
    
    addButton = [UIButton buttonWithType:UIButtonTypeSystem];
    addButton.frame = CGRectMake(self.displayedInfoWindow.frame.size.width-60, 115, 50, 30);
    addButton.backgroundColor= [UIColor lightGrayColor];
    addButton.layer.cornerRadius = 5.0;
    [addButton setTitle:@"Add" forState:UIControlStateNormal];
    [addButton setTintColor:[UIColor whiteColor]];
    [addButton addTarget:self action:@selector(addButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    addButton.enabled=NO;
    [self.displayedInfoWindow addSubview:addButton];
    
    
    // add the completed custom info window to self.view
    [self.view addSubview:self.displayedInfoWindow];
    
}

- (void)crossButtonClicked:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"InfoAddButton"];
    
  //  NSLog(@"button clicked for this marker: %@",self.currentlyTappedMarker);
    [self.displayedInfoWindow removeFromSuperview];
     self.displayedInfoWindow = nil;
    
    self.howToAddInfoView.hidden = YES;
    
    longpressedmarker.map = nil;
    searchMarker.map = nil;
    
    [self.rootNav setIndexToRow:0];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selectedIndex"];
    
    [self setMap];
}

- (void)checkbuttonClicked:(UIButton*)sender
{
    
    if (!sender.selected) {
        
        NSLog(@"check box selected");
      
        isTemporary = @"1";
     
        
    }
    if (sender.selected){
        
        NSLog(@"check box not selected");
    
        isTemporary = @"0";
    
    }
    
    sender.selected = !sender.selected;

    
}

- (void)addButtonClicked:(id)sender
{
    NSLog(@"Add button clicked: %@",self.currentlyTappedMarker);
    
    [roomAddress resignFirstResponder];
    
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
    
        self.howToAddInfoView.hidden = YES;
    
        NSLog(@"user id in add room:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
    
        NSString* currentLat;
        NSString* currentLong;
    
        if ( previousMarker.map == nil) {
            
            NSNumber *myDoubleNumber = [NSNumber numberWithDouble:currentLocation.latitude];
            currentLat = [myDoubleNumber stringValue];
            
            NSNumber *myDoubleNumber2 = [NSNumber numberWithDouble:currentLocation.longitude];
            currentLong = [myDoubleNumber2 stringValue];
            
        }else{
        
           NSNumber *myDoubleNumber = [NSNumber numberWithDouble:longpressedCoordinate.latitude];
           currentLat = [myDoubleNumber stringValue];
        
           NSNumber *myDoubleNumber2 = [NSNumber numberWithDouble:longpressedCoordinate.longitude];
           currentLong = [myDoubleNumber2 stringValue];
            
        }
        
        NSLog(@"added room coordinate  %@ ,%@ ",currentLat,currentLong);
    
    //for location address
    //https://github.com/lminhtm/LMGeocoder
    
//        NSError *error = nil;
//        NSString *lookupString = [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=false",currentLat,currentLong];
//        NSLog(@"URL: %@",lookupString);
//        lookupString = [lookupString stringByReplacingOccurrencesOfString:@" " withString:@"+"];
//    
//        NSData *jsonResponse = [NSData dataWithContentsOfURL:[NSURL URLWithString:lookupString]];
//    
//    
//    
//        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonResponse options:kNilOptions error:&error];
//    
//       // NSLog(@"response from reverse co....%@",jsonDict);
//    
//        locationArray = [[jsonDict valueForKey:@"results"] valueForKey:@"formatted_address"];
//        int total = locationArray.count;
//        NSLog(@"locationArray count: %d", locationArray.count);
//    
//        for (int i = 0; i < total; i++)
//        {
//            NSString *statusString = [jsonDict valueForKey:@"status"];
//            NSLog(@"JSON Response Status:%@", statusString);
//            NSLog(@"Address: %@", [locationArray objectAtIndex:0]);
//        }
    
        NSString* direction = roomAddress.text;

    
        NSLog(@"isTemporary   %@",isTemporary);
    
        spinner.hidden = NO;
        [spinner beginRefreshing];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params;
    
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] == nil) {
        
        NSLog(@"user id when not loged in%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
        
        params = @{@"access_key":@"flowdigital",
                                 @"user_id":@"13",
                                 @"longitude":currentLong,
                                 @"latitude":currentLat,
                                 @"direction":direction,
                                 @"is_temporary":isTemporary};
    }else{
        
        NSLog(@"user id when loged in%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]);
        
        params = @{@"access_key":@"flowdigital",
                                 @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"],
                                 @"longitude":currentLong,
                                 @"latitude":currentLat,
                                 @"direction":direction,
                                 @"is_temporary":isTemporary};
    }
        NSLog(@"param %@",params);
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
       
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"feeding-rooms/api-add-feeding-room"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
          //  NSLog(@"responseObject  JSON state: %@", responseObject);
            
            NSString* successMessage = [responseObject objectForKey:@"success"];
            
            if ([successMessage integerValue]==1 ) {
                
                longpressedmarker.map = nil;
                
                [roomAddress resignFirstResponder];
                
                self.howToAddInfoView.hidden = YES;
                self.howToAddCompleteInfoView.hidden = NO;
                self.displayedInfoWindow.hidden =YES;
              
                
                [self performSelector:@selector(secondMethod) withObject:nil afterDelay:5.0 ];
                
//                [UIView animateWithDuration:3.0 animations:^{
//                    self.howToAddCompleteInfoView.hidden = YES;
//                } completion:^(BOOL finished) {
//                    [self setMap];
//                }];
                
                [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"InfoAddButton"];
                
                [self.rootNav setIndexToRow:0];
                 [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selectedIndex"];
                
            }else{
            
                spinner.hidden = YES;
                [spinner endRefreshing];
                
               // longpressedmarker.map = nil;
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Sorry, unable to submit the feeding room location. Please try again !"
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
            
            }
           
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            NSLog(@"operation  %@",operation.response);
            
            [roomAddress resignFirstResponder];
            
            self.howToAddInfoView.hidden = YES;
            self.howToAddCompleteInfoView.hidden = YES;
            self.displayedInfoWindow.hidden =YES;
            self.longPressInfoView.hidden = NO;
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"InfoAddButton"];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Sorry, unable to submit the feeding room location. Please try again !"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }];
    }
}

-(void)secondMethod{

    self.howToAddCompleteInfoView.hidden = YES;
    

    
   [self setMap];


}
//

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [roomAddress resignFirstResponder];
    
    if (roomAddress.text.length == 0) {
        
        hintLabel.hidden = NO;
    }
    
    NSLog(@"Is it called");
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    hintLabel.hidden = YES;
    
    addButton.backgroundColor = [UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
    addButton.userInteractionEnabled = YES;
    addButton.enabled=YES;
    
    
    NSLog(@"Textview begin edting");
    
}

//////////////


-(void)makeRequest{
    
    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
   
    
//    self.netWarningView.hidden = YES;
    
    if(status == NotReachable)
    {
        NSLog(@"status %ld",(long)status);
        self.netWarningView.hidden =NO;
        
    }
    else{

        spinner.hidden = NO;
       [spinner beginRefreshing];
        
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        
        self.showListButton.userInteractionEnabled = NO;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"user_id":[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        
        
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"feeding-rooms/api-get-feeding-roomx"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
         //   NSLog(@"responseObject  JSON in login state: %@", responseObject);
            
            self.showListButton.userInteractionEnabled = YES;
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            self.feedingRoomList =  (NSMutableDictionary *)responseObject;
            
            self.feedingRoom = [[self.feedingRoomList objectForKey:@"FeedingRooms"]mutableCopy];
            
            self.favoritesArray = [[NSMutableArray alloc]init];
            
            for (int i = 0; i< self.feedingRoom.count; i++) {
                
                NSMutableDictionary *singleroomdetail = [[NSMutableDictionary alloc] initWithDictionary:[self.feedingRoom objectAtIndex:i]];
                
              //  NSLog(@"....................%@",[self.feedingRoom objectAtIndex:i]);
                
               

                if([[singleroomdetail objectForKey:@"favorites"] integerValue]==1)
                {
                    [self.favoritesArray addObject:singleroomdetail];
                }
                
                //[self favoriteRoomDistance];
            }
           
           
            
            [self favoriteRoomDistance];
            
            [self setMarker];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Sorry, we're facing issues with the network. Please try again"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }];
        
    }else{
    
        self.showListButton.userInteractionEnabled = NO;
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        NSDictionary *params = @{@"access_key": @"flowdigital"};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
         manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"feeding-rooms/api-get-feeding-rooms"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
          //  NSLog(@"responseObject  JSON in logout state: %@", responseObject);
            
            self.showListButton.userInteractionEnabled = YES;
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            self.feedingRoomList =  (NSMutableDictionary *)responseObject;
            
            self.feedingRoom = [[self.feedingRoomList objectForKey:@"FeedingRooms"]mutableCopy];
            
            [self setMarker];
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Sorry, we're facing issues with the network. Please try again"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }];
    
    
    
    }
    
    }
}

-(void)favoriteRoomDistance{
    
    // NSLog(@"Favorite room ........ :%@",self.favoritesArray);

    CLLocation *userLocationforFavorite = [[CLLocation alloc] initWithLatitude:currentLocation.latitude
                                                          longitude:currentLocation.longitude ];
    
   // NSLog(@"Favorite room ........count :%lu",(unsigned long)self.favoritesArray.count);
    
   if (self.favoritesArray.count != 0) {
        
   
     for (int i = 0; i < self.favoritesArray.count; i++) {
        
        NSMutableDictionary *favoriteRoomShortDetail = [[NSMutableDictionary alloc] init];
        favoriteRoomShortDetail=[self.favoritesArray objectAtIndex:i];
        
      //  NSLog(@"Favorite room ........favoriteRoomShortDetail :%@",favoriteRoomShortDetail);

        
        favoriteRoomLocation = [[CLLocation alloc] initWithLatitude:[[favoriteRoomShortDetail objectForKey:@"latitude"]doubleValue]
                                                  longitude:[[favoriteRoomShortDetail objectForKey:@"longitude"]doubleValue] ];
        
        
        
        
        distanceForFavoriteRoom = (int) [userLocationforFavorite distanceFromLocation:favoriteRoomLocation];
        
        [favoriteRoomShortDetail setObject:[NSNumber numberWithFloat:distanceForFavoriteRoom] forKey:@"distance"];
        [self.favoritesArray replaceObjectAtIndex:i withObject:favoriteRoomShortDetail];
        
        
      
        
        [[NSUserDefaults standardUserDefaults]setObject:self.favoritesArray forKey:@"favoriteroom"];
        
        
     }
   }else{
   
       [[NSUserDefaults standardUserDefaults]setObject:nil forKey:@"favoriteroom"];
       
   }

  //  NSLog(@"Favorite room :%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteroom"]);

}

-(void)setMarker{
    
    
    distancesArray = [[NSMutableArray alloc]init];
    nearRoomLocations = [[NSMutableArray alloc]init];
    
    //set feeding room marker
    
    CLLocation *userLocation = [[CLLocation alloc] initWithLatitude:currentLocation.latitude
                                                           longitude:currentLocation.longitude ];

    NSLog(@"feeding room count in set marker:%lu",(unsigned long)self.feedingRoom.count);
    
    for (int i =0; i<self.feedingRoom.count; i++) {
        
        NSMutableDictionary *roomShortDetail = [[NSMutableDictionary alloc]init];
        
        roomShortDetail = [[self.feedingRoom objectAtIndex:i]mutableCopy];
        
        
        
        if ([[roomShortDetail objectForKey:@"is_approved"] integerValue]==1) {
          
            approvedMarker = [[GMSMarker alloc] init];
            approvedMarker.position = CLLocationCoordinate2DMake([[roomShortDetail objectForKey:@"latitude"]doubleValue],[[roomShortDetail objectForKey:@"longitude"]doubleValue]);
            approvedMarker.title = [roomShortDetail objectForKey:@"title"];
            approvedMarker.userData =[roomShortDetail objectForKey:@"id"];
            approvedMarker.icon = [UIImage imageNamed:@"JoeyIcon.png"];
            approvedMarker.map = self.mapView;
        }

        roomLocation = [[CLLocation alloc] initWithLatitude:[[roomShortDetail objectForKey:@"latitude"]doubleValue]
                                                  longitude:[[roomShortDetail objectForKey:@"longitude"]doubleValue] ];
        
        
        distanceInmeters =(int) [userLocation distanceFromLocation:roomLocation];
        
        [roomShortDetail setObject:[NSNumber numberWithFloat:distanceInmeters] forKey:@"distance"];
        [self.feedingRoom replaceObjectAtIndex:i withObject:roomShortDetail];
        
        //distanceForFavoriteRoom = (int) [userLocation distanceFromLocation:roomLocation];
        
     //   NSLog(@"distanceInmeters  %f",distanceInmeters);

        if (distanceInmeters<= 5000) {

            [nearRoomLocations addObject:roomShortDetail];
            
            
           // [distancesArray addObject:[NSNumber numberWithDouble:distanceInmeters]];
            
         //   NSLog(@"near inside radius");
            
            

        }else{
            
         //   NSLog(@"It is not inside radius..................");
            
        }
    
    }
    
  //  NSLog(@"room after distance room %@",self.feedingRoom);
    
    if (nearRoomLocations.count == 0) {
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]integerValue]== 2){
            
            NSLog(@"#######selectedIndex is 2");
            
            self.longPressInfoView.hidden=NO;
            self.noFeedingRoomView.hidden = YES;
            self.showListinfoView.hidden=YES;
            self.netWarningView.hidden = YES;
            self.howToAddInfoView.hidden = YES;
            self.howToAddCompleteInfoView.hidden = YES;
            
            
        }else{
            
             NSLog(@"********selectedIndex is 0");
            
            self.noFeedingRoomView.hidden = NO;
            self.showListinfoView.hidden = YES;
            self.netWarningView.hidden = YES;
            self.howToAddInfoView.hidden = YES;
            self.longPressInfoView.hidden = YES;
            self.howToAddCompleteInfoView.hidden = YES;
            
            if (!self.noFeedingRoomView.hidden) {
                
                self.showListinfoView.hidden = YES;
                
            }

        }
        
    }else{
      
        if (![[[NSUserDefaults standardUserDefaults] objectForKey:@"addFeedingRoomMessage"] isEqualToString:@"1"]){
        
            if (self.longPressInfoView.hidden) {
                
                self.showListinfoView.hidden = NO;
                self.noFeedingRoomView.hidden = YES;
                self.netWarningView.hidden = YES;
                self.howToAddInfoView.hidden = YES;
                self.longPressInfoView.hidden = YES;
                self.howToAddCompleteInfoView.hidden = YES;

            }
            
            
        if (nearRoomLocations.count == 1) {
            
            self.showListinfoLabel.text = [NSString stringWithFormat:@"1 feeding room near your location"];
            
        }else if (nearRoomLocations.count>1){
        
            self.showListinfoLabel.text = [NSString stringWithFormat:@"%lu feeding rooms near your location",(unsigned long)nearRoomLocations.count];
            
        }
       
        
           if (!self.longPressInfoView.hidden) {
        
              self.showListinfoView.hidden = YES;
              self.noFeedingRoomView.hidden= YES;
        
           }
//               else{
//
//             self.showListinfoView.hidden = NO;
//            
//           }
      }
    }


}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - UITableView DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.searchResults.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kHNKDemoSearchResultsCellIdentifier forIndexPath:indexPath];
    
    HNKGooglePlacesAutocompletePlace *thisPlace = self.searchResults[indexPath.row];
    
    
    //test
    
     NSLog(@"Search result %@",thisPlace.terms);
    
    
    cell.textLabel.text = thisPlace.name;
    return cell;
}

#pragma mark - UITableView Delegate

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.searchBar setShowsCancelButton:NO animated:YES];
    [self.searchBar resignFirstResponder];
    _searchBar.text = @"";
    
    if (!self.displayedInfoWindow.hidden) {
        
        [self.displayedInfoWindow removeFromSuperview];
        self.displayedInfoWindow = nil;
        
    }
    
    if(previousMarker)
    {
        previousMarker.map = nil;
    }
    
    
    HNKGooglePlacesAutocompletePlace *selectedPlace = self.searchResults[indexPath.row];
    
    [CLPlacemark hnk_placemarkFromGooglePlace: selectedPlace
                                       apiKey:@"AIzaSyAqSWzZW_UDMwexQWhCPBjIpnPuzT7EjM0"
     
                                   completion:^(CLPlacemark *placemark, NSString *addressString, NSError *error) {
                                       if (placemark) {
                                           [self.searchTableView setHidden: YES];
                                           
                                           [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"searchLocation"];
                                           
                                           //place marker
                                           
                                           if (searchMarker) {
                                               
                                               searchMarker.map = nil;
                                           }
                                           searchMarker = [[GMSMarker alloc] init];
                                           searchMarker.position = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
                                           searchMarker.title = addressString;
                                           searchMarker.snippet = @"";
                                           searchMarker.appearAnimation = YES;
                                           searchMarker.map = self.mapView;
                                           
                                           googleMarkerLocation =CLLocationCoordinate2DMake(placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
                                           
                                          // googleMarkerLat = googleMarkerLocation.latitude;
                                           
                                           GMSCameraPosition *newLocation = [GMSCameraPosition cameraWithLatitude:placemark.location.coordinate.latitude
                                                                                                        longitude:placemark.location.coordinate.longitude
                                                                                                             zoom:13.5];
                                           
                                           [self.mapView animateToCameraPosition:newLocation];

                                          
                                           [nearRoomLocations removeAllObjects];
                                           [distancesArray removeAllObjects];
                                           
                                           if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue] == 2){
                                               
                                               if(previousMarker)
                                               {
                                                   previousMarker.map = nil;
                                               }
                                               searchMarker.map = nil;
                                               longpressedmarker.map = nil;
                                               
                                               longpressedmarker = [[GMSMarker alloc] init];
                                               [longpressedmarker setDraggable: YES];
                                              
                                               longpressedmarker.position = CLLocationCoordinate2DMake(placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);

                                               previousMarker = longpressedmarker;
                                               
                                               
                                               longpressedmarker.map = self.mapView;
                                               
                                               GMSCameraPosition *newLocation = [GMSCameraPosition cameraWithLatitude:placemark.location.coordinate.latitude
                                                                                                            longitude:placemark.location.coordinate.longitude
                                                                                                                 zoom:13.5];
                                               
                                                NSLog(@"newLocation of longpressed coordinate:%f   ,%f",placemark.location.coordinate.latitude,placemark.location.coordinate.longitude);
                                               
                                               [self.mapView animateToCameraPosition:newLocation];
                                               
                                               self.longPressInfoView.hidden = NO;
                                               
                                           }

                                           //Distance
                                           
                                           for (int i = 0; i< self.feedingRoom.count; i++) {
                                               
                                               NSMutableDictionary *roomShortDetail = [[self.feedingRoom objectAtIndex:i]mutableCopy];
                                               
                                               CLLocation *placeLocation = [[CLLocation alloc] initWithLatitude:placemark.location.coordinate.latitude longitude:placemark.location.coordinate.longitude];
                                               
                                               
                                               CLLocation * room = [[CLLocation alloc] initWithLatitude:[[roomShortDetail objectForKey:@"latitude"]doubleValue]
                                                                                              longitude:[[roomShortDetail objectForKey:@"longitude"]doubleValue] ];
                                               
                                               distanceInmeters = [placeLocation distanceFromLocation:room];
                                               
                                            
                                               [roomShortDetail setObject:[NSNumber numberWithFloat:distanceInmeters] forKey:@"distance"];
                                               [self.feedingRoom replaceObjectAtIndex:i withObject:roomShortDetail];
                                               
                                           //    NSLog(@"Distance is:%f",meters);
                                               if (distanceInmeters<= 5000) {
                                                   
                                                  // NSLog(@"It is inside radius...............");
                                                   
                                                  [nearRoomLocations addObject:roomShortDetail];
                                                   
                                                 // [distancesArray addObject:[NSNumber numberWithDouble:distanceInmeters]];
                                                 
                                                   
                                                 //  NSLog(@"Total number of rroom in search:  %@",nearRoomLocations);

                                                   
                                               }else{
                                                   
                                                 //  NSLog(@"It is not inside radius..................");
                                                   
                                               }
                                               
                                           }
                                           
                                           if (nearRoomLocations.count == 0) {
                                               
                                               if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue] == 2 ) {
                                                   
                                                   self.showListinfoView.hidden = YES;
                                                   self.noFeedingRoomView.hidden = YES;
                                                   NSLog(@"selected index in map when 2%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
                                                   
                                               }else
                                               {
                                               
                                                 [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"setMap"];
                                                 [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"InfoAddButton"];

                                               
                                                 self.longPressInfoView.hidden = YES;
                                               
                                                 self.noFeedingRoomView.hidden = NO;
                                                 self.showListinfoView.hidden = YES;
                                                 self.netWarningView.hidden = YES;
                                                 self.howToAddInfoView.hidden = YES;
                                                 self.howToAddCompleteInfoView.hidden = YES;
                                                 if (!self.noFeedingRoomView.hidden) {
                                                   
                                                   self.showListinfoView.hidden = YES;
                                                   
                                                 }
                                               }
                                           }else{
                                               
                                                if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"] intValue] == 2 ) {
                                                   
                                                    self.showListinfoView.hidden = YES;
                                                    self.noFeedingRoomView.hidden = YES;
                                                    self.howToAddInfoView.hidden = YES;
                                                    NSLog(@"selected index in map when 2%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
                                               
                                               }else
                                               {
                                                   
                                                   NSLog(@"selected index in map%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"selectedIndex"]);
                                                   
                                                  self.showListinfoView.hidden = NO;
                                                  self.noFeedingRoomView.hidden = YES;
                                                  self.longPressInfoView.hidden = YES;
                                                  
                                                  if (nearRoomLocations.count == 1) {
                                                      
                                                      self.showListinfoLabel.text = [NSString stringWithFormat:@"1 feeding room near your selected location"];
                                                      
                                                  }else if (nearRoomLocations.count>1){
                                                      
                                                      self.showListinfoLabel.text = [NSString stringWithFormat:@"%lu feeding rooms near your selected location",(unsigned long)nearRoomLocations.count];
                                                      
                                                  }
                                                  
                                              
                                                  
                                                  [self.searchTableView deselectRowAtIndexPath:indexPath animated:NO];
                                                  
                                                 
                                                  
                                              }
                                           }
                                       }
                                   }];
}

#pragma mark - UISearchBar Delegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [searchBar setShowsCancelButton:YES animated:YES];
    
//    self.showListinfoView.hidden = YES;
//    self.noFeedingRoomView.hidden = YES;
}

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if(searchText.length > 0)
    {
        [self.searchTableView setHidden:NO];
        
        [self.searchQuery fetchPlacesForSearchQuery: searchText
                                         completion:^(NSArray *places, NSError *error) {
                                             if (error) {
                                                 NSLog(@"ERROR: %@", error);
                                                 [self handleSearchError:error];
                                             } else {
                                                 self.searchResults = places;
                                                 [self.searchTableView reloadData];
                                             }
                                         }];
    }
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    searchBar.text = @"";
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
    [self.searchTableView setHidden:YES];
    
    
}

- (void)handleSearchError:(NSError *)error
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}


- (IBAction)drawerToggle:(id)sender {
    
        [roomAddress resignFirstResponder];
        [self.rootNav drawerToggle];
        
    }
    
#pragma mark - CCKFNavDrawerDelegate
    
    -(void)CCKFNavDrawerSelection:(NSInteger)selectionIndex
    {
        NSLog(@"CCKFNavDrawerSelection = %li", (long)selectionIndex);
        
//        int previousSelection = selectionIndex;
//        
//        NSLog(@"prevoius selection %d",previousSelection);
        
        if (selectionIndex==0){
            
            longpressedmarker.map = nil;
            searchMarker.map = nil;
            
            
            [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"InfoAddButton"];
            [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"searchLocation"];

            [self.displayedInfoWindow removeFromSuperview];
            self.displayedInfoWindow = nil;
            
            //Network connection
            
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            [reachability startNotifier];
            
            NetworkStatus status = [reachability currentReachabilityStatus];
            
            
            
            if(status == NotReachable)
            {
                self.netWarningView.hidden =NO;
                self.showListinfoView.hidden =YES;
                self.howToAddInfoView.hidden = YES;
                self.longPressInfoView.hidden = YES;
                self.noFeedingRoomView.hidden = YES;
                self.howToAddCompleteInfoView.hidden = YES;
                
            }else{
              
                self.netWarningView.hidden =YES;
                self.showListinfoView.hidden =YES;
                self.howToAddInfoView.hidden = YES;
                self.longPressInfoView.hidden = YES;
                self.noFeedingRoomView.hidden = YES;
                self.howToAddCompleteInfoView.hidden = YES;
                
                [self.mapView clear];
                [self setMap];
                
            }
        
        }else if (selectionIndex==1)
        {

            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
                
                FavoritesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoritesViewController"];
             
                NSLog(@"favo.....%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"favoriteroom"]);
                
                [self.navigationController pushViewController:vc animated:YES];
            
            }else{
                
               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"Please login or sign up to use this feature."
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Sign up/Login", nil];
                alert.tag = 101;
                
               [alert show];
            }
            
        } else if (selectionIndex==2)
        {
          // [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"addFeedingRoomMessage"];
            
            //Network connection
            
            Reachability *reachability = [Reachability reachabilityForInternetConnection];
            [reachability startNotifier];
            
            NetworkStatus status = [reachability currentReachabilityStatus];
            
            //self.netWarningView.hidden = YES;
            
            if(status == NotReachable)
            {
            
                self.netWarningView.hidden =NO;
                self.showListinfoView.hidden =YES;
                self.howToAddInfoView.hidden = YES;
                self.longPressInfoView.hidden = YES;
                self.howToAddCompleteInfoView.hidden =YES;
                self.noFeedingRoomView.hidden = YES;
                
            }else{
            
                [self addRoom];
                
            }
            
        }else if (selectionIndex==3)
        {
            LeaderBoardViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"LeaderBoardViewController"];
            
//            vc.favoriteListArray = self.favoritesArray;
//            vc.distanceArray = distancesArray;
            
            [self.navigationController pushViewController:vc animated:YES];
            
            
        }else if (selectionIndex==4)
        {
            MessagesViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MessagesViewController"];
            
//            vc.favoriteListArray = self.favoritesArray;
//            vc.distanceArray = distancesArray;
            
            [self.navigationController pushViewController:vc animated:YES];

            
            
        }else if (selectionIndex==5)
        {
            FAQsViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"FAQsViewController"];
            
//            vc.favoriteListArray = self.favoritesArray;
//            vc.distanceArray = distancesArray;
            
            [self.navigationController pushViewController:vc animated:YES];

            
            
        }else if (selectionIndex==6)
        {
            AboutJoeyViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AboutJoeyViewController"];
            
//            vc.favoriteListArray = self.favoritesArray;
//            vc.distanceArray = distancesArray;
            
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
                alert.tag = 501;
                
                [alert show];
            }
 
        }else if (selectionIndex==8)
        {
            if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
                
                SettingViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingViewController"];
                
//                vc.favoriteListArray = self.favoritesArray;
//                vc.distanceArray = distancesArray;
                
                [self.navigationController pushViewController:vc animated:YES];
                
            }else{
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                                message:@"Please login or sign up to use this feature."
                                                               delegate:self
                                                      cancelButtonTitle:@"Cancel"
                                                      otherButtonTitles:@"Sign up/Login", nil];
                alert.tag = 102;
                
                [alert show];
            }

           
            
        }
    }

-(void)addRoom{
    
    longpressedmarker.map = nil;
    self.noFeedingRoomView.hidden = YES;
    
    if (!self.displayedInfoWindow.hidden) {
        
        [self.displayedInfoWindow removeFromSuperview];
         self.displayedInfoWindow = nil;
    }
   
    
    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
     NSLog(@"calling add room");
    
    
    if(status == NotReachable)
    {
        
        self.netWarningView.hidden =NO;
        self.showListinfoView.hidden =YES;
        self.howToAddInfoView.hidden = YES;
        self.longPressInfoView.hidden = YES;
        self.howToAddCompleteInfoView.hidden =YES;
        self.noFeedingRoomView.hidden = YES;
    
    }else{
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"InfoAddButton"];
        
        if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"searchLocation"] isEqualToString:@"1"]) {
            
            self.userMarker.map = nil;
            
            if(previousMarker)
            {
                previousMarker.map = nil;
            }
            
            longpressedmarker = [[GMSMarker alloc] init];
            [longpressedmarker setDraggable: YES];
            longpressedmarker.position = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
            
            longpressedCoordinate = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
            
            NSLog(@"longpressed coordinate:%f   ,%f",longpressedCoordinate.latitude,longpressedCoordinate.longitude);
            // marker.title = placemark.name;
            //longpressedmarker.icon = [UIImage imageNamed:@"temp_joye.png"];
            longpressedmarker.map = self.mapView;
            
            previousMarker = longpressedmarker;
            
            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.latitude longitude:currentLocation.longitude zoom:13.5];
            [self.mapView animateToCameraPosition:camera];
        
            self.netWarningView.hidden =YES;
            self.showListinfoView.hidden =YES;
            self.howToAddInfoView.hidden = YES;
            self.longPressInfoView.hidden = NO;
            self.howToAddCompleteInfoView.hidden =YES;
            self.noFeedingRoomView.hidden = YES;
   
       
            
        }else{
        
            self.userMarker.map = nil;
            searchMarker.map = nil;
            
            if(previousMarker)
            {
                previousMarker.map = nil;
            }
            
            longpressedmarker = [[GMSMarker alloc] init];
            [longpressedmarker setDraggable: YES];
            longpressedmarker.position = CLLocationCoordinate2DMake(googleMarkerLocation.latitude, googleMarkerLocation.longitude);
            
            longpressedCoordinate = CLLocationCoordinate2DMake(googleMarkerLocation.latitude, googleMarkerLocation.longitude);
            
            NSLog(@"longpressed coordinate......:%f   ,%f",googleMarkerLocation.latitude,googleMarkerLocation.longitude);
            // marker.title = placemark.name;
            //longpressedmarker.icon = [UIImage imageNamed:@"temp_joye.png"];
            longpressedmarker.map = self.mapView;
            
            previousMarker = longpressedmarker;
            
            self.netWarningView.hidden =YES;
            self.showListinfoView.hidden =YES;
            self.howToAddInfoView.hidden = YES;
            self.longPressInfoView.hidden = NO;
            self.howToAddCompleteInfoView.hidden =YES;
            self.noFeedingRoomView.hidden = YES;
        
        }
  
   
    }

}

//- (void)registerForKeyboardNotifications{
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(keyboardWasShown:)
//     
//                                                 name:UIKeyboardDidShowNotification object:nil];
//    
//    
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//     
//                                             selector:@selector(keyboardWillBeHidden:)
//     
//                                                 name:UIKeyboardWillHideNotification object:nil];
//    
//}


// Called when the UIKeyboardDidShowNotification is sent.

//- (void)keyboardWasShown:(NSNotification*)aNotification{
//    
//    NSDictionary* info = [aNotification userInfo];
//    
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//    
//    
//    
//    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
//
//    actualYPointOfDisplayView=self.displayedInfoWindow.frame.origin.y;
//    CGRect aRect = CGRectMake(10,self.view.bounds.size.height- (kbSize.height+150+150), self.view.frame.size.width - 20, 150);
//    
//    
//    
//    if (!CGRectContainsPoint(aRect, self.displayedInfoWindow.frame.origin) ) {
//        
//        aRect.origin.y+=150;
//        self.displayedInfoWindow.frame=aRect;
//
//        
//    }
//    
//}



// Called when the UIKeyboardWillHideNotification is sent

//- (void)keyboardWillBeHidden:(NSNotification*)aNotification{
    
//     CGRect aRect = CGRectMake(10,actualYPointOfDisplayView, self.view.frame.size.width - 20, 150);
//     self.displayedInfoWindow.frame=aRect;
//     actualYPointOfDisplayView=0;
//}

    

- (IBAction)crossButtomAction:(id)sender {
    
     self.showListinfoView.hidden = YES;
}

- (IBAction)crossButtonInNoFeedingRoomView:(id)sender {
    
    self.noFeedingRoomView.hidden = YES;
    searchMarker.map = nil;
    
    
    if ([[[NSUserDefaults standardUserDefaults]objectForKey:@"setMap"] isEqualToString:@"1"] ) {
        
        [self setMap];
        
       [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"setMap"];
        
    }else{
    
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.latitude longitude:currentLocation.longitude zoom:13.5];
        
        
        [self.mapView animateToCameraPosition:camera];
    
    }
    
    [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"searchLocation"];

}

- (IBAction)crossInNextView:(id)sender {
    
    [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"searchLocation"];

    [[NSUserDefaults standardUserDefaults ] setObject:@"0" forKey:@"InfoAddButton"];
    
    self.longPressInfoView.hidden = YES;
    
    longpressedmarker.map = nil;
    searchMarker.map = nil;
    
    [self.rootNav setIndexToRow:0];
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"selectedIndex"];
    
    [self setMap];
    
}

- (IBAction)infoAddButton:(id)sender {
    
    self.userMarker.map = nil;
    searchMarker.map = nil;
    
    if (![[[NSUserDefaults standardUserDefaults]objectForKey:@"searchLocation"] isEqualToString:@"1"]) {
        
        self.userMarker.map = nil;
        searchMarker.map = nil;
        
        if(previousMarker)
        {
            previousMarker.map = nil;
        }
        
        longpressedmarker = [[GMSMarker alloc] init];
        [longpressedmarker setDraggable: YES];
        longpressedmarker.position = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
        
        longpressedCoordinate = CLLocationCoordinate2DMake(currentLocation.latitude, currentLocation.longitude);
        
        NSLog(@"longpressed coordinate:%f   ,%f",longpressedCoordinate.latitude,longpressedCoordinate.longitude);
        // marker.title = placemark.name;
        //longpressedmarker.icon = [UIImage imageNamed:@"temp_joye.png"];
        longpressedmarker.map = self.mapView;
        
        previousMarker = longpressedmarker;
        
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.latitude longitude:currentLocation.longitude zoom:13.5];
        [self.mapView animateToCameraPosition:camera];
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"InfoAddButton"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"selectedIndex"];
        
        [self.rootNav setIndexToRow:2];
        
        self.showListinfoView.hidden = YES;
        self.noFeedingRoomView.hidden = YES;
        self.longPressInfoView.hidden = NO;
        
    }else{

        self.userMarker.map = nil;
        searchMarker.map = nil;
        
        if(previousMarker)
        {
            previousMarker.map = nil;
        }
        
        longpressedmarker = [[GMSMarker alloc] init];
        [longpressedmarker setDraggable: YES];
        longpressedmarker.position = CLLocationCoordinate2DMake(googleMarkerLocation.latitude, googleMarkerLocation.longitude);
        
        longpressedCoordinate = CLLocationCoordinate2DMake(googleMarkerLocation.latitude, googleMarkerLocation.longitude);
        
        NSLog(@"longpressed coordinate:%f   ,%f",googleMarkerLocation.latitude,googleMarkerLocation.longitude);
        // marker.title = placemark.name;
        //longpressedmarker.icon = [UIImage imageNamed:@"temp_joye.png"];
        longpressedmarker.map = self.mapView;
        
        previousMarker = longpressedmarker;
        
        
        [[NSUserDefaults standardUserDefaults ] setObject:@"1" forKey:@"InfoAddButton"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"2" forKey:@"selectedIndex"];
        
        [self.rootNav setIndexToRow:2];
        
        self.showListinfoView.hidden = YES;
        self.noFeedingRoomView.hidden = YES;
        self.longPressInfoView.hidden = NO;
    }
}

- (IBAction)nextButton:(id)sender {
    
//    if ( previousMarker.map == nil) {
//    
//            GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:currentLocation.latitude longitude:currentLocation.longitude zoom:13.5];
//            [self.mapView animateToCameraPosition:camera];
//    }
    
            [self addRoomView];
            self.longPressInfoView.hidden = YES;
            self.howToAddInfoView.hidden = NO;
    
    
}

- (IBAction)showListButton:(id)sender {
    
    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    
    
    if(status == NotReachable)
    {
        self.netWarningView.hidden = NO;
        self.showListinfoView.hidden = YES;
        
        
        // [self.searchBar setUserInteractionEnabled:NO];
        
    }else{
        
        FacilityListViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"FacilityListViewController"];
        controller.feedingRoomList=[[NSMutableArray alloc] init];
        
        
        ///distance sort
        NSArray* feedingRoomes = [nearRoomLocations sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            
            NSMutableDictionary* s1=obj1;
            NSMutableDictionary* s2=obj2;
            
            if ([[s1 objectForKey:@"distance"] floatValue] < [[s2 objectForKey:@"distance"] floatValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ([[s1 objectForKey:@"distance"] floatValue] > [[s2 objectForKey:@"distance"] floatValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
           return (NSComparisonResult)NSOrderedSame;
        }];
        
        
        NSLog(@"feedingRoomes %@",feedingRoomes);
        
        
        
        controller.feedingRoomList= [[NSMutableArray alloc] initWithArray:feedingRoomes];
        controller.distance = distancesArray;
        controller.favoriteListArray = [[NSMutableArray alloc]init];
        controller.favoriteListArray = self.favoritesArray;
        //controller.isFavorite = isFavorite;
        
        [self.navigationController pushViewController:controller animated:YES];
        
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
 
}
@end
