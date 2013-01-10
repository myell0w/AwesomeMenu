//
//  AMMenu.h
//  AMMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import "AMMenuItem.h"

@protocol AMMenuDelegate;


@interface AMMenu : UIView

- (id)initWithFrame:(CGRect)frame menuItems:(NSArray *)items;

@property (nonatomic, copy) NSArray *menuItems;
@property (nonatomic, getter=isExpanding) BOOL expanding;
@property (nonatomic, unsafe_unretained) id<AMMenuDelegate> delegate;

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, strong) UIImage *contentImage;
@property (nonatomic, strong) UIImage *highlightedContentImage;

@property (nonatomic, assign) CGFloat nearRadius;
@property (nonatomic, assign) CGFloat endRadius;
@property (nonatomic, assign) CGFloat farRadius;
@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) CGFloat timeOffset;
@property (nonatomic, assign) CGFloat rotateAngle;
@property (nonatomic, assign) CGFloat menuWholeAngle;
@property (nonatomic, assign) CGFloat expandRotation;
@property (nonatomic, assign) CGFloat closeRotation;

@end


@protocol AMMenuDelegate <NSObject>

- (void)awesomeMenu:(AMMenu *)menu didSelectItemAtIndex:(NSInteger)idx;

@optional
- (void)aweseomeMenuDidClose:(AMMenu *)menu;
- (void)aweseomeMenuDidOpen:(AMMenu *)menu;

@end