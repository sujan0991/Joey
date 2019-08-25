//
//  SKSTableViewCell.m
//  SKSTableView
//
//  Created by Sakkaras on 26/12/13.
//  Copyright (c) 2013 Sakkaras. All rights reserved.
//

#import "SKSTableViewCell.h"
#import "SKSTableViewCellIndicator.h"
#import "HexColors.h"

#define kIndicatorViewTag -1

@interface SKSTableViewCell (){

    BOOL btnSelect;
    UIButton *button;
    UIImage *BtnImage;
}

@end

@implementation SKSTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.expandable = YES;
        self.expanded = NO;
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    
    if (self.isExpanded) {
        
   //     [button setBackgroundImage:_image2 forState:UIControlStateNormal];
        
        if (![self containsIndicatorView])
            [self addIndicatorView];
        else {
            [self removeIndicatorView];
            [self addIndicatorView];
        }
    }else{
 //    [button setBackgroundImage:_image1 forState:UIControlStateNormal];
    }
}

static UIImage *_image1 = nil;
static UIImage *_image2 = nil;

- (UIView *)expandableView
{
//    if (!_image1) {
//        //_image = [UIImage imageNamed:@"expandableImage.png"];
//        _image1 = [UIImage imageNamed:@"rp.png"];
//        _image2 = [UIImage imageNamed:@"rm.png"];
//    }
    
 
//    //UIButton *
//    button = [UIButton buttonWithType:UIButtonTypeCustom];
//    //CGRect frame = CGRectMake(0.0, 0.0, _image.size.width, _image.size.height);
//    CGRect frame = CGRectMake(0.0, 0.0, 37,27);
//    button.frame = frame;
//    [button setBackgroundImage:_image1 forState:UIControlStateNormal];
//
    
    return button;
}

- (void)setExpandable:(BOOL)isExpandable
{
    if (isExpandable)
        [self setAccessoryView:[self expandableView]];
    
    _expandable = isExpandable;
    
}

//- (void)setSelected:(BOOL)selected animated:(BOOL)animated
//{
//    [super setSelected:selected animated:animated];
//    
//
//}

- (void)addIndicatorView
{
//    CGPoint point = self.accessoryView.center;
//    CGRect bounds = self.accessoryView.bounds;
//    
//    CGRect frame = CGRectMake((point.x - CGRectGetWidth(bounds) * 1.5), point.y * 1.4, CGRectGetWidth(bounds) * 3.0, CGRectGetHeight(self.bounds) - point.y * 1.4);
//    SKSTableViewCellIndicator *indicatorView = [[SKSTableViewCellIndicator alloc] initWithFrame:frame];
//    indicatorView.tag = kIndicatorViewTag;
//    [self.contentView addSubview:indicatorView];
}

- (void)removeIndicatorView
{
    id indicatorView = [self.contentView viewWithTag:kIndicatorViewTag];
    if (indicatorView)
    {
        [indicatorView removeFromSuperview];
        indicatorView = nil;
    }
}

- (BOOL)containsIndicatorView
{
    return [self.contentView viewWithTag:kIndicatorViewTag] ? YES : NO;
}

- (void)accessoryViewAnimation
{
//    [UIView animateWithDuration:0.2 animations:^{
//        if (self.isExpanded) {
//            
//            self.accessoryView.transform = CGAffineTransformMakeRotation(M_PI);
//            
//        } else {
//            self.accessoryView.transform = CGAffineTransformMakeRotation(0);
//        }
//    } completion:^(BOOL finished) {
//        
//        if (!self.isExpanded)
//            [self removeIndicatorView];
//        
//    }];
    
}
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    self.numberButton.highlighted = NO;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    
    
    [super setSelected:selected animated:animated];
    
    self.numberButton.selected = NO;
    // If you don't set highlighted to NO in this method,
    // for some reason it'll be highlighed while the
    // table cell selection animates out
    self.numberButton.highlighted = NO;
    
//    UIView *bgColorView = [[UIView alloc] init];
//    bgColorView.backgroundColor = [UIColor hx_colorWithHexString:@"F7F9ED" alpha:1];
//    [self setSelectedBackgroundView:bgColorView];
    
}


@end
