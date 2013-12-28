//
//  SurvivalSelector.m
//  Fireballin
//
//  Created by Brian Clark on 1/22/12.
//  Copyright (c) 2012 U of Michigan. All rights reserved.
//

#import "SurvivalSelector.h"
#import "Instructions.h"
#import "MenuScene.h"
#import "Sound.h"
#import "SimpleAudioEngine.h"
#import "Calibrate.h"
#import "Difficulty.h"
#import "GameCenterManager.h"
#import "Highscores.h"
#import "HighScoreSelector.h"
#import "GameScene.h"

@implementation SurvivalSelector

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SurvivalSelector *layer = [SurvivalSelector node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
		screenSize = [[CCDirector sharedDirector] winSize];
		//CCLabelTTF *title = [CCLabelTTF labelWithString:@"Difficulty" fontName:@"Futura" fontSize:50];
        CCSprite* title;
        if(isIpad) {
            title = [CCSprite spriteWithFile:@"SurvivalTitle-hd.png"];
        } else {
            title = [CCSprite spriteWithFile:@"SurvivalTitle.png"];
        }
		title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/6);
		//title.color = ccc3(250, 0, 0);
		[self addChild:title];
        
        CCSprite* normalSprite1;
        CCSprite* selectedSprite1;
        
        if(isIpad) {
            normalSprite1 = [CCSprite spriteWithFile:@"TimedMenu-hd.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"TimedMenu-hd.png"];
        } else {
            normalSprite1 = [CCSprite spriteWithFile:@"TimedMenu.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"TimedMenu.png"];
        }
        
        CCSprite* normalSprite2;
        CCSprite* selectedSprite2;
        
        if(isIpad) {
            normalSprite2 = [CCSprite spriteWithFile:@"RadiaMenu-hd.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"RadiaMenu-hd.png"];
        } else {
            normalSprite2 = [CCSprite spriteWithFile:@"RadiaMenu.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"RadiaMenu.png"];
        }
        
        CCSprite* normalSprite3;
        CCSprite* selectedSprite3;
        
        if(isIpad) {
            normalSprite3 = [CCSprite spriteWithFile:@"HighScoreMenu-hd.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"HighScoreMenu-hd.png"];
        } else {
            normalSprite3 = [CCSprite spriteWithFile:@"HighScoreMenu.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"HighScoreMenu.png"];
        }
        
        CCMenuItemSprite *menuItem1 = [CCMenuItemSprite itemFromNormalSprite:normalSprite1 selectedSprite:selectedSprite1 target:self selector:@selector(onTimed:)];
		CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite2 selectedSprite:selectedSprite2 target:self selector:@selector(onCollect:)];
		CCMenuItemSprite *menuItem3 = [CCMenuItemSprite itemFromNormalSprite:normalSprite3 selectedSprite:selectedSprite3 target:self selector:@selector(onHighScores:)];
        
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
		CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
		[menu alignItemsVerticallyWithPadding:0.0f];
		menu.position = ccp(screenSize.width/2, screenSize.height/2 - screenSize.height/8);
		menu.position = ccp(screenSize.width - [normalSprite1 boundingBox].size.width/2, screenSize.height/4 + 10.0f + litemodeOffset);
		[self addChild:menu z:2];
        
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

- (void)onMenu:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on menu");
    MenuScene *menuSceneLayer = [MenuScene node];
    [self.parent addChild:menuSceneLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}

- (void)onTimed:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on instructions");
    //[self removeAdView];
#ifdef LITEMODE
    [self removeAdView];
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:MEDIUM setMode:SURVIVAL levelNum:0]]];
#else
    Difficulty *difficultyLayer = [[Difficulty node] initWithMode:SURVIVAL];
    [self.parent addChild:difficultyLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[[Difficulty node] initWithMode:SURVIVAL]];
#endif
}

- (void)onCollect:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on instructions");
    //[self removeAdView];
	//[[CCDirector sharedDirector] replaceScene:[[Difficulty node] initWithMode:COLLECTOR]];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:COLLECT setMode:COLLECTOR levelNum:0 worldNum:1]]];
}

- (void)onCalibrate:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on instructions");
    //[self removeAdView];
    Calibrate *calibrateLayer = [Calibrate node];
    [self.parent addChild:calibrateLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[Calibrate node]];
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

- (void)onHighScores:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on high scores");
    if([[GameCenterManager sharedGameCenterManager] hasGameCenter])
    {
#ifndef LITEMODE
        NSLog(@"game center api is available");
        HighScoreSelector *HighScoreSelectorLayer = [[HighScoreSelector node] initWithMode:COLLECTOR];
        [self.parent addChild:HighScoreSelectorLayer z:0];
        [self.parent removeChild:self cleanup:YES];
        //[[CCDirector sharedDirector] replaceScene:[[HighScoreSelector node] initWithMode:COLLECTOR]];
#else
        Highscores *highscoresLayer = [[Highscores node] initWithMode:COLLECTOR];
        [self.parent addChild:highscoresLayer z:0];
        [self.parent removeChild:self cleanup:YES];
        //[[CCDirector sharedDirector] replaceScene:[[Highscores node] initWithMode:COLLECTOR]];
#endif
    }
    else
    {
        Highscores *highscoresLayer = [[Highscores node] initWithMode:COLLECTOR];
        [self.parent addChild:highscoresLayer z:0];
        [self.parent removeChild:self cleanup:YES];
        //[[CCDirector sharedDirector] replaceScene:[[Highscores node] initWithMode:COLLECTOR]];
    }
}
         
@end
