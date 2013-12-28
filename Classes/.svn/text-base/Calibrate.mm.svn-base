//
//  Calibrate.m
//  Fireballin
//
//  Created by Brian Clark on 1/20/12.
//  Copyright (c) 2012 U of Michigan. All rights reserved.
//

#import "Calibrate.h"
#import "CCTouchDispatcher.h"
#import "CCLabelTTF.h"
#import	"FireBall.h"
#import	"Coin.h"
#import "MenuScene.h"
#import "PauseScene.h"
#import "GameOverScene.h"
#import "LevelOverScene.h"
#import "LevelWonScene.h"
#import "SpecialPushScene.h"
#import "Wall.h"
#import "GameCenterManager.h"
#import "AccelerometerSimulation.h"
#import "Options.h"

@implementation Calibrate

+ (id)scene {
    CCScene *scene = [CCScene node];
    Calibrate *layer = [Calibrate node];
    [scene addChild:layer];
    return scene;
}

-(id) init
{
    if( (self=[super init] ) != nil) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
		screenSize = [[CCDirector sharedDirector] winSize];
        
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
        
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
        
        CCSprite *creditsBg;
        if(isIpad) {
            creditsBg = [CCSprite spriteWithFile:@"CreditsBg-hd.png"];
            creditsBg.scaleY = 2;
        } else {
            creditsBg = [CCSprite spriteWithFile:@"CreditsBg.png"];
        }
        creditsBg.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:creditsBg z:-1];
        
        if(isIpad) {
            credits = [CCSprite spriteWithFile:@"Credits-hd.png"];
        } else {
            credits = [CCSprite spriteWithFile:@"Credits.png"];
        }
        credits.position = ccp(screenSize.width/2, 0-[credits boundingBox].size.height/2);
        creditsYpos = 0-[credits boundingBox].size.height/2;
        [self addChild:credits];
        
        [self schedule:@selector(update:)];
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
        touched = NO;
    }
    return self;
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    touched = YES;
    touchStartY = [touch locationInView:[touch view]].x;
    creditsStartYTouch = creditsYpos;
    return true;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {
    float newy = [touch locationInView:[touch view]].x;
    creditsYpos = creditsStartYTouch + newy - touchStartY;
    if(creditsYpos < -[credits boundingBox].size.height/2) {
        creditsYpos += [credits boundingBox].size.height + screenSize.height; 
    }
}

-(void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event{
    touched = NO;
}

- (void) update:(ccTime)dt {
    if(!touched) {
        creditsYpos += 40*dt;
    }
    if(creditsYpos > [credits boundingBox].size.height/2 + screenSize.height) creditsYpos = -[credits boundingBox].size.height/2;
    credits.position = ccp(screenSize.width/2, creditsYpos);
}


- (void)onOptions:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on options");
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
	[UIAccelerometer sharedAccelerometer].delegate = nil;
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
