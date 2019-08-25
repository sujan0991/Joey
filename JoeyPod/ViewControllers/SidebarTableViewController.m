//
//  SidebarTableViewController.m
//  JoeyPod
//
//  Created by Sujan on 2/22/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "SidebarTableViewController.h"
#import "SettingViewController.h"

@interface SidebarTableViewController (){

    NSArray *menuItems;
}

@end

@implementation SidebarTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    menuItems = @[ @"Map", @"Favorites", @"Messages", @"FAQs", @"About", @"Contact", @"Setting"];
    
    //tableView
    self.slideTable.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//  static NSString *CellIdentifier = @"Cell";
//  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
 // cell.textLabel.text = [menuItems objectAtIndex:indexPath.row];
    
    NSString *CellIdentifier = [menuItems objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    return cell;
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    
//  
//        
//        SettingViewController *settingViewController = [[SettingViewController alloc] init];
//    
//        [self.navigationController pushViewController:settingViewController animated:YES];
//    
//    NSLog(@"didselect %@",self.navigationController);
//  
//    
//
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
