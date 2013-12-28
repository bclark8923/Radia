//
//  Wall.mm
//  Fireballin
//
//  Created by Brian Clark on 12/26/11.
//  Copyright (c) 2011 U of Michigan. All rights reserved.
//

#import "Wall.h"

@implementation Wall

-(id) init
{
	if( (self=[super init] )) {
		
		// Time that it takes to fade in. GameScene wont activate it until after this fade in is done.		
        
	}
	return self;
}


-(id) initWithVariables:(CGPoint)posXPT posY:(CGPoint) posYPT dissappear:(BOOL)disWall disTime:(float)disTimeF disStart:(float)disStartF disFreq:(float) disFreqF box:(b2PolygonShape*) boxWall shapeDef:(b2FixtureDef*) boxDef fixture:(b2Fixture *)wallFix invisWall:(BOOL) invis inactiveTime:(float) inactive inactiveAfter:(float) inactiveAfterTime anchor:(CGPoint) anchorPoint rotSpeed:(float)rotateSpeed wallBody:(b2Body*) body
{
    if( (self=[super init] )) {
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        if(isIpad) {
            ipadScale = 2.133333;
        } else {
            ipadScale = 1;
        }
        
        posX = posXPT;
        posX.x = posX.x * ipadScale;
        posX.y = posX.y * ipadScale;
        posY = posYPT;
        posY.x = posY.x * ipadScale;
        posY.y = posY.y * ipadScale;
        anchor = anchorPoint;
        anchor.x = anchor.x * ipadScale;
        anchor.y = anchor.y * ipadScale;
        dissapear = disWall;
        disTime = disTimeF;
        disStart = disStartF;
        disFreq = disFreqF;
        rotSpeed = rotateSpeed;
        rotating = rotSpeed == 0 ? NO : YES;
        visible = TRUE;
        wall = TRUE;
        disappearingBegun = FALSE;
        groundBoxWall = boxWall;
        boxShapeDefWall = boxDef;
        wallFixture = wallFix;
        invisibleWall = invis;
        active = inactive > 0 ? FALSE : TRUE;
        inactveTime = inactive;
        inactiveAfter = inactiveAfterTime - inactive;
        turnInactive = inactiveAfterTime > 0 ? TRUE : FALSE;
        reActivate = TRUE;
        wallBody = body;
        
        if(rotating) {
            rotAngleOne = 180 + atan2(anchor.y - posX.y, anchor.x - posX.x) * 180 / 3.14159;
            rotAngleTwo = 180 + atan2(anchor.y - posY.y, anchor.x - posY.x) * 180 / 3.14159;
            rotAngleBody = 180 + atan2(anchor.y - body->GetPosition().y*PTM_RATIO, anchor.x - body->GetPosition().x*PTM_RATIO) * 180 / 3.14159; 
            
            
            rotRadiusOne = sqrtf((anchor.x - posX.x)*(anchor.x - posX.x) + (anchor.y - posX.y)*(anchor.y - posX.y));
            rotRadiusTwo = sqrtf((anchor.x - posY.x)*(anchor.x - posY.x) + (anchor.y - posY.y)*(anchor.y - posY.y));
        }
        
        if(!active) {
            wallBody->SetAngularVelocity(0);
        }
	}
	return self;
}

-(CGPoint) xPoint
{
    return posX;
}

-(CGPoint) yPoint
{
    return posY;
}

-(BOOL) isVisible
{
    return visible;
}

-(void) decreaseInactive:(float) dt b2body:(b2Body*) body
{
    inactveTime -= dt;
    if(inactveTime <= 0)
    {
        active = true;
        wallBody->SetAngularVelocity(rotSpeed/57.3);
        [self turnOn:body];
    }
}

-(BOOL) decreaseInactiveAfter:(float) dt b2body:(b2Body*) body
{
    if(turnInactive)
    {
        inactiveAfter -= dt;
        if(inactiveAfter <= 0)
        {
            active = false;
            wallBody->SetAngularVelocity(0);
            dissapear = false;
            [self turnOff:body];
            reActivate = false;
            turnInactive = false;
            //return true;
        }
    }
    return false;
}

-(void) endLife 
{
    wallBody->SetAngularVelocity(0);
}

-(void) turnOff:(b2Body*) body
{
    //NSLog(@"wall turned off");
    //boxShapeDefWall->isSensor = false;
    if(wallFixture) {
        wallBody->DestroyFixture(wallFixture);
    }
    wallFixture = nil;
    wallBody->SetAngularVelocity(0);
    //posX.x += 700;
    //posY.x += 700;
    wall = FALSE;
    visible = FALSE;
    currentlyDisappeared = TRUE;
    timeToReappear = disTime;
}

-(void) turnOn:(b2Body*) body
{
    if(reActivate)
    {
        //NSLog(@"wall turned on");
        //boxShapeDefWall->isSensor = true;
        wallFixture = wallBody->CreateFixture(boxShapeDefWall);
        //posX.x -= 700;
        //posY.x -= 700;
        wall = TRUE;
        wallBody->SetAngularVelocity(rotSpeed/57.3);
        visible = TRUE;
        currentlyDisappeared = FALSE;
        timeToNextDisappear = disFreq;
    }
}
 
-(void)move:(float) dt world:(b2Body*) body
{
    if(wall && rotating && active) {
        //rotate points
        rotAngleBody = rotAngleBody + dt * rotSpeed;
        //if(rotAngleBody > 360) rotAngleBody = 0;
        //if(rotAngleBody < 0) rotAngleBody = 360;
        rotAngleOne = rotAngleOne + dt * rotSpeed;
        //if(rotAngleOne > 360) rotAngleOne = 0;
        //if(rotAngleOne < 0) rotAngleOne = 360;
        //NSLog(@"%f %f", rotAngleBody, rotAngleOne);
        
        if(rotAngleOne < 0) rotAngleOne += 360;
        //anchorPointOfMyCircle = ccp(fXPosition, fYPosition);
        float angleOfMyPointAroundTheCircleOne = CC_DEGREES_TO_RADIANS(fmod(rotAngleOne,360));
        
        myPointAroundTheCircleOne.x = cos(angleOfMyPointAroundTheCircleOne) * rotRadiusOne;
        myPointAroundTheCircleOne.y = sin(angleOfMyPointAroundTheCircleOne) * rotRadiusOne;
        
        posX = ccpAdd(anchor, myPointAroundTheCircleOne);
        
        
        rotAngleTwo = rotAngleTwo + dt * rotSpeed;
        //if(rotAngleTwo > 360) rotAngleTwo = 0;
        //if(rotAngleTwo < 0) rotAngleTwo = 360;
        
        if(rotAngleTwo < 0) rotAngleTwo += 360;
        //anchorPointOfMyCircle = ccp(fXPosition, fYPosition);
        float angleOfMyPointAroundTheCircleTwo = CC_DEGREES_TO_RADIANS(fmod(rotAngleTwo,360));
        
        myPointAroundTheCircleTwo.x = cos(angleOfMyPointAroundTheCircleTwo) * rotRadiusTwo;
        myPointAroundTheCircleTwo.y = sin(angleOfMyPointAroundTheCircleTwo) * rotRadiusTwo;
        
        posY = ccpAdd(anchor, myPointAroundTheCircleTwo);
        
        b2Vec2 vertex = b2Vec2(posX.x, posX.y);
        b2Vec2 vertex2 = b2Vec2(posY.x, posY.y);
        
        //groundBoxWall->SetAsEdge(vertex, vertex2);
        
        
        float rotAngleBodyRadians = CC_DEGREES_TO_RADIANS(rotAngleBody);
        b2Vec2 pos = wallBody->GetPosition();
        //wallBody->SetTransform(pos, rotAngleBodyRadians);
        //wallBody->ApplyAngularImpulse(rotSpeed);
        
        if(wallFixture) {
            //body->DestroyFixture(wallFixture);
            //wallFixture = body->CreateFixture(boxShapeDefWall);
        }
        
        
        b2PolygonShape* poly = (b2PolygonShape*) wallFixture->GetShape();
        //posX = ccp(poly->GetVertex(0).x*PTM_RATIO,poly->GetVertex(0).y*PTM_RATIO);
        //posY = ccp(poly->GetVertex(1).x*PTM_RATIO,poly->GetVertex(1).y*PTM_RATIO);
        //wallFixture->GetBody()->SetTransform(anchorVec, rotAngleOne);
    }
}

-(BOOL) disappearing
{
    return dissapear;
}

-(float) disStartTime
{
    return disStart;
}

-(float) disTime
{
    return disTime;
}

-(float) disFreq
{
    return disFreq;
}

-(BOOL) getCurrentlyDisappeared
{
    return currentlyDisappeared;
}

-(float) getTimeToNextDisappear
{
    return timeToNextDisappear;
}

-(float) getTimeToReappear
{
    return timeToReappear;
}

-(void) setCurrentlyDisappeared:(BOOL) dis
{
    currentlyDisappeared = dis;
}

-(void) setInitialDisappear
{
    timeToNextDisappear = 0;
    disappearingBegun = TRUE;
}

-(void) decreaseTimeToDisappear:(float) dt
{
    timeToNextDisappear -= dt;
}

-(void) decreaseTimeToReappear:(float) dt
{
    timeToReappear -= dt;
}

-(BOOL) getActiveDisappear
{
    return disappearingBegun;
}

-(void) setTimeToNextDisappear:(float) time
{
    timeToNextDisappear = time;
}

-(void) setTimeToReappear:(float) time
{
    timeToReappear = time;
}

-(BOOL) isActive
{
    return active;
}

-(BOOL) disBegun
{
    return disappearingBegun;
}

-(BOOL) isInvisible
{
    return invisibleWall;
}

@end
