//
//  Highscores.h
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCScrollLayer.h"
#import "GameScene.h"

// Highscores Layer
@interface Highscores : CCLayer
{
	CGSize screenSize;
    GameMode curMode;
    CCScrollLayer *scroller;
    BOOL isIpad;
}

// returns a Scene that contains the Highscores as the only child
+(id) scene;

-(NSString*) formattedHighScore:(float) time;

@end