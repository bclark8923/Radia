//
//  Calibrate.h
//  Fireballin
//
//  Created by Brian Clark on 1/20/12.
//  Copyright (c) 2012 U of Michigan. All rights reserved.
//

#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "Box2D.h"
#import "Player.h"
#import "SimpleAudioEngine.h"

@interface Calibrate : CCLayer
{
	CGSize screenSize;
    ADBannerView  *adView;
    UISlider* bgSlider;
    UISlider* fxSlider;
    
    b2World *_world;    
    Player *player;
	b2Body *playerS;
	b2Body *groundBody;
    
    float playerX;
    float playerY;
    float playerRadius;
    CCSprite *ball;
    CCSprite *ballBg;
    
    float initialX, initialY;
    
    float accelerometerOffset;
    float currentAngle;
    
    bool gameRunning;
    
    CCParticleSystemQuad *trailParticle;
    CCSprite *credits;
    float creditsYpos;
    BOOL touched;
    float touchStartY;
    float creditsStartYTouch;
    BOOL isIpad;
}

// returns a Scene that contains the Difficulty as the only child
+(id) scene;

@end
