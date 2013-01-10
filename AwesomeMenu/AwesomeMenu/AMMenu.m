//
//  AMMenu.m
//  AMMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import "AMMenu.h"
#import <QuartzCore/QuartzCore.h>

static CGFloat const kAwesomeMenuDefaultNearRadius = 110.0f;
static CGFloat const kAwesomeMenuDefaultEndRadius = 120.0f;
static CGFloat const kAwesomeMenuDefaultFarRadius = 140.0f;
static CGFloat const kAwesomeMenuDefaultStartPointX = 160.0;
static CGFloat const kAwesomeMenuDefaultStartPointY = 240.0;
static CGFloat const kAwesomeMenuDefaultTimeOffset = 0.036f;
static CGFloat const kAwesomeMenuDefaultRotateAngle = 0.0;
static CGFloat const kAwesomeMenuDefaultMenuWholeAngle = M_PI * 2;
static CGFloat const kAwesomeMenuDefaultMenuRotation = -M_PI_4;
static CGFloat const kAwesomeMenuDefaultExpandRotation = M_PI;
static CGFloat const kAwesomeMenuDefaultCloseRotation = M_PI * 2;


static CGPoint RotateCGPointAroundCenter(CGPoint point, CGPoint center, CGFloat angle)
{
	CGAffineTransform translation = CGAffineTransformMakeTranslation(center.x, center.y);
	CGAffineTransform rotation = CGAffineTransformMakeRotation(angle);
	CGAffineTransform transformGroup = CGAffineTransformConcat(CGAffineTransformConcat(CGAffineTransformInvert(translation), rotation), translation);
	return CGPointApplyAffineTransform(point, transformGroup);	
}

@interface AMMenu () <AMMenuItemDelegate>
{
	NSInteger	_flag;
	NSTimer		*_timer;
	AMMenuItem	*_menuButton;
	
	BOOL		_isAnimating;
}

- (void)_expand;
- (void)_close;
- (void)_setMenu;
- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p;
- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p;
@end

@implementation AMMenu

- (id)initWithFrame:(CGRect)frame menuItems:(NSArray *)menuItems
{
	self = [self initWithFrame: frame];
	
	if (self) {
		self.menuItems = menuItems;
	}

	return self;
}

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	
	if (self) {
		self.backgroundColor = [UIColor clearColor];
		
		self.nearRadius = kAwesomeMenuDefaultNearRadius;
		self.endRadius = kAwesomeMenuDefaultEndRadius;
		self.farRadius = kAwesomeMenuDefaultFarRadius;
		self.timeOffset = kAwesomeMenuDefaultTimeOffset;
		self.rotateAngle = kAwesomeMenuDefaultRotateAngle;
		self.menuWholeAngle = kAwesomeMenuDefaultMenuWholeAngle;
		self.startPoint = CGPointMake(kAwesomeMenuDefaultStartPointX, kAwesomeMenuDefaultStartPointY);
		self.menuRotation = kAwesomeMenuDefaultMenuRotation;
		self.expandRotation = kAwesomeMenuDefaultExpandRotation;
		self.closeRotation = kAwesomeMenuDefaultCloseRotation;
		
		// add the "Add" Button.
		_menuButton = [[AMMenuItem alloc] initWithImage:[UIImage imageNamed:@"AMMenuButton.png"]
									   highlightedImage:[UIImage imageNamed:@"AMMenuButton-highlighted.png"] 
										   contentImage:[UIImage imageNamed:@"AMPlusIcon.png"] 
								highlightedContentImage:[UIImage imageNamed:@"AMPlusIcon-highlighted.png"]];
		_menuButton.delegate = self;
		_menuButton.center = self.startPoint;
		[self addSubview:_menuButton];
		
		// Long press gesture recognizer
		UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
		[_menuButton addGestureRecognizer: longPress];
	}
	
	return self;
}


#pragma mark - getters & setters

- (void)setStartPoint:(CGPoint)aPoint
{
	_startPoint = aPoint;
	_menuButton.center = aPoint;
}

#pragma mark - images

- (void)setImage:(UIImage *)image {
	_menuButton.image = image;
}

- (UIImage *)image {
	return _menuButton.image;
}

- (void)setHighlightedImage:(UIImage *)highlightedImage {
	_menuButton.highlightedImage = highlightedImage;
}

- (UIImage *)highlightedImage {
	return _menuButton.highlightedImage;
}


- (void)setContentImage:(UIImage *)contentImage {
	_menuButton.contentImageView.image = contentImage;
}

- (UIImage *)contentImage {
	return _menuButton.contentImageView.image;
}

- (void)setHighlightedContentImage:(UIImage *)highlightedContentImage {
	_menuButton.contentImageView.highlightedImage = highlightedContentImage;
}

- (UIImage *)highlightedContentImage {
	return _menuButton.contentImageView.highlightedImage;
}

							   
#pragma mark - UIView's methods

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
	// if the menu is animating, prevent touches
	if (_isAnimating)
		return NO;
	
	// if the menu state is expanded, everywhere can be touch
	// otherwise, only the add button are can be touch
	if (YES == _expanded)
		return YES;
	
	else
		return CGRectContainsPoint(_menuButton.frame, point);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.expanded = !self.isExpanded;
}


#pragma mark - AMMenuItem delegates

- (void)menuItemTouchesBegan:(AMMenuItem *)item
{
	if (item == _menuButton)  {
		self.expanded = !self.isExpanded;
	}
}
- (void)menuItemTouchesEnded:(AMMenuItem *)item
{
	// exclude the "add" button
	if (item == _menuButton)  {
		return;
	}
	
	// blowup the selected menu button
	CAAnimationGroup *blowup = [self _blowupAnimationAtPoint:item.center];
	[item.layer addAnimation:blowup forKey:@"blowup"];
	item.center = item.startPoint;
	
	// shrink other menu buttons
	for (NSInteger i = 0; i < [_menuItems count]; i ++)
	{
		AMMenuItem *otherItem = [_menuItems objectAtIndex:i];
		CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
		if (otherItem.tag == item.tag) {
			continue;
		}
		[otherItem.layer addAnimation:shrink forKey:@"shrink"];

		otherItem.center = otherItem.startPoint;
	}
	_expanded = NO;
	
	// rotate "add" button
	CGFloat angle = self.isExpanded ? self.menuRotation : 0.0f;
	[UIView animateWithDuration:0.2f animations:^{
		_menuButton.transform = CGAffineTransformMakeRotation(angle);
	}];
	
	if ([_delegate respondsToSelector:@selector(awesomeMenu:didSelectItemAtIndex:)])
	{
		[_delegate awesomeMenu:self didSelectItemAtIndex:item.tag - 1000];
	}
}


#pragma mark - instant methods

- (void)setMenuItems:(NSArray *)menuItems
{	
	if (menuItems == _menuItems)
	{
		return;
	}
	_menuItems = [menuItems copy];
	
	
	// clean subviews
	for (UIView *v in self.subviews) 
	{
		if (v.tag >= 1000) 
		{
			[v removeFromSuperview];
		}
	}
}


- (void)_setMenu {
	NSInteger count = [_menuItems count];
	for (NSInteger i = 0; i < count; i ++)
	{
		AMMenuItem *item = [_menuItems objectAtIndex:i];
		item.tag = 1000 + i;
		item.startPoint = _startPoint;
		CGPoint endPoint = CGPointMake(_startPoint.x + _endRadius * sinf(i * _menuWholeAngle / count), _startPoint.y - _endRadius * cosf(i * _menuWholeAngle / count));
		item.endPoint = RotateCGPointAroundCenter(endPoint, _startPoint, _rotateAngle);
		CGPoint nearPoint = CGPointMake(_startPoint.x + _nearRadius * sinf(i * _menuWholeAngle / count), _startPoint.y - _nearRadius * cosf(i * _menuWholeAngle / count));
		item.nearPoint = RotateCGPointAroundCenter(nearPoint, _startPoint, _rotateAngle);
		CGPoint farPoint = CGPointMake(_startPoint.x + _farRadius * sinf(i * _menuWholeAngle / count), _startPoint.y - _farRadius * cosf(i * _menuWholeAngle / count));
		item.farPoint = RotateCGPointAroundCenter(farPoint, _startPoint, _rotateAngle);
		item.center = item.startPoint;
		item.delegate = self;
		[self insertSubview:item belowSubview:_menuButton];
	}
}

- (void)setExpanded:(BOOL)expanded
{
	if (expanded) {
		[self _setMenu];
	}
	
	_expanded = expanded;	
	
	// rotate add button
	CGFloat angle = self.isExpanded ? self.menuRotation : 0.0f;
	[UIView animateWithDuration:0.2f animations:^{
		_menuButton.transform = CGAffineTransformMakeRotation(angle);
	}];
	
	// expand or close animation
	if (!_timer) 
	{
		_flag = self.isExpanded ? 0 : ([_menuItems count] - 1);
		SEL selector = self.isExpanded ? @selector(_expand) : @selector(_close);

		// Adding timer to runloop to make sure UI event won't block the timer from firing
		_timer = [NSTimer timerWithTimeInterval:_timeOffset target:self selector:selector userInfo:nil repeats:YES];
		[[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
		_isAnimating = YES;
	}
}


#pragma mark - private methods

- (void)_expand
{
	
	if (_flag == [_menuItems count])
	{
		_isAnimating = NO;
		[_timer invalidate];
		_timer = nil;
		return;
	}
	
	NSInteger tag = 1000 + _flag;
	AMMenuItem *item = (AMMenuItem *)[self viewWithTag:tag];
	
	CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:_expandRotation],[NSNumber numberWithFloat:0.0f], nil];
	rotateAnimation.duration = 0.5f;
	rotateAnimation.keyTimes = [NSArray arrayWithObjects:
								[NSNumber numberWithFloat:.3], 
								[NSNumber numberWithFloat:.4], nil]; 
	
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	positionAnimation.duration = 0.5f;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
	CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
	CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y); 
	CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y); 
	positionAnimation.path = path;
	CGPathRelease(path);
	
	CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
	animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
	animationgroup.duration = 0.5f;
	animationgroup.fillMode = kCAFillModeForwards;
	animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	animationgroup.delegate = self;
	if (_flag == [_menuItems count] - 1) {
		[animationgroup setValue:@"firstAnimation" forKey:@"id"];
	}
	
	[item.layer addAnimation:animationgroup forKey:@"Expand"];
	item.center = item.endPoint;
	
	_flag ++;
	
}

- (void)_close
{
	if (_flag == -1)
	{
		_isAnimating = NO;
		[_timer invalidate];
		_timer = nil;
		return;
	}
	
	NSInteger tag = 1000 + _flag;
	 AMMenuItem *item = (AMMenuItem *)[self viewWithTag:tag];
	
	CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
	rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:_closeRotation],[NSNumber numberWithFloat:0.0f], nil];
	rotateAnimation.duration = 0.5f;
	rotateAnimation.keyTimes = [NSArray arrayWithObjects:
								[NSNumber numberWithFloat:.0], 
								[NSNumber numberWithFloat:.4],
								[NSNumber numberWithFloat:.5], nil]; 
		
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	positionAnimation.duration = 0.5f;
	CGMutablePathRef path = CGPathCreateMutable();
	CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
	CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
	CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y); 
	positionAnimation.path = path;
	CGPathRelease(path);
	
	CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
	animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, rotateAnimation, nil];
	animationgroup.duration = 0.5f;
	animationgroup.fillMode = kCAFillModeForwards;
	animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
	animationgroup.delegate = self;
	if (_flag == 0) {
		[animationgroup setValue:@"lastAnimation" forKey:@"id"];
	}
	
	[item.layer addAnimation:animationgroup forKey:@"Close"];
	item.center = item.startPoint;

	_flag --;
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
	if ([[anim valueForKey:@"id"] isEqual:@"lastAnimation"]) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(aweseomeMenuDidClose:)]) {
			[self.delegate aweseomeMenuDidClose:self];
		}
	}
	if ([[anim valueForKey:@"id"] isEqual:@"firstAnimation"]) {
		if (self.delegate && [self.delegate respondsToSelector:@selector(aweseomeMenuDidOpen:)]) {
			[self.delegate aweseomeMenuDidOpen:self];
		}
	}
}

- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p
{
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
	positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil]; 
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(3, 3, 1)];
	
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
	
	CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
	animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
	animationgroup.duration = 0.3f;
	animationgroup.fillMode = kCAFillModeForwards;

	return animationgroup;
}

- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p
{
	CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
	positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil]; 
	
	CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
	scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(.01, .01, 1)];
	
	CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
	opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
	
	CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
	animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
	animationgroup.duration = 0.3f;
	animationgroup.fillMode = kCAFillModeForwards;
	
	return animationgroup;
}


@end
