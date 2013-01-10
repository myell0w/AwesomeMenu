//
//  AppDelegate.m
//  AMMenu
//
//  Created by Levey on 11/30/11.
//  Copyright (c) 2011 Levey & Other Contributors. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIImage *storyMenuItemImage = [UIImage imageNamed:@"bg-menuitem.png"];
    UIImage *storyMenuItemImagePressed = [UIImage imageNamed:@"bg-menuitem-highlighted.png"];
    
    UIImage *starImage = [UIImage imageNamed:@"icon-star.png"];

    AMMenuItem *starMenuItem1 = [[AMMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage 
                                                        highlightedContentImage:nil];
    AMMenuItem *starMenuItem2 = [[AMMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage 
                                                        highlightedContentImage:nil];
    AMMenuItem *starMenuItem3 = [[AMMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage 
                                                        highlightedContentImage:nil];
    AMMenuItem *starMenuItem4 = [[AMMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage 
                                                        highlightedContentImage:nil];
    AMMenuItem *starMenuItem5 = [[AMMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage
                                                        highlightedContentImage:nil];
    AMMenuItem *starMenuItem6 = [[AMMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage
                                                        highlightedContentImage:nil];
    AMMenuItem *starMenuItem7 = [[AMMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage
                                                        highlightedContentImage:nil];
    AMMenuItem *starMenuItem8 = [[AMMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage
                                                        highlightedContentImage:nil];
    AMMenuItem *starMenuItem9 = [[AMMenuItem alloc] initWithImage:storyMenuItemImage
                                                               highlightedImage:storyMenuItemImagePressed 
                                                                   contentImage:starImage
                                                        highlightedContentImage:nil];
    
    NSArray *menus = [NSArray arrayWithObjects:starMenuItem1, starMenuItem2, starMenuItem3, starMenuItem4, starMenuItem5, starMenuItem6, starMenuItem7,starMenuItem8,starMenuItem9, nil];
    [starMenuItem1 release];
    [starMenuItem2 release];
    [starMenuItem3 release];
    [starMenuItem4 release];
    [starMenuItem5 release];
    [starMenuItem6 release];
    [starMenuItem7 release];
    [starMenuItem8 release];
    [starMenuItem9 release];
    
    AMMenu *menu = [[AMMenu alloc] initWithFrame:self.window.bounds menuItems:menus];
    
	// customize menu
	/*
	menu.rotateAngle = M_PI/3;
	menu.menuWholeAngle = M_PI;
	menu.timeOffset = 0.2f;
	menu.farRadius = 180.0f;
	menu.endRadius = 100.0f;
	menu.nearRadius = 50.0f;
	*/
	
    menu.delegate = self;
    [self.window addSubview:menu];
    [menu release];
    
    [self.window makeKeyAndVisible];
    return YES;
}


/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇ GET RESPONSE OF MENU ⬇⬇⬇⬇⬇⬇ */
/* ⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇⬇ */

- (void)awesomeMenu:(AMMenu *)menu didSelectItemAtIndex:(NSInteger)idx
{
    NSLog(@"Select the index : %d",idx);
}
- (void)aweseomeMenuDidClose:(AMMenu *)menu {
    NSLog(@"Menu was closed!");
}
- (void)aweseomeMenuDidOpen:(AMMenu *)menu {
    NSLog(@"Menu is open!");
}
@end
