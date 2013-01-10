//
//  AMMenuItem.h
//  AMMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

@protocol AMMenuItemDelegate;


@interface AMMenuItem : UIImageView

- (id)initWithImage:(UIImage *)img highlightedImage:(UIImage *)himg contentImage:(UIImage *)cimg highlightedContentImage:(UIImage *)hcimg;

@property(nonatomic, readonly) UIImageView *contentImageView;

@property(nonatomic) CGPoint startPoint;
@property(nonatomic) CGPoint endPoint;
@property(nonatomic) CGPoint nearPoint;
@property(nonatomic) CGPoint farPoint;

@property(nonatomic, unsafe_unretained) id<AMMenuItemDelegate> delegate;

@end


@protocol AMMenuItemDelegate <NSObject>

- (void)menuItemTouchesBegan:(AMMenuItem *)item;
- (void)menuItemTouchesEnded:(AMMenuItem *)item;

@end