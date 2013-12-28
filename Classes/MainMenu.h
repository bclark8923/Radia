//
//  MainMenu.h
//  Fireballin
//
//  Created by Brian Clark on 3/30/12.
//  Copyright (c) 2012 U of Michigan. All rights reserved.
//

#import "cocos2d.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "Options.h"
#import "Level.h"
#import "TBXML.h"
#import "Options.h"
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

typedef enum {
    kMenuScene = 1,
    kOptionsScene
} LayerTags;

// MenuScene Layer
@interface MainMenu : CCLayer
{
    MenuScene *menuSceneLayer;
    
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
    
    CCSprite* darkBg;
    
    CCSprite *bgBlue;
    CCSprite *bgRed;
    CCSprite *bgYellow;
    CCSprite *bgGreen;
    CCSprite *bgDark;
    
    float deviceScale;
}

// returns a Scene that contains the MenuScene as the only child
+(id) scene;

- (id) initLevelOver:(int)curWorld page: (int) curPage;

- (id) initLiteLevelOver:(int)curWorld;

-(id) initDifficulty:(GameMode)curMode;

-(id) initSurvival;

-(void) setDarkBackground:(float) pos;

-(void) removeDarkBackground;

@end
