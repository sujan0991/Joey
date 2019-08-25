//
//  RBImagePickerController.h
//  RBImagePicker
//
//  Created by Roshan Balaji on 1/31/14.
//  Copyright (c) 2014 Uniq Labs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RBImagePickerDelegate.h"
#import "RBImagePickerDataSource.h"
//#import "RBImagePickerController.h"
#import <AFNetworking.h>
#import <AssetsLibrary/AssetsLibrary.h>


typedef enum {
    
    RBSingleImageSelectionType,
    RBMultipleImageSelectionType
    
} RBSelectionType;

typedef void (^ALAssetsLibraryAssetForURLResultBlock)(ALAsset *asset);
typedef void (^ALAssetsLibraryAccessFailureBlock)(NSError *error);

@interface RBImagePickerController : UINavigationController<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextViewDelegate>


@property(nonatomic, weak) id<RBImagePickerDelegate, UINavigationControllerDelegate>delegate;
@property(nonatomic, weak) id<RBImagePickerDataSource, UINavigationControllerDelegate>dataSource;
@property(nonatomic) RBSelectionType selectionType;

@property NSString *roomId;

-(void)finishPickingImages;
-(void) showUploadButton:(NSInteger)isMax;
@end

