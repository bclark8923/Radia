//
//  WorldSelect.h
//  Fireballin
//
//  Created by Brian Clark on 4/8/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "CCScrollLayer.h"

// World Select Layer
@interface WorldSelect : CCLayer {
    CGSize screenSize;
    NSMutableArray* allItems;
    CCScrollLayer *scroller;
    CCSprite* starSprite;
    CCLabelTTF *starsCollectedLabel;
    BOOL isIpad;
}

// returns a Scene that contains the WorldSelect as the only child
+(id) scene;

- (id) initWithWorld:(int) curWorld;

@end