//
//  CCKFNavDrawer.m
//  CCKFNavDrawer
//
//  Created by calvin on 23/1/14.
//  Copyright (c) 2014年 com.calvin. All rights reserved.
//

#import "CCKFNavDrawer.h"
#import "DrawerView.h"
#import "HostPagerViewController.h"
#import "MapViewController.h"
#import "HexColors.h"
#import <Google/SignIn.h>

#define SHAWDOW_ALPHA 0.5
#define MENU_DURATION 0.3
#define MENU_TRIGGER_VELOCITY 350

@interface CCKFNavDrawer ()
{
    NSArray* imageArray;
    UILabel* mainLabel;
    NSArray* selectedImageArray;
}
@property (strong) NSArray *menuList;


@property (nonatomic) BOOL isOpen;
@property (nonatomic) float meunHeight;
@property (nonatomic) float menuWidth;
@property (nonatomic) CGRect outFrame;
@property (nonatomic) CGRect inFrame;
@property (strong, nonatomic) UIView *shawdowView;
@property (strong, nonatomic) DrawerView *drawerView;

@end

@implementation CCKFNavDrawer

#pragma mark - VC lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:view];
    
   
    self.menuList = [[NSArray alloc] initWithObjects:@"Show Map",@"My Favourites",@"Add Feeding Room",@"Leaderboard",@"Messages",@"FAQs",@"About Joey",@"Contact Us",@"Settings", nil];
    
    UIImage *image1 = [UIImage imageNamed:@"location"];
    UIImage *image2 = [UIImage imageNamed:@"love"];
    UIImage *image3 = [UIImage imageNamed:@"add a new feeding room"];
    UIImage *image4 = [UIImage imageNamed:@"message"];
    UIImage *image5 = [UIImage imageNamed:@"FAQ"];
    UIImage *image6 = [UIImage imageNamed:@"About"];
    UIImage *image7 = [UIImage imageNamed:@"Contact"];
    UIImage *image8 = [UIImage imageNamed:@"Settings"];
    UIImage *image9 = [UIImage imageNamed:@"trophy"];
    
    UIImage *image10 = [UIImage imageNamed:@"location_w"];
    UIImage *image11 = [UIImage imageNamed:@"love_w"];
    UIImage *image12 = [UIImage imageNamed:@"add a new feeding room_w"];
    UIImage *image13 = [UIImage imageNamed:@"message_w"];
    UIImage *image14 = [UIImage imageNamed:@"FAQ_w"];
    UIImage *image15 = [UIImage imageNamed:@"About_w"];
    UIImage *image16 = [UIImage imageNamed:@"Contact_w"];
    UIImage *image17 = [UIImage imageNamed:@"Settings_w"];
    UIImage *image18 = [UIImage imageNamed:@"trophy_w"];
    
    imageArray = [[NSArray alloc] initWithObjects:image1,image2,image3,image9,image4,image5,image6,image7,image8, nil];
    
    selectedImageArray = [[NSArray alloc] initWithObjects:image10,image11,image12,image18,image13,image14,image15,image16,image17, nil];
   // NSLog(@"%@",imageArray);
   
    [self setUpDrawer];
        
  
    
   //welcomeLabel
    
//    self.drawerView.welcomeLabel.font =[UIFont fontWithName:@"Museo-300" size:15];
    
    
    self.drawerView.nickNameLabel.font =[UIFont fontWithName:@"Museo-300" size:15];
    
    //LogIn Button
    //self.drawerView.loginButton.tag = 100;
    
    [self setLoginButtonStat];
    
}

-(void)setLoginButtonStat
{

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]){
        
        self.drawerView.loginButton.tag=100;
        
        [self.drawerView.loginButton setTitle: @"Logout" forState: UIControlStateNormal];
        
        self.drawerView.nickNameLabel.hidden =NO;
        self.drawerView.nickNameLabel.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"nickName"];
        //
        //        [self.drawerView.loginButton addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];
        //
        //        NSLog(@"LOGIN STATE");
        
    }else{
        
        self.drawerView.loginButton.tag=101;
        
        [self.drawerView.loginButton setTitle: @"Login/Signup" forState: UIControlStateNormal];
        
        self.drawerView.nickNameLabel.hidden =YES;
        NSLog(@"LOGOUT STATE");
    }
    [self.drawerView.loginButton addTarget:self action:@selector(loginButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

-(void) setIndexToRow: (int) index
{
    //[self.CCKFNavDrawerDelegate CCKFNavDrawerSelection:index];
    
    NSIndexPath* selectedCellIndexPath= [NSIndexPath indexPathForRow:index inSection:0];
  //  [self tableView:self.drawerView.drawerTable didSelectRowAtIndexPath:selectedCellIndexPath];
    
    [self.drawerView.drawerTable selectRowAtIndexPath:selectedCellIndexPath animated:YES scrollPosition:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//login button action
-(void) loginButtonAction : (UIButton* )sender
{
    if(sender.tag==100)
    {
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginType"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginTypeGoogle"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loginTypeFacebook"];
        
        [self closeNavigationDrawer];
        
        [[GIDSignIn sharedInstance] signOut];
        
        [self.drawerView.loginButton setTitle: @"Login/Signup" forState: UIControlStateNormal];
        self.drawerView.nickNameLabel.hidden =YES;
        
        MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
        [self pushViewController:vc animated:YES];
        
        [self setIndexToRow:0];

        sender.tag=101;
    }
    else if(sender.tag==101)
    {
    
        HostPagerViewController *hostPager = [self.storyboard instantiateViewControllerWithIdentifier:@"HostPagerViewController"];
        
        // do any setup you need for myNewVC
        
        [self pushViewController:hostPager animated:YES];
        
        [self closeNavigationDrawer];
        // sender.tag=100;  //?????????
    }
        
}


//-(void)logout:(id)sender{
//    
//    UIButton *btn = (UIButton *) sender;
//    NSLog(@"logout button: %ld",(long)btn.tag);
//    
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
//    
//     MapViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"MapViewController"];
//     [self pushViewController:vc animated:YES];
//
//}
#pragma mark - push & pop

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [super pushViewController:viewController animated:animated];
    
    // disable gesture in next vc
    [self.pan_gr setEnabled:NO];
}

- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    UIViewController *vc = [super popViewControllerAnimated:animated];
    
    // enable gesture in root vc
    if ([self.viewControllers count]==1){
        [self.pan_gr setEnabled:YES];
    }
    return vc;
}

#pragma mark - drawer

- (void)setUpDrawer
{
    self.isOpen = NO;
    
    // load drawer view
    self.drawerView = [[[NSBundle mainBundle] loadNibNamed:@"DrawerView" owner:self options:nil] objectAtIndex:0];
    
    self.meunHeight = self.view.frame.size.height;
   // self.meunHeight = self.drawerView.frame.size.height;
    self.menuWidth = self.drawerView.frame.size.width;
    self.outFrame = CGRectMake(-self.menuWidth,0,self.menuWidth,self.meunHeight);
    self.inFrame = CGRectMake (0,0,self.menuWidth,self.meunHeight);
    
//test for right drawer
//    self.outFrame = CGRectMake(self.menuWidth+200,0,0,self.meunHeight);
//    self.inFrame = CGRectMake (self.menuWidth-80,0,self.menuWidth,self.meunHeight);
    
    // drawer shawdow and assign its gesture
    self.shawdowView = [[UIView alloc] initWithFrame:self.view.frame];
    self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    self.shawdowView.hidden = YES;
    UITapGestureRecognizer *tapIt = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                            action:@selector(tapOnShawdow:)];
    [self.shawdowView addGestureRecognizer:tapIt];
    self.shawdowView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:self.shawdowView];
    
    // add drawer view
    [self.drawerView setFrame:self.outFrame];
    [self.view addSubview:self.drawerView];
    
    // drawer list
    [self.drawerView.drawerTable setContentInset:UIEdgeInsetsMake(0, 0, 0, 0)]; 
    self.drawerView.drawerTable.dataSource = self;
    self.drawerView.drawerTable.delegate = self;
    self.drawerView.drawerTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //self.drawerView.drawerTable.backgroundColor = [ UIColor colorWithRed:36/255.0f green:36/255.0f blue:36/255.0f alpha:1.0f];
    
    // gesture on self.view
    self.pan_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
    self.pan_gr.maximumNumberOfTouches = 1;
    self.pan_gr.minimumNumberOfTouches = 1;
    //self.pan_gr.delegate = self;
    [self.view addGestureRecognizer:self.pan_gr];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
//    for (id x in self.view.subviews){
//        NSLog(@"%@",NSStringFromClass([x class]));
//    }
}

- (void)drawerToggle
{
    if (!self.isOpen) {
        [self openNavigationDrawer];
    }else{
        [self closeNavigationDrawer];
    }
}

#pragma open and close action

- (void)openNavigationDrawer{
//    NSLog(@"open x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    self.shawdowView.hidden = NO;
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:SHAWDOW_ALPHA];
                     }
                     completion:nil];
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.inFrame;
                     }
                     completion:nil];
    
    self.isOpen= YES;
    
    // gesture on self.view
    self.pan_gr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveDrawer:)];
    self.pan_gr.maximumNumberOfTouches = 1;
    self.pan_gr.minimumNumberOfTouches = 1;
    //self.pan_gr.delegate = self;
    [self.view addGestureRecognizer:self.pan_gr];
    
    [self.view bringSubviewToFront:self.navigationBar];
    
}

- (void)closeNavigationDrawer{
//    NSLog(@"close x=%f",self.menuView.center.x);
    float duration = MENU_DURATION/self.menuWidth*abs(self.drawerView.center.x)+MENU_DURATION/2; // y=mx+c
    
    // shawdow
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0f];
                     }
                     completion:^(BOOL finished){
                         self.shawdowView.hidden = YES;
                     }];
    
    // drawer
    [UIView animateWithDuration:duration
                          delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         self.drawerView.frame = self.outFrame;
                     }
                     completion:nil];
    self.isOpen= NO;
}

#pragma gestures

- (void)tapOnShawdow:(UITapGestureRecognizer *)recognizer {
    [self closeNavigationDrawer];
}

-(void)moveDrawer:(UIPanGestureRecognizer *)recognizer
{
    CGPoint translation = [recognizer translationInView:self.view];
    CGPoint velocity = [(UIPanGestureRecognizer*)recognizer velocityInView:self.view];
//    NSLog(@"velocity x=%f",velocity.x);
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateBegan) {
//        NSLog(@"start");
        if ( velocity.x > MENU_TRIGGER_VELOCITY && !self.isOpen) {
            [self openNavigationDrawer];
        }else if (velocity.x < -MENU_TRIGGER_VELOCITY && self.isOpen) {
            [self closeNavigationDrawer];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateChanged) {
//        NSLog(@"changing");
        float movingx = self.drawerView.center.x + translation.x;
        if ( movingx > -self.menuWidth/2 && movingx < self.menuWidth/2){
            
            self.drawerView.center = CGPointMake(movingx, self.drawerView.center.y);
            [recognizer setTranslation:CGPointMake(0,0) inView:self.view];
            
            float changingAlpha = SHAWDOW_ALPHA/self.menuWidth*movingx+SHAWDOW_ALPHA/2; // y=mx+c
            self.shawdowView.hidden = NO;
            self.shawdowView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:changingAlpha];
        }
    }
    
    if([(UIPanGestureRecognizer*)recognizer state] == UIGestureRecognizerStateEnded) {
//        NSLog(@"end");
        if (self.drawerView.center.x>0){
            [self openNavigationDrawer];
        }else if (self.drawerView.center.x<0){
            [self closeNavigationDrawer];
        }
    }

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.menuList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
   // UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
  //  if (!cell)
     UITableViewCell *cell  = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: CellIdentifier];
    
    // Configure the cell...
    
    //cell.backgroundColor = [UIColor clearColor];
    
    //NSLog(@"%@",[self.menuList objectAtIndex:[indexPath row]]);
    
    mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(35.0, 0, 210.0, cell.contentView.frame.size.height)];
    mainLabel.text = [self.menuList objectAtIndex:[indexPath row]];
    mainLabel.font = [UIFont fontWithName:@"Museo-500" size:17];
    mainLabel.textAlignment = NSTextAlignmentLeft;
    mainLabel.textColor = [UIColor grayColor];
    mainLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [cell.contentView addSubview:mainLabel];
    
    mainLabel.highlightedTextColor = [ UIColor whiteColor];
   // [cell setTintColor:[UIColor whiteColor]];
    
    UIImageView* photo = [[UIImageView alloc] initWithFrame:CGRectMake(15, 16, 15, 15)];
    photo.image=[imageArray objectAtIndex:indexPath.row];
    [cell addSubview:photo];
    
    photo.highlightedImage=[selectedImageArray objectAtIndex:indexPath.row];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
    [cell setSelectedBackgroundView:bgColorView];
    
    
    
    self.drawerView.drawerTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 1 || indexPath.row == 8 || indexPath.row == 7) {
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]) {
            
             [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"selectedIndex"];
            
        }
        
    }else
        
        [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:indexPath.row] forKey:@"selectedIndex"];
    
    [self.CCKFNavDrawerDelegate CCKFNavDrawerSelection:[indexPath row]];
    
    //mainLabel.textColor = [UIColor whiteColor];
 
    NSLog(@"clicked");
    
    [self closeNavigationDrawer];
    
}



@end
