//
//  LevelSelect.h
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import <Foundation/Foundation.h>
#include "vector.h"

// Level Select Layer
@interface LiteModeLevelSelect : CCLayer
{
	int curWorld;
    int stars_collected;
    BOOL pushCheck;
    BOOL isIpad;
}

// returns a Scene that contains the LevelSelect as the only child
+(id) scene;

-(id) initWithWorld:(int) worldNum;

@end