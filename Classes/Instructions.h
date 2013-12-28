//
//  Instructions.h
//  Fireballin
//
//  Created by Brian Clark on 4/10/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// Instructions Layer
@interface Instructions : CCLayer {
    CGSize screenSize;
    NSMutableArray* allItems;
    BOOL isIpad;
    float scale;
}

// returns a Scene that contains the Instructions Scene as the only child
+(id) scene;

@end
