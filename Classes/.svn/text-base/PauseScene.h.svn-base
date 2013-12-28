//
//  PauseScene.h
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameScene.h"

// PauseScene Layer
@interface PauseScene : CCLayer
{
	CGSize screenSize;
	enum GameDifficulty curDiff;
    enum GameMode curMode;
    int curLevel;
    int curWorld;
    float accelerometerOffset;
    BOOL isIpad;
}

// returns a Scene that contains the PauseScene as the only child
+(id) scene;

- (id) initWithInfo:(enum GameDifficulty) difficulty setMode:(enum GameMode) mode setLevel:(int) level setWorld:(int) worldNum;

@end