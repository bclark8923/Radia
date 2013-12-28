//
//  Highscores.h
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameScene.h"

// Highscores Layer
@interface HighScoresGlobal : CCLayer
{
	CGSize screenSize;
    GameMode curMode;
    BOOL isIpad;
}

// returns a Scene that contains the Highscores as the only child
+(id) scene;

-(NSString*) formattedHighScore:(float) time;

@end