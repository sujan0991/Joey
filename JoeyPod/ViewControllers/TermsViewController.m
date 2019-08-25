//
//  TermsViewController.m
//  Joey
//
//  Created by Sujan on 6/21/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "TermsViewController.h"
#import "Reachability.h"
#import "JTMaterialSpinner.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "KSToastView.h"

@interface TermsViewController (){


    JTMaterialSpinner * spinner;

}

@end

@implementation TermsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:view];
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;

    
    [self makerequest];
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
        NSDictionary *params = @{@"access_key": @"flowdigital",
                                 @"message_id":@"2"};
        
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
        
        [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,@"abouts/api-get-joey"] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
            
            NSLog(@"responseObject  JSON for detail: %@", responseObject);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            NSString* message = [responseObject objectForKey:@"body"];
            
            NSString *htmlString = [NSString stringWithFormat:@"<font face='Museo-300' size='3'>%@", message];
            
            [self.termsWebView loadHTMLString:htmlString baseURL:nil];
            
            self.termsWebView.scrollView.showsHorizontalScrollIndicator = NO;
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            
            spinner.hidden = YES;
            [spinner endRefreshing];
            
            NSLog(@"responce............%@",operation.responseString);
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                            message:@"Sorry, we're facing issues with the network. Please try again"
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//            [alert show];
        }];
        
        
        
    }



}

- (IBAction)crossButtonAction:(id)sender {
    
     [self dismissViewControllerAnimated:YES completion:nil];
}


@end
