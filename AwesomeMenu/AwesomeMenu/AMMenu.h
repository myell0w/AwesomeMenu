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

@property(nonatomic, copy) NSArray *menuItems;
@property(nonatomic, getter=isExpanded) BOOL expanded;
@property(nonatomic, readonly, getter=isAnimating) BOOL animating;

@property(nonatomic, unsafe_unretained) id<AMMenuDelegate> delegate;
@property(nonatomic, weak) id target;

@property(nonatomic) UIImage *image;
@property(nonatomic) UIImage *highlightedImage;
@property(nonatomic) UIImage *contentImage;
@property(nonatomic) UIImage *highlightedContentImage;

@property(nonatomic) CGFloat nearRadius;
@property(nonatomic) CGFloat endRadius;
@property(nonatomic) CGFloat farRadius;
@property(nonatomic) CGPoint startPoint;
@property(nonatomic) CGFloat timeOffset;
@property(nonatomic) CGFloat rotateAngle;
@property(nonatomic) CGFloat menuWholeAngle;
@property(nonatomic) CGFloat menuRotation;
@property(nonatomic) CGFloat expandRotation;
@property(nonatomic) CGFloat closeRotation;
@property(nonatomic) CGFloat expandDuration;
@property(nonatomic) CGFloat closeDuration;

- (void)removeVisibleItems;

@end


@protocol AMMenuDelegate <NSObject>

- (void)awesomeMenu:(AMMenu *)menu didSelectItemAtIndex:(NSInteger)idx;

@optional
- (void)aweseomeMenuDidClose:(AMMenu *)menu;
- (void)aweseomeMenuDidOpen:(AMMenu *)menu;

@end