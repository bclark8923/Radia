//
//  GameOverScene.h
//  Fireballin
//
//  Created by Brian Clark on 1/31/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameScene.h"

// GameOverScene Layer
@interface GameOverScene : CCLayer
{
	CGSize screenSize;
	enum GameDifficulty curDiff;
    enum GameMode curMode;
    int curLevel;
    BOOL isIpad;
};

// returns a Scene that contains the GameOverScene as the only child
+(id) scene;

//- (id) initWithScore:(float) score;
- (id) initWithScore:(float) score setDifficulty:(enum GameDifficulty) difficulty setMode:(enum GameMode) mode setLevel:(int) level highScore:(BOOL) newHigh;

-(NSString*) formattedHighScore:(float) time;

@end
