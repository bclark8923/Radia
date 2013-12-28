//
//  Powerup.m
//  Fireballin
//
//  Created by Brian Clark on 4/11/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "Powerup.h"


@implementation Powerup

-(id) init
{
	if( (self=[super init] )) {
		
		// Time that it takes to fade in. GameScene wont activate it until after this fade in is done.		
		        
	}
	return self;
}

-(id) initWithData:(NSString*) powerupType setStart:(float) startTime setDuration:(float) durationTime 
              setX:(float) X setY:(float) Y activeTime:(float)actTime
{
	if( (self=[super init] )) {
        ipadScale = [CCDirector sharedDirector].winSize.width == 1024 ? 2.133333 : 1;
        powerup = powerupType;
		spawnTime = startTime;
        duration = durationTime;
        x = X;
        y = Y;
        active = false;
        used = false;
        activeTime = actTime;
        if(ipadScale > 1) {
            pPowerup = [[CCSprite spriteWithFile:@"GlowSphereYellow-hd.png"] retain];
            pPowerup.scale = ipadScale * 0.5;
        } else {
            pPowerup = [[CCSprite spriteWithFile:@"GlowSphereYellow.png"] retain];
        }
        pPowerup.position = ccp(x, y);
        screenSize = [[CCDirector sharedDirector] winSize];
	}
	return self;
}

-(id) initWithData:(NSString*) powerupType setStart:(float) startTime setDuration:(float) durationTime 
              setX:(float) X setY:(float) Y activeTime:(float)actTime slowFactor:(float)factor
{
    if( (self=[super init] )) {
        ipadScale = [CCDirector sharedDirector].winSize.width == 1024 ? 2.133333 : 1;
        powerup = powerupType;
		spawnTime = startTime;
        duration = durationTime;
        x = X;
        y = Y;
        active = false;
        used = false;
        activeTime = actTime;
        slowFactor = factor;
        if(ipadScale > 1) {
            pPowerup = [[CCSprite spriteWithFile:@"GlowSphereRed-hd.png"] retain];
            pPowerup.scale = ipadScale * 0.5;
        } else {
            pPowerup = [[CCSprite spriteWithFile:@"GlowSphereRed.png"] retain];
        }
        pPowerup.position = ccp(x, y);
        screenSize = [[CCDirector sharedDirector] winSize];
	}
	return self;
}

-(id) initWithData:(NSString*) powerupType setStart:(float) startTime setDuration:(float) durationTime 
              setX:(float) X setY:(float) Y destroyCount:(int)count
{
    if( (self=[super init] )) {
        ipadScale = [CCDirector sharedDirector].winSize.width == 1024 ? 2.133333 : 1;
        powerup = powerupType;
		spawnTime = startTime;
        duration = durationTime;
        x = X;
        y = Y;
        active = false;
        used = false;
        destroyCount = count;
        if(ipadScale > 1) {
            pPowerup = [[CCSprite spriteWithFile:@"GlowSphereGreen-hd.png"] retain];
            pPowerup.scale = ipadScale * 0.5;
        } else {
            pPowerup = [[CCSprite spriteWithFile:@"GlowSphereGreen.png"] retain];
        }
        pPowerup.position = ccp(x, y);
        screenSize = [[CCDirector sharedDirector] winSize];
	}
	return self;
}

-(id) initWithData:(NSString*) powerupType setStart:(float) startTime setDuration:(float) durationTime 
              setX:(float) X setY:(float) Y
{
    if( (self=[super init] )) {
        ipadScale = [CCDirector sharedDirector].winSize.width == 1024 ? 2.133333 : 1;
        powerup = powerupType;
		spawnTime = startTime;
        duration = durationTime;
        x = X;
        y = Y;
        active = false;
        used = false;
        if(ipadScale > 1) {
            pPowerup = [[CCSprite spriteWithFile:@"GlowSphereDark-hd.png"] retain];
            pPowerup.scale = ipadScale * 0.5;
        } else {
            pPowerup = [[CCSprite spriteWithFile:@"GlowSphereDark.png"] retain];
        }
        pPowerup.position = ccp(x, y);
        screenSize = [[CCDirector sharedDirector] winSize];
	}
	return self;
}

-(BOOL) isActive;
{
    return active;
}

-(BOOL) isUsed
{
    return used;
}

-(void) use
{
    used = true;
}

-(void) deactivate
{
    active = false;
}

-(void) activate
{
    active = true;
}

-(float) getStartTime
{
    return spawnTime;
}

-(float) getDuration
{
    return duration;
}

-(float) getX
{
    return x;
}

-(float) getY
{
    return y;
}

-(float) getActiveTime
{
    return activeTime;
}

-(int) getDestroyCount
{
    return destroyCount;
}

-(float) getSlowFactor
{
    return slowFactor;
}

-(NSString*) getType
{
    return powerup;
}

-(CCSprite *) getSprite;
{
    return pPowerup;
}

@end
