//
//  MapViewController.h
//  JoeyPod
//
//  Created by Sujan on 2/22/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import <UIKit/UIKit.h>
@import GoogleMaps;
#import <CoreLocation/CoreLocation.h>
#import <HNKGooglePlacesAutocomplete/HNKGooglePlacesAutocomplete.h>
#import "CCKFNavDrawer.h"

#import "KSToastView.h"


@interface MapViewController : UIViewController<CLLocationManagerDelegate,UISearchBarDelegate, UITableViewDataSource,UITableViewDelegate,GMSMapViewDelegate, CCKFNavDrawerDelegate,UITextViewDelegate,UIAlertViewDelegate>{

       CLLocationCoordinate2D currentLocation;
    
       CLLocationCoordinate2D googleMarkerLocation;
}

@property (strong)NSMutableDictionary *feedingRoomList;
@property (strong,nonatomic) NSMutableArray *feedingRoom;
@property(nonatomic,strong) NSMutableArray* favoritesArray;


@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@property (weak, nonatomic) IBOutlet GMSMapView *mapView;

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

@property (strong, nonatomic) HNKGooglePlacesAutocompleteQuery *searchQuery;

@property (strong, nonatomic) NSArray *searchResults;

@property (strong,nonatomic) GMSPlacePicker *placePicker;
@property (strong,nonatomic) GMSAutocompleteViewController *resultsViewController;
@property(strong,nonatomic) UISearchController *searchController;

@property (weak, nonatomic) IBOutlet UIView *showListinfoView;
@property (weak, nonatomic) IBOutlet UIView *longPressInfoView;

@property (weak, nonatomic) IBOutlet UIView *howToAddInfoView;
@property (weak, nonatomic) IBOutlet UIView *noFeedingRoomView;
@property (weak, nonatomic) IBOutlet UIView *addRoomRequestInfoView;

@property (weak, nonatomic) IBOutlet UIView *howToAddCompleteInfoView;
@property (weak, nonatomic) IBOutlet UIView *netWarningView;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;



@property (weak, nonatomic) IBOutlet UILabel *showListinfoLabel;

@property (weak, nonatomic) IBOutlet UIButton *showListButton;
@property (weak, nonatomic) IBOutlet UIButton *addRoomButton;

@property(nonatomic,strong) GMSCircle *circle;

- (IBAction)crossButtomAction:(id)sender;

- (IBAction)crossButtonInNoFeedingRoomView:(id)sender;

- (IBAction)crossInNextView:(id)sender;


- (IBAction)infoAddButton:(id)sender;

- (IBAction)nextButton:(id)sender;

- (IBAction)showListButton:(id)sender;

- (IBAction)drawerToggle:(id)sender;



@end
