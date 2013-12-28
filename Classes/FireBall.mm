//
//  FireBall.m
//  Fireballin
//
//  Created by Brian Clark on 1/27/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "FireBall.h"

@implementation FireBall

-(id) initWithPlayerLoc: (float) playerX playerY: (float) playerY
{
	if( (self=[super init] )) {
		
		screenSize = [[CCDirector sharedDirector] winSize];
        
        ipadScale = [CCDirector sharedDirector].winSize.width == 1024 ? 2.133333 : 1;
		
		fSpeed = 0.0f;
		fSize = 1.0f;
		fAngle = 2.0f;
		
		fXPosition = 0.0f;
		fYPosition = 0.0f;
        
        playerXLoc = playerX;
        playerYLoc = playerY;
        
		//fXPosition = screenSize.width / 4;
		//fXPosition = (arc4random() % 400) + 40;
		//fYPosition = screenSize.height / 2;
		//fYPosition = (arc4random() % 260) + 40;
		
		//smokeTrail = [CCParticleSmoke node];
		
		isAlive = false;
        used = false;
        removed = false;
        dead = false;
        killer = false;
		lifetime = 0.0f;
		fadeInTime = 0.5f;
        fadeOutTime = 1.5f;
        
        radius = 30.0f;
        rotSpeed = 1.0f;
		
		//Randomize spawn point
		[self resetRandomPos];
		
		//pFireBall = [CCSprite spriteWithFile:@"Fireball3.png"];
        if(ipadScale > 1) {
            pFireBall = [[CCSprite spriteWithFile:@"SpikeBall-hd.png"] retain];
            pFireBall.scale = ipadScale * 0.5;
            slow = [[CCSprite spriteWithFile:@"GlowSphereRedLarge-hd.png"] retain];
            slow.scale = ipadScale * 0.5;
        } else {
            pFireBall = [[CCSprite spriteWithFile:@"SpikeBall.png"] retain];
            slow = [[CCSprite spriteWithFile:@"GlowSphereRedLarge.png"] retain];
        }
        pFireBall.opacity = 255;
        slow.opacity = 255.0f / 2.0f;
        //slow.scale = 2.5f;
		//pFireBall.anchorPoint = ccp(21.0/40.0, 25.0/40.0);
		pFireBall.position = ccp(fXPosition, fYPosition);
        slow.position = ccp(fXPosition, fYPosition);
		rotAngle = 0;
	}
	return self;
}

-(void) resetRandomPos
{
    float fPlayerToFireball = 0.0f;
    
	while(fPlayerToFireball < 175.0f*ipadScale || fXPosition > 480*ipadScale || fXPosition < 0 || fYPosition > 320*ipadScale || fYPosition < 0)
	{
        fXPosition = (arc4random() % 440*ipadScale) + 20*ipadScale;
        fYPosition = (arc4random() % 280*ipadScale) + 20*ipadScale;
        fPlayerToFireball = sqrt(pow(fabs(playerXLoc - fXPosition), 2) 
                                 + pow(fabs(playerYLoc - fYPosition), 2));
        pFireBall.position = ccp(fXPosition, fYPosition);
        slow.position = ccp(fXPosition, fYPosition);
	}
}

-(void) setPos:(float) m_fXPos setYPos:(float) m_fYPos
{
	fXPosition = m_fXPos;
	fYPosition = m_fYPos;
	pFireBall.position = ccp(fXPosition, fYPosition);
    slow.position = ccp(fXPosition, fYPosition);
}

-(void) movePos:(float) dt
{
	//rotAngle += 15;
    //slowTimeRem -= dt;
    //if(slowTimeRem < 0.0f) slowTimeRem = 0.0f;
	rotAngle += 6;
	rotAngle %= 360;
	fXPosition += cos(fAngle) * fSpeed * dt;
	fYPosition += sin(fAngle) * fSpeed * dt;
    pFireBall.position = ccp(fXPosition, fYPosition);
    slow.position = ccp(fXPosition, fYPosition);
    //float newOpacity = (slowTimeRem / slowDownTime) * 127.5;
    //slow.opacity = newOpacity;
    //if(slowTimeRem > 0){
    //    NSLog(@"%f", newOpacity);
    //}
    //slow.opacity = 10.0f;
	pFireBall.rotation = rotAngle;
}

-(void) rotate:(float) dt
{
    if(killer) {
        rotSpeed += (dt*2.5);
        rotAngle += 6 * rotSpeed;
        rotAngle %= 360;
        pFireBall.rotation = rotAngle;
    }
}

-(void) isKiller
{
    killer = true;
}

-(void) setSlowOpacity:(float) newOpacity
{
    slow.opacity = newOpacity;
}

-(void) setSprite:(CCSprite *) sprite
{
	//pFireBall = sprite;
}

-(CCSprite *) getSprite
{
    /*NSLog(@"%f", pFireBall.position.x);
    NSLog(@"%f", pFireBall.position.y);*/
	return pFireBall;
}

-(CCSprite *) getSlowSprite
{
	return slow;
}

-(BOOL) isUsed
{
    return used;
}

-(void) setSlow:(BOOL)slowDown slowDownTime:(float)initialSlowTime slowTime:(float)slowTime;
{
    slowed = slowDown;
    slowDownTime = initialSlowTime;
    slowTimeRem = slowTime;
}

-(float) getTotalSlow
{
    return slowDownTime;
}

-(float) getSlowRem
{
    return slowTimeRem;
}

-(void) use
{
    used = true;
    //[pFireBall release];
    if(ipadScale > 1) {
        pFireBall = [[CCSprite spriteWithFile:@"SpikeBallShatter-hd.png"] retain];
        pFireBall.scale = ipadScale * 0.5;
    } else {
        pFireBall = [[CCSprite spriteWithFile:@"SpikeBallShatter.png"] retain];
    }
    pFireBall.position = ccp(fXPosition, fYPosition);
    slow.opacity = 0;
}

-(void) fadeOout:(float) dt
{
    fadeOutTime -= dt;
    slow.opacity = 0;
    if(fadeOutTime < 1.0f)
    {
        pFireBall.opacity = fadeOutTime * 255;
    }
    if(fadeOutTime <= 0.0f)
    {
        removed = YES;;
    }
}

-(BOOL) fadeOutComplete
{
    return removed;
}

-(float) getRadius
{
    return radius;
}

-(float) getXPos
{
	return fXPosition;
}

-(float) getYPos
{
	return fYPosition;
}

-(void) setAngle:(float) m_fAngle
{
	fAngle = m_fAngle;
}

-(float) getAngle
{
	return fAngle;
}

-(void) addSpeed:(float)m_fSpeed
{
	fSpeed += m_fSpeed;
}

-(void) fadeIn
{
	//pFireBall.opacity = 100;
	id fadeFireball = [CCFadeIn actionWithDuration:fadeInTime];
	//[pFireBall runAction:fadeFireball];
    if(slowed){
        slow.opacity = 255;
        //[slow runAction:fadeFireball];
    }
}

-(bool) getIsAlive
{
	return isAlive;
}

-(void) updateLifetime:(float) time
{
	lifetime += time;
	if (lifetime > fadeInTime) {
		isAlive = true;
	}
}

-(float) getSpeed
{
    return fSpeed;
}

- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	//[pFireBall dealloc];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}

@end
