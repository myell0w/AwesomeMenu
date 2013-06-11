//
//  AMMenuItem.m
//  AMMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import "AMMenuItem.h"
static inline CGRect ScaleRect(CGRect rect, CGFloat n) {return CGRectMake((rect.size.width - rect.size.width * n)/ 2, (rect.size.height - rect.size.height * n) / 2, rect.size.width * n, rect.size.height * n);}


@implementation AMMenuItem

+ (id)itemWithContentImage:(UIImage *)image action:(SEL)action
{
	AMMenuItem *item = [[self alloc] initWithImage:[UIImage imageNamed: @"AMMenuItem.png"]
								  highlightedImage:[UIImage imageNamed: @"AMMenuItem-highlighted.png"]
									  contentImage:image highlightedContentImage:nil];
	item.action = action;
	return item;
}

- (id)initWithImage:(UIImage *)img highlightedImage:(UIImage *)himg contentImage:(UIImage *)cimg highlightedContentImage:(UIImage *)hcimg
{
	if (self = [super init]) 
	{
		self.image = img;
		self.highlightedImage = himg;
		self.userInteractionEnabled = YES;
		_contentImageView = [[UIImageView alloc] initWithImage:cimg];
		_contentImageView.highlightedImage = hcimg;
		[self addSubview:_contentImageView];
	}
	return self;
}


#pragma mark - UIView's methods

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	self.bounds = CGRectMake(0, 0, self.image.size.width, self.image.size.height);
	
	CGFloat width = _contentImageView.image.size.width;
	CGFloat height = _contentImageView.image.size.height;
	_contentImageView.frame = CGRectMake(self.bounds.size.width/2 - width/2, self.bounds.size.height/2 - height/2, width, height);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.highlighted = YES;
	if ([_delegate respondsToSelector:@selector(menuItemTouchesBegan:)])
	{
	   [_delegate menuItemTouchesBegan:self];
	}
	
}
- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	// if move out of 2x rect, cancel highlighted.
	CGPoint location = [[touches anyObject] locationInView:self];
	if (!CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
	{
		self.highlighted = NO;
	}
	
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.highlighted = NO;
	// if stop in the area of 2x rect, response to the touches event.
	CGPoint location = [[touches anyObject] locationInView:self];
	if (CGRectContainsPoint(ScaleRect(self.bounds, 2.0f), location))
	{
		if ([_delegate respondsToSelector:@selector(menuItemTouchesEnded:)])
		{
			[_delegate menuItemTouchesEnded:self];
		}
	}
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	self.highlighted = NO;
}


#pragma mark - instant methods

- (void)setHighlighted:(BOOL)highlighted
{
	[super setHighlighted:highlighted];
	[_contentImageView setHighlighted:highlighted];
}


@end
