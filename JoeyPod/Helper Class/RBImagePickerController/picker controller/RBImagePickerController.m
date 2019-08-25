//
//  RBImagePickerController.m
//  RBImagePicker
//
//  Created by Roshan Balaji on 1/31/14.
//  Copyright (c) 2014 Uniq Labs. All rights reserved.
//

#import "RBImagePickerController.h"
#import "RBImageCollectionController.h"

#import "Urls.h"
#import "HexColors.h"
#import "Reachability.h"
#import "KSToastView.h"
#import "JTMaterialSpinner.h"

@interface RBImagePickerController (){
    
    UIButton *nextButton;
    UIButton *uploadButton;
    UIButton *backbutton;
    UIButton *backbutton2;
    UILabel *titleLabel;
    JTMaterialSpinner* spinner;
    JTMaterialSpinner* spinner2;
}

@property(nonatomic, strong) RBImageCollectionController *assetCollection;
@property(nonatomic,strong) UIView *secondView ;
@property BOOL didSelectImage;
@property (nonatomic,strong) UIImageView *cameraImage;
@property(nonatomic,strong) UIImage *chosenImage;
@property(nonatomic,strong) UITextView *textView;
@end

@implementation RBImagePickerController

//NSString * const TITLE = @"Add Photo(s)";
//NSString * const DONE = @"UpLoad";
//NSString * const CANCEL = @"Cancel";

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
   
    self.assetCollection = [[RBImageCollectionController alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    
    self.assetCollection.maxSelectionCount = 5;
    self.assetCollection.pickerDelegate = self;
   // [self assignMaxSelectionCount];
    [self assignMinSelectionCount];
   // self.assetCollection.navigationItem.title = TITLE;
    self.navigationBarHidden = YES;
    
//   // NavigationView
    
    UIView *navigationView = [[UIView alloc] initWithFrame: CGRectMake ( 0,20, self.view.frame.size.width, 44)];
    navigationView.backgroundColor = [UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
    
    CGFloat backbuttonWidth = navigationView.frame.size.width * 0.125;
    
    backbutton = [[UIButton alloc]initWithFrame:CGRectMake(8, navigationView.frame.size.height/2-backbuttonWidth/2+4, 35, 35)];
    UIImage *backButtonImage = [UIImage imageNamed:@"cross_white2"];
    [backbutton setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [navigationView addSubview:backbutton];
    [backbutton addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    
    uploadButton = [[UIButton alloc]initWithFrame:CGRectMake(navigationView.frame.size.width-80, navigationView.frame.size.height/2-backbuttonWidth/2, 80, backbuttonWidth)];
    [uploadButton setTitle:@"Upload" forState:UIControlStateNormal];
    uploadButton.font =[UIFont fontWithName:@"Museo-500" size:18];
    uploadButton.hidden = YES;
    //uploadButton.backgroundColor=[UIColor grayColor];
    
    [navigationView addSubview:uploadButton];
    [uploadButton addTarget:self action:@selector(onUpload:) forControlEvents:UIControlEventTouchUpInside];

    titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(backbuttonWidth+10, 0, navigationView.frame.size.width-150, 44)];
    titleLabel.text =@"Add Photo(s) Of This Feeding Room";
    titleLabel.font =[UIFont fontWithName:@"Museo-500" size:17];
    titleLabel.numberOfLines=0;
    titleLabel.lineBreakMode=UILineBreakModeWordWrap;
    titleLabel.textAlignment = UITextAlignmentCenter;
    titleLabel.textColor = [UIColor whiteColor];
    [titleLabel setCenter:CGPointMake(navigationView.center.x, titleLabel.center.y)];
    //titleLabel.backgroundColor=[UIColor whiteColor];
    
    [navigationView addSubview:titleLabel];
    
    
    //CameraView
    UIView *cameraView = [[UIView alloc] initWithFrame: CGRectMake ( 0,self.view.frame.size.height - 60, self.view.frame.size.width, 60)];
    cameraView.backgroundColor = [UIColor hx_colorWithHexString:@"ffffff" alpha:0.8];
    
    CGFloat buttonWidth =cameraView.frame.size.width * 0.20;
    
    UIButton *cameraButton = [[UIButton alloc] initWithFrame:CGRectMake(cameraView.frame.size.width/2-buttonWidth/2, cameraView.frame.size.height/2-buttonWidth/2, buttonWidth, buttonWidth)];
    UIImage *cameraButtonImage = [UIImage imageNamed:@"cemra"];
    [cameraButton setBackgroundImage:cameraButtonImage forState:UIControlStateNormal];
    
    
    [cameraView addSubview:cameraButton];
    
    cameraButton.tag = 101;
    [cameraButton addTarget:self action:@selector(openCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    
//    if(self.selectionType != RBSingleImageSelectionType){
//  
//    }
    
    
    spinner=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner];
    [self.view addSubview:spinner];
    spinner.hidden =YES;
    
    spinner2=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner2];
    [self.view addSubview:spinner2];
    spinner2.hidden =YES;
    

    [self.assetCollection.view addSubview:spinner];
    [self.assetCollection.view addSubview:cameraView];
    [self.assetCollection.view addSubview:navigationView];
    
    [self pushViewController:self.assetCollection animated:NO];
    
    //view after using camera
    
    self.secondView = [[UIView alloc] initWithFrame: CGRectMake ( 0,20, self.view.frame.size.width, self.view.frame.size.height)];
    _secondView.backgroundColor = [UIColor whiteColor];
    
    // NavigationView
    
    UIView *navigationView2 = [[UIView alloc] initWithFrame: CGRectMake ( 0,0, self.view.frame.size.width, 44)];
    navigationView2.backgroundColor = [UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
    
   // CGFloat backbuttonWidth = navigationView2.frame.size.width * 0.125;
    
    
    backbutton2 = [[UIButton alloc]initWithFrame:CGRectMake(8, navigationView2.frame.size.height/2-backbuttonWidth/2 + 4, 35, 35)];
    UIImage *backButtonImage2 = [UIImage imageNamed:@"cross_white2"];
    [backbutton2 setBackgroundImage:backButtonImage2 forState:UIControlStateNormal];
    
    [navigationView2 addSubview:backbutton2];
    [backbutton2 addTarget:self action:@selector(onCancel:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.secondView addSubview:navigationView2];
    
    UILabel *titleLabel2 = [[UILabel alloc]initWithFrame:CGRectMake(backbuttonWidth+10, 0, navigationView2.frame.size.width-106, 44)];
    titleLabel2.text =@"Add Photo(s) Of This Feeding Room";
    titleLabel2.font =[UIFont fontWithName:@"Museo-500" size:17];
    titleLabel2.numberOfLines=0;
    titleLabel2.lineBreakMode=UILineBreakModeWordWrap;
    titleLabel2.textAlignment = UITextAlignmentCenter;
    titleLabel2.textColor = [UIColor whiteColor];
    [titleLabel setCenter:CGPointMake(navigationView.center.x, titleLabel.center.y)];
    //titleLabel.backgroundColor=[UIColor whiteColor];
    
    [navigationView2 addSubview:titleLabel2];

    spinner2=[[JTMaterialSpinner alloc] initWithFrame:CGRectMake(self.view.frame.size.width/2 - 17, self.view.frame.size.height/2 - 17, 35, 35)];
    [self.view bringSubviewToFront:spinner2];
    [self.view addSubview:spinner2];
    spinner2.hidden =YES;
    
    
    [self.view addSubview:spinner2];
    //imageView
    
    self.cameraImage =[[UIImageView alloc] initWithFrame:CGRectMake(0,44,self.view.frame.size.width,self.view.frame.size.height * 0.60)];
    self.cameraImage.userInteractionEnabled = YES;
    
    [self.secondView addSubview:_cameraImage];
    
    //textView
    
    //4. Create a UITextView.
    
//    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(20,self.view.frame.size.height * 0.60 +70,self.view.frame.size.width-40,100)];
//    _textView.layer.cornerRadius = 5.0;
//    _textView.scrollEnabled = YES;
//    _textView.editable = YES;
//    _textView.delegate = self;
//    _textView.backgroundColor=[UIColor hx_colorWithHexString:@"F5F8E9" alpha:1];
//
//    [self.secondView addSubview:_textView];
    
    //NextButton
    
    nextButton = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height * 0.60 + 140, self.view.frame.size.width-40, 44)];
    nextButton.backgroundColor =[UIColor hx_colorWithHexString:@"2CC55D" alpha:1.0];
    [nextButton setTitle:@"NEXT" forState:UIControlStateNormal];
    
    [self.secondView addSubview:nextButton];

    [nextButton addTarget:self action:@selector(nextButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.assetCollection.view addSubview:self.secondView];
    
    if (self.didSelectImage) {
        self.cameraImage.image = _chosenImage;
        self.secondView.hidden = NO;
        
        self.didSelectImage = NO;
    }else{
       self.secondView.hidden = YES;
    }
}



-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
    
    NSLog(@"Is it called");
}

//uiTextView delegate
//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    return NO;
//}

//- (BOOL)textViewShouldEndEditing:(UITextView *)textView
//{
//    return YES;
//}


//openCamera button action

-(void)openCamera:(id)sender{
    
    UIButton *btn = (UIButton *) sender;
    
   // NSLog(@"coloe no: %ld",(long)btn.tag);
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    [self presentViewController:picker animated:YES completion:NULL];
    
   

}

#pragma mark UIImagePickerControllerDelegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    
    
    self.chosenImage = info[UIImagePickerControllerEditedImage];
    
    
    self.didSelectImage = YES;
    
    NSLog(@"Image taken");
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    
   
    
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

-(void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}
/////////


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        self.didSelectImage = NO;
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor=[UIColor blackColor];
    [self.view addSubview:view];
    
    [self.navigationBar setTranslucent:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)onCancel:(id)sender{
    
    
    if([self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)])
        
        [self.delegate imagePickerControllerDidCancel:self];
   else
       [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)assignMaxSelectionCount{
    
//    if ([self.dataSource respondsToSelector:@selector(imagePickerControllerMaxSelectionCount:)]) {
//        
//         self.assetCollection.maxSelectionCount = [self.dataSource imagePickerControllerMaxSelectionCount:self];
        self.assetCollection.maxSelectionCount = 5;
//    }
//    else{
//        
//        self.assetCollection.maxSelectionCount = 0;
//        
//    }
}

-(void)assignMinSelectionCount{
    
    if ([self.dataSource respondsToSelector:@selector(imagePickerControllerMinSelectionCount:)]) {
        
        self.assetCollection.minSelectionCount = [self.dataSource imagePickerControllerMinSelectionCount:self];
        
    }
    else{
        
        self.assetCollection.minSelectionCount = 0;
        
    }
}

-(void)onUpload:(id)sender{
    
    uploadButton.userInteractionEnabled = NO;
    uploadButton.enabled=NO;
    
    backbutton.userInteractionEnabled = NO;
    backbutton.enabled=NO;
    
    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NSLog(@"status %ld",(long)status);
    
    if(status == NotReachable)
    {
        
        [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection & GPS." duration:2.0f];
        
    }
    else{
        
    [self finishPickingImages];
    
    spinner.hidden = NO;
    [spinner beginRefreshing];
    
    
    NSMutableArray *imageArray=[[ NSMutableArray alloc] initWithArray: [self.assetCollection getSelectedAssets]];
   // NSLog(@"imageArray %@",imageArray);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital",
                             @"room_id": self.roomId};
    
    NSLog(@"room id in photo up %@",self.roomId);
    NSLog(@"params in photo up %@",params);
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:[NSString stringWithFormat:@"%@feeding-room-images/api-add-room-image",baseUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        
        
        for (int i=0; i<imageArray.count; i++) {
            
            NSData *imageData = UIImageJPEGRepresentation([imageArray objectAtIndex:i], 0.5);
            
            if (i==0) {
                [formData appendPartWithFileData:imageData
                                            name:@"image"
                                        fileName:[NSString stringWithFormat:@"image.jpg"] mimeType:@"image/jpeg"];

            }
            else
            {
              
                
                [formData appendPartWithFileData:imageData
                                        name:[NSString stringWithFormat:@"image%i",i]
                                    fileName:[NSString stringWithFormat:@"image%i.jpg",i] mimeType:@"image/jpeg"];
            }
        }
            
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
        uploadButton.userInteractionEnabled = YES;
        uploadButton.enabled=YES;
        uploadButton.hidden =YES;
        
        backbutton.userInteractionEnabled = YES;
        backbutton.enabled=YES;
        
        
        titleLabel.text =@"Add Photo(s) Of This Feeding Room";
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        if([[responseObject objectForKey:@"success"] integerValue]==1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!"
                                  
                                                            message:@"Your photo has been uploaded"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
           
            [self.assetCollection removeSelectedAssets];
            [self.assetCollection.collectionView reloadData];
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        uploadButton.userInteractionEnabled = YES;
        uploadButton.enabled=YES;
        
        backbutton.userInteractionEnabled = YES;
        backbutton.enabled=YES;
       // NSLog(@"Error: %@", error);
        
        NSLog(@"error  %@",operation.response);
        
        spinner.hidden = YES;
        [spinner endRefreshing];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Problem occured when sending Picture"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];
    }
}

-(UIImage*)findLargeImage: (NSString*) mediaUrl
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 600, 600)];
    
    NSLog(@"Med.....%@",mediaUrl);
    
    ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
    [assetsLibrary assetForURL:[NSURL URLWithString:mediaUrl] resultBlock: ^(ALAsset *asset){
        ALAssetRepresentation *representation = [asset defaultRepresentation];
        CGImageRef imageRef = [representation fullResolutionImage];
        if (imageRef) {
           
            imageView.image = [UIImage imageWithCGImage:imageRef scale:representation.scale orientation:representation.orientation];
       
        }
    } failureBlock: ^(NSError *error){
        // Handle failure.
        NSLog(@"failed %@",error);
       
    }];
    
    if(imageView.image)
        return imageView.image;
    else
        return nil;
    
}

-(void)finishPickingImages{
    
    [self.delegate imagePickerController:self didFinishPickingImagesWithURL:[self.assetCollection getSelectedAssets]];
    
   // [self dismissViewControllerAnimated:YES completion:nil];
}

-(void) showUploadButton:(NSInteger)isMax
{
    if (isMax == 0){
    
      uploadButton.hidden = YES;
      titleLabel.text =@"Add Photo(s) Of This Feeding Room";
        
    }else if (isMax == 1) {
        
        uploadButton.hidden = NO;
        titleLabel.text = [NSString stringWithFormat:@"1 Photo Selected"];
        
    }else if (isMax<5) {
        
        uploadButton.hidden = NO;
        titleLabel.text = [NSString stringWithFormat:@"%d Photos Selected",isMax];
        
    }else if (isMax == 5){
        uploadButton.hidden = NO;
        titleLabel.text = [NSString stringWithFormat:@"%d Photos Selected(max.)",isMax];
        
    }
}

-(void)nextButtonAction:(id)sender{
    
    nextButton.userInteractionEnabled =NO;
    nextButton.enabled=NO;
    
    backbutton2.userInteractionEnabled = NO;
    backbutton2.enabled=NO;
    
    NSLog(@"next button clicked");
    
    //Network connection
    
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    NSLog(@"status %ld",(long)status);
    
    if(status == NotReachable)
    {
        
        [KSToastView ks_showToast:@"The app is currently offline. Please check your internet connection & GPS." duration:2.0f];
        
    }
    else{
    spinner2.hidden = NO;
    [spinner2 beginRefreshing];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *params = @{@"access_key": @"flowdigital",
                             @"room_id": self.roomId};
    
    NSLog(@"room id in photo up %@",self.roomId);
   // NSLog(@"params in photo up %@",params);
    //manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [manager POST:[NSString stringWithFormat:@"%@feeding-room-images/api-add-room-image",baseUrl] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
       
            NSData *imageData = UIImageJPEGRepresentation(self.cameraImage.image, 0.5);
            
        
                [formData appendPartWithFileData:imageData
                                            name:@"image"
                                        fileName:[NSString stringWithFormat:@"image.jpg"] mimeType:@"image/jpeg"];
                
        
        
        
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Response: %@", responseObject);
        
        nextButton.userInteractionEnabled =YES;
        nextButton.enabled=YES;
        
        backbutton2.userInteractionEnabled = YES;
        backbutton2.enabled=YES;
        
        spinner2.hidden = YES;
        [spinner2 endRefreshing];
        
        if([[responseObject objectForKey:@"success"] integerValue]==1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Thank you!"
                                  
                                                            message:@"Your photo has been uploaded"
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles: nil];
            [alert show];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
       // NSLog(@"Error: %@", error);
        
        spinner2.hidden = YES;
        [spinner2 endRefreshing];
        
        nextButton.userInteractionEnabled =YES;
        nextButton.enabled=YES;
        
        backbutton2.userInteractionEnabled = YES;
        backbutton2.enabled=YES;
        
        NSLog(@"error..............  %@",operation.responseString);
      
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                        message:@"Problem occured when sending Picture"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }];

    }
}


@end
