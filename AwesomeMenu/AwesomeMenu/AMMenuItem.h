//
//  AMMenuItem.h
//  AMMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AMMenuItemDelegate;

@interface AMMenuItem : UIImageView
{
    UIImageView *_contentImageView;
    CGPoint _startPoint;
    CGPoint _endPoint;
    CGPoint _nearPoint; // near
    CGPoint _farPoint; // far
    
    id<AMMenuItemDelegate> _delegate;
}

@property (nonatomic, retain, readonly) UIImageView *contentImageView;

@property (nonatomic) CGPoint startPoint;
@property (nonatomic) CGPoint endPoint;
@property (nonatomic) CGPoint nearPoint;
@property (nonatomic) CGPoint farPoint;

@property (nonatomic, assign) id<AMMenuItemDelegate> delegate;

- (id)initWithImage:(UIImage *)img 
   highlightedImage:(UIImage *)himg
       contentImage:(UIImage *)cimg
highlightedContentImage:(UIImage *)hcimg;


@end

@protocol AMMenuItemDelegate <NSObject>
- (void)AMMenuItemTouchesBegan:(AMMenuItem *)item;
- (void)AMMenuItemTouchesEnd:(AMMenuItem *)item;
@end