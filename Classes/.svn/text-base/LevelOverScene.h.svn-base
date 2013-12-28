//
//  LevelOverScene.h
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// LevelOverScene Layer
@interface LevelOverScene : CCLayer 
{
	CGSize screenSize;
    int energy_collected;
    int curLevel;
    int curWorld;
    BOOL isIpad;
};

// returns a Scene that contains the LevelOverScene as the only child
+(id) scene;

- (id) initWithInfo:(int) energy setLevel:(int) level world:(int) worldNum;

@end
