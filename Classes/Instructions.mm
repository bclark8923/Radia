//
//  Instructions.m
//  Fireballin
//
//  Created by Brian Clark on 4/10/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "Instructions.h"
#import "Options.h"
#import "SimpleAudioEngine.h"
#import "cocos2d.h"
#import "CCScrollLayer.h"


@implementation Instructions

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Instructions *layer = [Instructions node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        if(isIpad) {
            scale = 1024/480;
        } else {
            scale = 1;
        }
		screenSize = [[CCDirector sharedDirector] winSize];
		
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
        
		allItems = [[NSMutableArray arrayWithCapacity:51] retain];
        
        CCLayer *page = [[CCLayer alloc] init];
        CCSprite* instructionsOne;
        if(isIpad) {
            instructionsOne = [CCSprite spriteWithFile:@"HowToImage1-hd.png"];
        } else {
            instructionsOne = [CCSprite spriteWithFile:@"HowToImage1.png"];
        }
        
        instructionsOne.position = ccp(screenSize.width/2, screenSize.height/2);
        [page addChild:instructionsOne];
        
        CCLayer *page2 = [[CCLayer alloc] init];
        CCSprite* instructionsTwo;
        if(isIpad) {
            instructionsTwo = [CCSprite spriteWithFile:@"HowToImage2-hd.png"];
        } else {
            instructionsTwo = [CCSprite spriteWithFile:@"HowToImage2.png"];
        }
        instructionsTwo.position = ccp(screenSize.width/2, screenSize.height/2);
        [page2 addChild:instructionsTwo];
        
        CCLayer *page3 = [[CCLayer alloc] init];
        CCSprite* instructionsThree;
        if(isIpad) {
            instructionsThree = [CCSprite spriteWithFile:@"HowToImage3-hd.png"];
        } else {
            instructionsThree = [CCSprite spriteWithFile:@"HowToImage3.png"];
        }
        instructionsThree.position = ccp(screenSize.width/2, screenSize.height/2);
        [page3 addChild:instructionsThree];
        
        CCLayer *page4 = [[CCLayer alloc] init];
        CCSprite* instructionsFour;
        if(isIpad) {
            instructionsFour = [CCSprite spriteWithFile:@"HowToImage4-hd.png"];
        } else {
            instructionsFour = [CCSprite spriteWithFile:@"HowToImage4.png"];
        }
        instructionsFour.position = ccp(screenSize.width/2, screenSize.height/2);
        [page4 addChild:instructionsFour];
        
        CCLayer *page5 = [[CCLayer alloc] init];
        CCSprite* intructionsFive;
        if(isIpad) {
            intructionsFive = [CCSprite spriteWithFile:@"HowToImage5-hd.png"];
        } else {
            intructionsFive = [CCSprite spriteWithFile:@"HowToImage5.png"];
        }
        intructionsFive.position = ccp(screenSize.width/2, screenSize.height/2);
        [page5 addChild:intructionsFive];
        
        [allItems addObject:page];
        [allItems addObject:page2];
        [allItems addObject:page3];
        [allItems addObject:page4];
        [allItems addObject:page5];
		
		//SlidingMenuGrid* menuGrid = [SlidingMenuGrid menuWithArray:allItems cols:1 rows:1 position:CGPointMake(screenSize.width/2 + sprite_size/4, screenSize.height/2) padding:CGPointMake(0.f, 0.f) verticalPages:false];
        
        CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:allItems widthOffset: 0];
        
        // finally add the scroller to your scene
        [self addChild:scroller];
        
        //[menuGrid setICurrentPage:curWorld-1];
        //[menuGrid moveInstantToCurrentPage];
        //[menuGrid sendActionsForControlEvents: UIControlEventTouchUpInside];
        
        CCSprite* backSprite;
        CCSprite* backSelectedSprite;
        if (isIpad) {
            backSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
        } else {
            backSprite = [CCSprite spriteWithFile:@"BackButton.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
        }
		CCMenuItemSprite *backMenuItem = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSelectedSprite target:self selector:@selector(onOptions:)];
        if (isIpad) {
            backMenuItem.position = ccp(-screenSize.width/2 + 70, -screenSize.height/2 + 50 + litemodeOffset);
        } else {
            backMenuItem.position = ccp(-screenSize.width/2 + 35, -screenSize.height/2 + 25 + litemodeOffset);
        }
        
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
        [self addChild:backMenu]; 
        //[menuGrid addChild:menuItem1 z:1 tag:0];
        
        if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) { [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Decisions.mp3" loop:YES]; }	}
	return self;
}

- (void)onOptions:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on menu");
    Options *optionsLayer = [Options node];
    [self.parent addChild:optionsLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[Options node]];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[allItems release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
