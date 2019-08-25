//
//  MessagesDetailViewController.m
//  JoeyPod
//
//  Created by Sujan on 4/6/16.
//  Copyright © 2016 Sujan. All rights reserved.
//

#import "MessagesDetailViewController.h"
#import <AFNetworking.h>
#import "Urls.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"

@interface MessagesDetailViewController (){


    JTMaterialSpinner * spinner;
}

@end

@implementation MessagesDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSLog(@"subject>>>>>%@",self.subject);
    
    self.loader.hidden = YES;
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *serverDateFormatter = [[NSDateFormatter alloc] init];
    
    NSString* formatString = self.date;
    
    [serverDateFormatter setDateFormat:@"yyyy'-'MM'-'dd'T'HH':'mm':'ssz"];
    
    NSDate *commentdate = [serverDateFormatter dateFromString:formatString];
    
    [dateFormatter setDateFormat:@"EEE MMM d yyyy,HH:mm"];

    
    self.subjectLabel.text = self.subject;
    self.dateLabel.text =[dateFormatter stringFromDate:commentdate];
    
    NSLog(@"message id %@",self.messageId);
    
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
                             @"message_id":self.messageId};
    
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
        NSString *apiLink;
        
        if (self.typeId == 1) {
            
            apiLink = @"messages/api-get-message-body";
            
        }else
        {
        
            apiLink = @"messages/api-get-message-Reply";
        }
    
    [manager POST:[NSString stringWithFormat:@"%@%@", baseUrl,apiLink] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        
       NSLog(@"responseObject  JSON for detail: %@", responseObject);
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        NSString* message = [responseObject objectForKey:@"body"];
        
        NSString *htmlString = [NSString stringWithFormat:@"<font face='Museo-300' size='4'>%@", message];
        
        [self.detailMessage loadHTMLString:htmlString baseURL:nil];
        
        self.detailMessage.scrollView.showsHorizontalScrollIndicator = NO;
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        NSLog(@"responce............%@",operation.responseString);
        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
//                                                        message:@"Sorry, we're facing issues with the network. Please try again"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
    }];



    }


}
- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)deletebutton:(id)sender {
}
@end
