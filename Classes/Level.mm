//
//  Level.m
//  Fireballin
//
//  Created by Brian Clark on 3/28/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "Level.h"
#import "MenuScene.h"
#import "Box2D.h"


@implementation Level

-(id) initWithData:(int) coinOne coinTwo:(int) coinTwo coinThree:(int) coinThree setTime:(float) time
{
	if( (self=[super init] )) {
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        if(isIpad) {
            ipadScale = 2.133333;
        } else {
            ipadScale = 1;
        }
        
        coinsOneStar = coinOne;
        coinsTwoStar = coinTwo;
        coinsThreeStar = coinThree;
        totalTime = time;
        coins = [[[NSMutableArray alloc] initWithObjects:nil] retain];
        powerups = [[[NSMutableArray alloc] initWithObjects:nil] retain];
        walls = [[[NSMutableArray alloc] initWithObjects:nil] retain]; 
    }
    
    return self;
}

-(void) addWall:(int) wallID 
            posX1:(int) posX1
            posY1:(int) posY1
            posX2:(int) posX2
            posY2:(int) posY2
            disappear:(float) disappear
            disstart:(float)disStart 
            disfreq:(float)disFreq
            invisWall:(BOOL) invis 
            inactiveUntil:(float) inActive 
            inactiveAt:(float) inactiveStart
            anchorX:(float)anchorX 
            anchorY:(float)anchorY 
            rotSpeed:(float)rotSpeed
{
    //add pairs of CGPoints to a vector
    BOOL isInActive = inActive > 0 ? TRUE : FALSE;
    wallStart.push_back(ccp(posX1,posY1));
    wallEnd.push_back(ccp(posX2,posY2));
    wallDisappear.push_back(disappear);
    wallDisStart.push_back(disStart);
    wallDisFreq.push_back(disFreq);
    wallInvis.push_back(invis);
    wallInactive.push_back(isInActive);
    wallInactiveTime.push_back(inActive);
    wallInactiveAfter.push_back(inactiveStart);
    wallAnchor.push_back(ccp(anchorX, anchorY));
    wallRotSpeed.push_back(rotSpeed);
                        
    /*b2PolygonShape *groundBoxWall = new b2PolygonShape;
    b2FixtureDef *boxShapeDefWall = new b2FixtureDef;
    boxShapeDefWall->shape = groundBoxWall;
    
    b2Vec2 vertex = b2Vec2(posX1/PTM_RATIO, posY1/PTM_RATIO);
    b2Vec2 vertex2 = b2Vec2(wallEnds.at(i).x/PTM_RATIO, wallEnds.at(i).y/PTM_RATIO);
    
    groundBoxWall->SetAsEdge(vertex, vertex2);
    b2Fixture* wallFix = groundBody->CreateFixture(boxShapeDefWall);
    
    bool disWall = disappear > 0 ? TRUE : FALSE;
    
    Wall* newWall = [[[Wall node] initWithVariables:vertex
                                               posY:ccp(posX2,posY2)
                                         dissappear:disWall
                                            disTime:disappear
                                           disStart:disStart
                                            disFreq:disFreq
                                                //box:groundBoxWall
                                           //shapeDef:boxShapeDefWall
                                            //fixture:wallFix
                                          invisWall:invis] retain];*/
}

-(void) addCoin:(float) start duration:(float) duration posX:(float) x posY:(float) y points:(int)points radius:(float)radius rotSpeed:(float)rotSpeed startAngle:(float)startAngle
{
    Coin* newCoin = [[[Coin node] initWithVariables:start duration:duration posX:x posY:y points:points radius:radius rotSpeed:rotSpeed startAngle:startAngle] retain];
    [coins addObject:newCoin];
}

-(void) addPowerup:(NSString*) powerupType startTime:(float) start durationTime:(float) duration x:(float) X y:(float) Y
activeTime:(float)actTime
{
    Powerup* newPowerup = [[[Powerup node] initWithData:powerupType setStart:start setDuration:duration setX:X setY:Y activeTime:actTime] retain];
    [powerups addObject:newPowerup];
}

-(void) addPowerup:(NSString*) powerupType startTime:(float) start durationTime:(float) duration x:(float) X y:(float) Y
        activeTime:(float)actTime slowFactor:(float) factor
{
    Powerup* newPowerup = [[[Powerup node] initWithData:powerupType setStart:start setDuration:duration setX:X setY:Y activeTime:actTime slowFactor:factor] retain];
    [powerups addObject:newPowerup];
}

-(void) addPowerup:(NSString*) powerupType startTime:(float) start durationTime:(float) duration x:(float) X y:(float) Y
    destroyCount:(int)count
{
    Powerup* newPowerup = [[[Powerup node] initWithData:powerupType setStart:start setDuration:duration setX:X setY:Y destroyCount:count] retain];
    [powerups addObject:newPowerup];
}


-(void) addPowerup:(NSString*) powerupType startTime:(float) start durationTime:(float) duration
                 x:(float) X y:(float) Y
{
    Powerup* newPowerup = [[[Powerup node] initWithData:powerupType setStart:start setDuration:duration setX:X setY:Y] retain];
    [powerups addObject:newPowerup];
}

-(void) addPlayer:(int) x posY:(int) y lives:(int) playerLives
{
    startX = x * ipadScale;
    startY = y * ipadScale;
    lives = playerLives;
}

-(void) setFireballAlgo:(float) spawnTime fireballCap:(unsigned int) fireballNumCap speedIncrease:(float) increaseValue speedCap:(float) speedCap startSpeed:(float) startSpeed
{
    fireballCap = fireballNumCap;
    fireballSpawnTimer = spawnTime;
    fireballSpeedIncrease = increaseValue;
    fireballSpeedCap = speedCap;
    fireballStartSpeed = startSpeed;
}

-(void) setFireballs:(float*) spawnDuration speedIncrease:(float*) fireBallSpeedIncrease startSpeed:(float*) fireBallStartSpeed 
                         speedCap:(float*) fireBallSpeedCap
                      fireballCap:(unsigned int*) fireBallCap
{
    *spawnDuration = fireballSpawnTimer;
    *fireBallSpeedIncrease = fireballSpeedIncrease;
    *fireBallStartSpeed = fireballStartSpeed;
    *fireBallSpeedCap = fireballSpeedCap;
    *fireBallCap = fireballCap;
}

-(vector<CGPoint>) getWallStarts
{
    return wallStart;
}

-(vector<CGPoint>) getWallEnds
{
    return wallEnd;
}

-(vector<CGPoint>) getWallAnchor
{
    return wallAnchor;
}

-(vector<float>) getWallDis
{
    return wallDisappear;
}

-(vector<float>) getWallDisStart
{
    return wallDisStart;
}

-(vector<float>) getWallDisFreq
{
    return wallDisFreq;
}

-(vector<float>) getWallInactiveAfter
{
    return wallInactiveAfter;
}

-(vector<float>) getWallInactiveTime
{
    return wallInactiveTime;
}

-(vector<float>) getWallRotSpeed
{
    return wallRotSpeed;
}

-(vector<BOOL>) getWallInactive
{
    return wallInactive;
}

-(vector<BOOL>) getWallInvis
{
    return wallInvis;
}

-(NSMutableArray*) getCoins
{
    return coins;
}

-(NSMutableArray*) getPowerups
{
    return powerups;
}

-(void) setPlayerLoc:(float*) playerX yLoc:(float*) playerY
{
    *playerX = startX;
    *playerY = startY;
}

-(void) setCoinsNeeded:(int*) coinsNeeded
{
    *coinsNeeded = coinsOneStar;
}

-(int) getCoinsTwoStar
{
    return coinsTwoStar;
}

-(int) getCoinsThreeStar
{
    return coinsThreeStar;
}

-(float) getTotalTime
{
    return totalTime;
}

@end
