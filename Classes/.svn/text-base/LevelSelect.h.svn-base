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
#import "CCScrollLayer.h"

// Level Select Layer
@interface LevelSelect : CCLayer
{
	int curWorld;
    int stars_collected;
    BOOL pushCheck;
    BOOL selected;
    CCLabelTTF *timer;
    CCScrollLayer *scroller;
    
    float prevPos;
    
    CGSize screenSize;
    
    CCSprite *bgBlue;
    CCSprite *bgRed;
    CCSprite *bgYellow;
    CCSprite *bgGreen;
    CCSprite *bgBlack;
    BOOL isIpad;
    
    float ipadScale;
}

// returns a Scene that contains the LevelSelect as the only child
+(id) scene;

-(id) initWithWorld:(int) worldNum page: (int) pageNum;

@end