//
//  Coin.h
//  Fireballin
//
//  Created by Tom King on 4/8/11.
//  Copyright 2011 University of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SimpleAudioEngine.h"
#import "cocos2d.h"

@interface Coin : CCNode {
    
	CCSprite *pCoin;
	CCSprite *pCoinDying;
    int points;
    BOOL active;
    BOOL used;
    BOOL rotating;
    BOOL missed;
    BOOL fadeOutComplete;
    BOOL dyingPlayed;
	
	float initTime;
	float duration;
	float endTime;
    
	float fXPosition;
	float fYPosition;
    float defaultX;
    float defaultY;
    float fadeOutTime;
	
	float lifetime;
	float fadeInTime;
    float rotRadius;
    float rotationSpeed;
    float rotAngle;
		
	CGSize screenSize;
    CGPoint myPointAroundTheCircle;
    CGPoint anchorPointOfMyCircle;
    
    int soundEffect;
    
    float ipadScale;
}

-(void) resetRandomPos;

-(void) setTime:(float) m_initTime setDuration:(float) m_duration;

-(CCSprite *) getSprite;

-(CCSprite *) getDyingSprite;

-(void) activate;

-(void) deactivate;

-(float) getStartTime;

-(float) getEndTime;

-(float) getXPos;

-(float) getYPos;

-(void) consume;

-(BOOL) consumed;

-(BOOL) isActive;

-(id) initWithVariables:(float)start duration:(float)coinDuration posX:(float)x posY:(float) y points:(int) coinPoints radius:(float)radius rotSpeed:(float)rotSpeed startAngle:(float)startAngle;

-(void) fadeIn;

-(float) getFadeInTime;

-(void) updateLifetime:(float) time;

-(float) getLifetime;

-(int) getPoints;

-(BOOL) isRotating;

-(float) getRadius;

-(float) getStartAngle;

-(float) getRotSpeed;

-(float) getCurYPos;

-(float) getCurXPos; 

-(void) remove;

-(void) stopSound;

@end
