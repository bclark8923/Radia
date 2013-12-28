//
//  Difficulty.h
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "GameScene.h"
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

// Difficulty Select Layer
@interface Difficulty : CCLayer
{
	CGSize screenSize;
    ADBannerView  *adView;
    GameMode gameMode;
    BOOL isIpad;
}

// returns a Scene that contains the Difficulty as the only child
+(id) scene;

-(void)removeAdView;

- (id) initWithMode:(GameMode) mode;

@end
