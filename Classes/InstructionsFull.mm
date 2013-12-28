//
//  InstructionsFull.m
//  Fireballin
//
//  Created by Brian Clark on 1/17/12.
//  Copyright (c) 2012 U of Michigan. All rights reserved.
//

#import "InstructionsFull.h"
#import "MenuScene.h"
#import "SimpleAudioEngine.h"
#import "CCScrollLayer.h"
#import "cocos2d.h"

@implementation InstructionsFull

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	InstructionsFull *layer = [InstructionsFull node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init] )) {
		screenSize = [[CCDirector sharedDirector] winSize];
		
		NSMutableArray* allItems = [[NSMutableArray arrayWithCapacity:51] retain];

        CCLayer *page = [[CCLayer alloc] init];
        CCSprite* instructionsOne = [CCSprite spriteWithFile:@"SurvivalModeInstructions.png"];
        [page addChild:instructionsOne];
        
        CCLayer *page2 = [[CCLayer alloc] init];
        CCSprite* instructionsTwo = [CCSprite spriteWithFile:@"LevelModeInstructions.png"];
        [page2 addChild:instructionsTwo];
        
        [allItems addObject:page2];
        [allItems addObject:page];
		
		//SlidingMenuGrid* menuGrid = [SlidingMenuGrid menuWithArray:allItems cols:1 rows:1 position:CGPointMake(screenSize.width/2 + sprite_size/4, screenSize.height/2) padding:CGPointMake(0.f, 0.f) verticalPages:false];
        
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:allItems widthOffset: 0];
        
        // finally add the scroller to your scene
        [self addChild:scroller];
        
        //[menuGrid setICurrentPage:curWorld-1];
        //[menuGrid moveInstantToCurrentPage];
        //[menuGrid sendActionsForControlEvents: UIControlEventTouchUpInside];
        
        CCSprite* normalSprite = [CCSprite spriteWithFile:@"BackButton.png"];
        CCSprite* selectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
		CCMenuItemSprite *menuItem1 = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(onMenu:)];
        menuItem1.position = ccp(-screenSize.width/2 + 35, -screenSize.height/2 + 25);
        
        CCMenu *backMenu = [CCMenu menuWithItems:menuItem1, nil];
        [self addChild:backMenu]; 
        //[menuGrid addChild:menuItem1 z:1 tag:0];
        
        if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) { [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Decisions.mp3" loop:YES]; }
        
	}
	return self;
}

- (void)onMenu:(id)sender
{
	NSLog(@"on menu");
	[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
