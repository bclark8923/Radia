//
//  Sound.h
//  Fireballin
//
//  Created by Brian Clark on 1/18/12.
//  Copyright (c) 2012 U of Michigan. All rights reserved.
//

#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@interface Sound : CCLayer
{
	CGSize screenSize;
    ADBannerView  *adView;
    UISlider* bgSlider;
    UISlider* fxSlider;
    BOOL isIpad;
}

// returns a Scene that contains the Difficulty as the only child
+(id) scene;

//-(void)removeAdView;

@end
