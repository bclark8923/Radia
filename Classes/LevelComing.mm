//
//  LevelComing.m
//  Fireballin
//
//  Created by Brian Clark on 5/25/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "LevelComing.h"
#import "MenuScene.h"
#import "SimpleAudioEngine.h"
#import "MainMEnu.h"

@implementation LevelComing

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelComing *layer = [LevelComing node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        //set splash image
        screenSize = [[CCDirector sharedDirector] winSize];
        
        splashImg = [CCSprite spriteWithFile:@"RadiaSplash.png"];
        //CCSprite* splashImgSelected = [CCSprite spriteWithFile:@"LevelComingSoon.png"];
        splashImg.position = ccp(screenSize.width/2,screenSize.height/2);
         [self addChild:splashImg z:-2];
         
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
        
         CCSprite* normalSprite = [CCSprite spriteWithFile:@"BackButton.png"];
         CCSprite* selectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
         CCMenuItemSprite *menuItem = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(onMenu:)];
         
         CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
         menu.position = ccp(35,25 + litemodeOffset);
         [menu alignItemsVertically];
        
        /*CCMenuItemSprite *menuItem = [CCMenuItemSprite itemFromNormalSprite:splashImg selectedSprite:splashImgSelected target:self selector:@selector(onMenu:)];
        
		CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
		menu.position = ccp(screenSize.width/2,screenSize.height/2);
		[menu alignItemsVertically];
        */
		[self addChild:menu];
    }
    return self;
}


- (void)onMenu:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on menu");
	[[CCDirector sharedDirector] replaceScene:[[MainMenu node] initLevelOver:1]];
}


@end
