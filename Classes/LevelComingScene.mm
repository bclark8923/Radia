//
//  LevelComingScene.m
//  Fireballin
//
//  Created by Brian Clark on 4/13/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "LevelComingScene.h"
#import "MenuScene.h"


@implementation LevelComingScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelComingScene *layer = [LevelComingScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    if( (self=[super init] )) {
        //set splash image
        screenSize = [[CCDirector sharedDirector] winSize];

        splashImg = [CCSprite spriteWithFile:@"LevelComingSoon.png"];
        CCSprite* splashImgSelected = [CCSprite spriteWithFile:@"LevelComingSoon.png"];
        /*splashImg.position = ccp(screenSize.width/2,screenSize.height/2);
        [self addChild:splashImg z:2];
        
        CCSprite* normalSprite = [CCSprite spriteWithFile:@"BackButton.png"];
        CCSprite* selectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
		CCMenuItemSprite *menuItem = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(onMenu:)];
        
		CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
		menu.position = ccp(35,25);
		[menu alignItemsVertically];*/
        
        CCMenuItemSprite *menuItem = [CCMenuItemSprite itemFromNormalSprite:splashImg selectedSprite:splashImgSelected target:self selector:@selector(onMenu:)];
        
		CCMenu *menu = [CCMenu menuWithItems:menuItem, nil];
		menu.position = ccp(screenSize.width/2,screenSize.height/2);
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
