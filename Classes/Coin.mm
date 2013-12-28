//
//  Coin.m
//  Fireballin
//
//  Created by Tom King on 4/8/11.
//  Copyright 2011 University of Michigan. All rights reserved.
//

#import "Coin.h"


@implementation Coin

-(id) init
{
	if( (self=[super init] )) {
		
		// Time that it takes to fade in. GameScene wont activate it until after this fade in is done.
		fadeInTime = 0.25f;
        fadeOutTime = 0.75f;
		lifetime = 0.0f;
		
		screenSize = [[CCDirector sharedDirector] winSize];
		
		fXPosition = 0.0f;
		fYPosition = 0.0f;
        active = true;
        used = false;
        fadeOutComplete = NO;

		[self resetRandomPos];
		
		pCoin = [CCSprite spriteWithFile:@"GlowEnergyBall.png"];
        //[pCoin
		pCoin.position = ccp(fXPosition, fYPosition);
	}
	return self;
}

-(id) initWithVariables:(float)start duration:(float)coinDuration posX:(float)x posY:(float) y points:(int) coinPoints radius:(float)radius rotSpeed:(float)rotSpeed startAngle:(float)startAngle
{
	if( (self=[super init] )) {
		ipadScale = [CCDirector sharedDirector].winSize.width == 1024 ? 2.133333 : 1;
		// Time that it takes to fade in. GameScene wont activate it until after this fade in is done.
		fadeInTime = 0.25f;
		lifetime = 0.0f;
		
		//screenSize = [[CCDirector sharedDirector] winSize];
        active = false;
        dyingPlayed = NO;
        
        initTime = start;
        duration = coinDuration;
        endTime = start + coinDuration;
        
        defaultX = x;
        defaultY = y;
        fXPosition = x;
        fYPosition = y;
        points = coinPoints;
        rotRadius = radius;
        rotationSpeed = rotSpeed;
        rotAngle = (int)startAngle;
        rotating = radius > 0.1 ? YES : NO;
        
        glColor4f(0.0f, 0.0f, 0.0f, 1.0f);
        if(ipadScale == 1) {
            pCoin = [[CCSprite spriteWithFile:@"GlowEnergyBall.png"] retain];
            pCoinDying = [[CCSprite spriteWithFile:@"GlowEnergyBallDying.png"] retain];
        } else {
            pCoin = [[CCSprite spriteWithFile:@"GlowEnergyBall-hd.png"] retain];
            pCoin.scale = ipadScale * 0.5;
            pCoinDying = [[CCSprite spriteWithFile:@"GlowEnergyBallDying-hd.png"] retain];
            pCoinDying.scale = ipadScale * 0.5;
        }
        pCoinDying.opacity = 0;
        //pCoin.color = ccc3(1.0,1.0,0.5);
        if(rotating) {
            anchorPointOfMyCircle = ccp(fXPosition, fYPosition);
            float angleOfMyPointAroundTheCircle = CC_DEGREES_TO_RADIANS(rotAngle);
            
            myPointAroundTheCircle.x = cos(-angleOfMyPointAroundTheCircle) * rotRadius;
            myPointAroundTheCircle.y = sin(angleOfMyPointAroundTheCircle) * rotRadius;
            
            myPointAroundTheCircle = ccpAdd(anchorPointOfMyCircle, myPointAroundTheCircle);
            pCoin.position = myPointAroundTheCircle; 
            pCoinDying.position = myPointAroundTheCircle;
            //pCoin.anchorPoint = ccp(rotRadius/pCoin.boundingBox.size.width, 0.5f); 
            //pCoin.rotation = rotAngle;
        } else {
            pCoin.position = ccp(fXPosition, fYPosition);
            pCoinDying.position = ccp(fXPosition, fYPosition);
            myPointAroundTheCircle = ccp(fXPosition, fYPosition);
        }
        
        
        if(coinPoints >= 20) {
            pCoin.scale = 1 - ((coinPoints - 20) * 0.045 * 0.5);
            pCoinDying.scale = 1 - ((coinPoints - 20) * 0.045 * 0.5);
        }
    }
    return self;
}

-(void) resetRandomPos
{
	fXPosition = (arc4random() % 400) + 40;
	fYPosition = (arc4random() % 260) + 40;
}

-(void) setTime:(float) m_initTime setDuration:(float) m_duration;
{
    initTime = m_initTime;
    duration = m_duration;
    endTime = initTime + duration;
}

-(void) activate
{
    active = true;
}

-(void) deactivate
{
    active = false;
}

-(void) remove
{
    used = true;
    missed = YES;
    dyingPlayed = YES;
    //pCoin.opacity = 0;
    pCoin = [[CCSprite spriteWithFile:@"Burst.png"] retain];
    pCoin.position = ccp(fXPosition, fYPosition);
    pCoin.opacity = 255;
    //animation of radia bursting to orange
    [[SimpleAudioEngine sharedEngine] playEffect:@"RadiaDeath.wav"];
}

-(void) consume
{
    used = true;
    missed = NO;
    dyingPlayed = YES;
    //pCoin.opacity = 0;
    [[SimpleAudioEngine sharedEngine] stopEffect:soundEffect];
    pCoin = [[CCSprite spriteWithFile:@"Collected.png"] retain];
    pCoin.position = ccp(fXPosition, fYPosition);
    pCoin.opacity = 255;
    //animation of radia bursting to blue
}

-(BOOL) consumed
{
    return used;
}

-(float) getStartTime;
{
    return initTime;
}

-(float) getEndTime;
{
    return endTime;
}

-(CCSprite *) getSprite
{
	return pCoin;
}

-(CCSprite *) getDyingSprite
{
	return pCoinDying;
}

-(float) getXPos
{
    
    //NSLog([NSString stringWithFormat:@"%f, %f", pCoin.position.x, pCoin.position.y]);
    return defaultX;
	//return fXPosition;
}

-(float) getCurXPos 
{
    //NSLog([NSString stringWithFormat:@"%f, %f, %i", myPointAroundTheCircle.x, myPointAroundTheCircle.y, rotAngle]);
    return myPointAroundTheCircle.x;
}

-(float) getYPos
{
    return defaultY;
	//return fYPosition;
}

-(float) getCurYPos 
{
    return myPointAroundTheCircle.y;
}

-(BOOL) isActive
{
    return active;
}

-(void) fadeIn
{
	pCoin.opacity = 0;
	id fadeCoin = [CCFadeIn actionWithDuration:fadeInTime];
	[pCoin runAction:fadeCoin];
}

-(float) getFadeInTime
{
	return fadeInTime;
}

-(void) stopSound
{
    dyingPlayed = YES;
}

-(void) updateLifetime:(float) time
{
    if(used && !fadeOutComplete) { 
        fadeOutComplete = YES;
        pCoin.opacity = 0;
        pCoinDying.opacity = 0;
        /*
        fadeOutTime -= time;
        if(fadeOutTime <= 0.5f) {
            pCoin.opacity = fadeOutTime / 0.5f;
        }
        if(fadeOutTime <= 0.0f) { 
            fadeOutComplete = YES;
            pCoin.opacity = 0;
        }*/
    } else if (active) {
        lifetime += time;
        if(duration - lifetime <= 1.0f && duration - lifetime > 0.0f) {
            pCoin.opacity =  (duration - lifetime) * 255;
            pCoinDying.opacity =  (1.0 - (duration - lifetime)) * 255;
            if(!dyingPlayed && duration - lifetime <= 0) {
                dyingPlayed = YES;
                //soundEffect = [[SimpleAudioEngine sharedEngine] playEffect:@"RadiaDeath.wav"];
            }
        }
        if(rotating) {
            rotAngle = rotAngle + time*rotationSpeed;
            //NSLog([NSString stringWithFormat:@"%f",rotAngle]);
            //rotAngle %= 360;
            if(rotAngle > 360) { rotAngle -= 360; };
            if(rotAngle < 0) rotAngle += 360;
            
            //anchorPointOfMyCircle = ccp(fXPosition, fYPosition);
            float angleOfMyPointAroundTheCircle = CC_DEGREES_TO_RADIANS(rotAngle);
            
            myPointAroundTheCircle.x = cos(angleOfMyPointAroundTheCircle) * rotRadius;
            myPointAroundTheCircle.y = sin(angleOfMyPointAroundTheCircle) * rotRadius;
            
            myPointAroundTheCircle = ccpAdd(anchorPointOfMyCircle, myPointAroundTheCircle);
            //NSLog([NSString stringWithFormat:@"%i", rotAngle]);
            //pCoin.rotation = rotAngle;
            pCoin.position = myPointAroundTheCircle;
            pCoinDying.position = myPointAroundTheCircle;
            //NSLog([NSString stringWithFormat:@"%f, %f", fXPosition, fYPosition]);
            //NSLog([NSString stringWithFormat:@"%f, %f", pCoin.position.x, pCoin.position.y]);
            //NSLog([NSString stringWithFormat:@"%f, %f, %i", myPointAroundTheCircle.x, myPointAroundTheCircle.y, rotAngle]);
            //pCoin.rotation %= 360.0;
        }
    }
}

-(float) getLifetime
{
	return lifetime;
}

-(int) getPoints
{
    return points;
}

-(BOOL) isRotating {
    return rotating;
}


-(float) getRadius
{
    return rotRadius;
}

-(float) getStartAngle
{
    return (float)rotAngle;
}

-(float) getRotSpeed
{
    return rotationSpeed;
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
