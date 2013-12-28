//
//  Difficulty.m
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Difficulty.h"
#import "GameScene.h"
#import "MenuScene.h"
#import "Highscores.h"
#import "HighScoreSelector.h"
#import "SimpleAudioEngine.h"
#import "GameCenterManager.h"
#import "SurvivalSelector.h"
#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@implementation Difficulty

//#define LITEMODE

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Difficulty *layer = [Difficulty node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) initWithMode:(GameMode) mode
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        
        gameMode = mode;
		screenSize = [[CCDirector sharedDirector] winSize];
		//CCLabelTTF *title = [CCLabelTTF labelWithString:@"Difficulty" fontName:@"Futura" fontSize:50];
        CCSprite* title;
        if(isIpad) {
            title = [CCSprite spriteWithFile:@"Difficulty-hd.png"];
        } else {
            title = [CCSprite spriteWithFile:@"Difficulty.png"];
        }
		title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/6);
		//title.color = ccc3(250, 0, 0);
		[self addChild:title];
        
        CCSprite* normalSprite1;
        CCSprite* selectedSprite1;
        
        if(isIpad) {
            normalSprite1 = [CCSprite spriteWithFile:@"EasyMenu-hd.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"EasyMenu-hd.png"];
        } else {
            normalSprite1 = [CCSprite spriteWithFile:@"EasyMenu.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"EasyMenu.png"];
        }
        
        CCSprite* normalSprite2;
        CCSprite* selectedSprite2;
        
        if(isIpad) {
            normalSprite2 = [CCSprite spriteWithFile:@"MediumMenu-hd.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"MediumMenu-hd.png"];
        } else {
            normalSprite2 = [CCSprite spriteWithFile:@"MediumMenu.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"MediumMenu.png"];
        }
        
        CCSprite* normalSprite3;
        CCSprite* selectedSprite3;
        
        if(isIpad) {
            normalSprite3 = [CCSprite spriteWithFile:@"HardMenu-hd.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"HardMenu-hd.png"];
        } else {
            normalSprite3 = [CCSprite spriteWithFile:@"HardMenu.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"HardMenu.png"];
        }
        
        CCSprite* normalSprite4;
        CCSprite* selectedSprite4;
        
        if(isIpad) {
            normalSprite4 = [CCSprite spriteWithFile:@"ExtremeMenu-hd.png"];
            selectedSprite4 = [CCSprite spriteWithFile:@"ExtremeMenu-hd.png"];
        } else {
            normalSprite4 = [CCSprite spriteWithFile:@"ExtremeMenu.png"];
            selectedSprite4 = [CCSprite spriteWithFile:@"ExtremeMenu.png"];
        }
        
        CCMenuItemSprite *menuItem1 = [CCMenuItemSprite itemFromNormalSprite:normalSprite1 selectedSprite:selectedSprite1 target:self selector:@selector(onEasy:)];
        CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite2 selectedSprite:selectedSprite2 target:self selector:@selector(onMedium:)];
		CCMenuItemSprite *menuItem3 = [CCMenuItemSprite itemFromNormalSprite:normalSprite3 selectedSprite:selectedSprite3 target:self selector:@selector(onHard:)];
		CCMenuItemSprite *menuItem4 = [CCMenuItemSprite itemFromNormalSprite:normalSprite4 selectedSprite:selectedSprite4 target:self selector:@selector(onExtreme:)];
        
#ifndef LITEMODE
		CCMenu *menu4 = [CCMenu menuWithItems:menuItem3, menuItem4, nil];
		menu4.position = ccp(screenSize.width - [normalSprite2 boundingBox].size.width/2, screenSize.height/4 + 60.0f);
		[menu4 alignItemsVerticallyWithPadding:0];
		[self addChild:menu4];
#endif
        
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
		CCMenu *menu5 = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
		menu5.position = ccp([normalSprite2 boundingBox].size.width/2, screenSize.height/4 + 60.0f + litemodeOffset);
		[menu5 alignItemsVerticallyWithPadding:0];
		[self addChild:menu5];
		
		CCSprite* backSprite;
        CCSprite* backSelectedSprite;
        if (isIpad) {
            backSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
        } else {
            backSprite = [CCSprite spriteWithFile:@"BackButton.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
        }
		CCMenuItemSprite *backMenuItem = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSelectedSprite target:self selector:@selector(onMenu:)];
        if (isIpad) {
            backMenuItem.position = ccp(-screenSize.width/2 + 70, -screenSize.height/2 + 50 + litemodeOffset);
        } else {
            backMenuItem.position = ccp(-screenSize.width/2 + 35, -screenSize.height/2 + 25 + litemodeOffset);
        }
        
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
		[self addChild:backMenu];
        
        if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) { [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Decisions.mp3" loop:YES]; }
	}
	return self;
}

- (void)onEasy:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on easy");
    [self removeAdView];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:EASY setMode:gameMode levelNum:1 worldNum:1]]];
}

- (void)onMedium:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on medium");
    [self removeAdView];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:MEDIUM setMode:gameMode levelNum:1 worldNum:1]]];
}

- (void)onHard:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on hard");
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:HARD setMode:gameMode levelNum:1 worldNum:1]]];
}

- (void)onExtreme:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on extreme");
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:EXTREME setMode:gameMode levelNum:1 worldNum:1]]];
}

- (void)onMenu:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on menu");
#ifdef LITEMODE
    MenuScene *menuSceneLayer = [MenuScene node];
    [self.parent addChild:menuSceneLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
#else
    SurvivalSelector *SurvivalSelectorLayer = [SurvivalSelector node];
    [self.parent addChild:SurvivalSelectorLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[SurvivalSelector node]];
#endif
}

- (void)onHighScores:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on high scores");
    if([[GameCenterManager sharedGameCenterManager] hasGameCenter])
    {
#ifndef LITEMODE
        NSLog(@"game center api is available");
        HighScoreSelector *HighScoreSelectorLayer = [[HighScoreSelector node] initWithMode:gameMode];
        [self.parent addChild:HighScoreSelectorLayer z:0];
        [self.parent removeChild:self cleanup:YES];
        //[[CCDirector sharedDirector] replaceScene:[[HighScoreSelector node] initWithMode:gameMode]];
#else
        Highscores *HighscoresLayer = [Highscores node];
        [self.parent addChild:HighscoresLayer z:0];
        [self.parent removeChild:self cleanup:YES];
        //[[CCDirector sharedDirector] replaceScene:[[Highscores node] initWithMode:gameMode]];
#endif
    }
    else
    {
        Highscores *HighscoresLayer = [Highscores node];
        [self.parent addChild:HighscoresLayer z:0];
        [self.parent removeChild:self cleanup:YES];
        //[[CCDirector sharedDirector] replaceScene:[[Highscores node] initWithMode:gameMode]];
    }
}
         
         
-(void)removeAdView
{
    if(adView)
    {
    adView.delegate = nil;
    [adView removeFromSuperview];
    [adView release];
    adView = nil;
    }
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
