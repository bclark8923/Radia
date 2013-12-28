//
//  MenuScene.h
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Level.h"
#import "TBXML.h"
#import "Options.h"
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>


extern NSMutableArray *worlds;

// MenuScene Layer
@interface MenuScene : CCLayer
{
	CGSize screenSize;
	
	// Variables for the fireballs
	float game_time;
	float spawn_time;
	float initial_pause;
	
	float spawnDuration;
	float fireBallStartSpeed;
	
	NSMutableArray *fireBalls;
    //NSMutableArray *levels;
	
	BOOL gameOver;
	BOOL gameRunning;
	
	//Level* levels;
	//NSXMLParser* levelParser;
    int numLevels;
    TBXML * levelXML;
    ADBannerView  *adView;

    //CCMenuItemSprite *soundOn;
    //CCMenuItemSprite *soundOff;
    
    BOOL isIpad;
}

// returns a Scene that contains the MenuScene as the only child
+(id) scene;

-(void)removeAdView;

-(void)initializeLevels;

+(NSMutableArray *) getLevels:(int)worldNum;

-(void)initializeLevels;

@property(nonatomic,retain) NSMutableArray *worlds;

@end

