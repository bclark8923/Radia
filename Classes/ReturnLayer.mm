//
//  ReturnLayer.m
//  Fireballin
//
//  Created by Brian Clark on 4/8/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "ReturnLayer.h"
#import "MenuScene.h"

@implementation ReturnLayer

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	ReturnLayer *layer = [ReturnLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init] )) {
        CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"Menu" target:self selector:@selector(onMenu:)];
		
		CCMenu *menu = [CCMenu menuWithItems:menuItem1, nil];
		menu.position = ccp(-20,-250);
		[menu alignItemsVertically];
		[self addChild:menu];
    }
    return self;
}

- (void)onMenu:(id)sender
{
	NSLog(@"on menu");
	[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}

@end
