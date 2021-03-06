//
//  Level.h
//  Fireballin
//
//  Created by Brian Clark on 3/28/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "Box2D.h"
#import "Coin.h"
#import "Powerup.h"
#include "vector.h"
#import "Wall.h"

@interface Level : CCNode {
	//player
    float startX, startY;
    int lives;
    
    //Level goals
    int coinsOneStar, coinsTwoStar, coinsThreeStar;
    float totalTime;
    
    //fireball
    unsigned int fireballCap;
    float fireballSpawnTimer, fireballSpeedIncrease, fireballSpeedCap, fireballStartSpeed;
    
	//array of walls
    vector <CGPoint> wallStart, wallEnd, wallAnchor;
    vector <float> wallDisappear, wallDisStart, wallDisFreq, wallInactiveTime, wallInactiveAfter, wallRotSpeed;
    vector <BOOL> wallInvis, wallInactive;
    
	//array of powerups
    NSMutableArray *powerups;
    
	//array of coins
    NSMutableArray* coins;
    
    //array of walls
    NSMutableArray* walls;
	
	//other variables needed to run a level
    
    BOOL isIpad;
    float ipadScale;
}

//functions such as coin algorithm, powerup update, collision detection. etc.
-(id) initWithData:(int) coinOne coinTwo:(int) coinTwo coinThree:(int) coinThree setTime:(float) time;

-(void) addWall:(int) wallID posX1:(int) posX1 posY1:(int) posY1 posX2:(int) posX2 posY2:(int) posY2 disappear:(float) disappear disstart:(float) disStart disfreq:(float) disFreq invisWall:(BOOL) invis inactiveUntil:(float) inActive inactiveAt:(float) inactiveStart
        anchorX:(float)anchorX 
        anchorY:(float)anchorY 
       rotSpeed:(float)rotSpeed;

-(void) addCoin:(float) start duration:(float) duration posX:(float) x posY:(float) y points:(int)points radius:(float)radius rotSpeed:(float)rotSpeed startAngle:(float)startAngle;

-(void) addPowerup:(NSString*) powerupType startTime:(float) start durationTime:(float) duration
                 x:(float) X y:(float) Y activeTime:(float)actTime slowFactor:(float) factor;

-(void) addPowerup:(NSString*) powerupType startTime:(float) start durationTime:(float) duration
                 x:(float) X y:(float) Y activeTime:(float)actTime;

-(void) addPowerup:(NSString*) powerupType startTime:(float) start durationTime:(float) duration
                 x:(float) X y:(float) Y destroyCount:(int) count;

-(void) addPowerup:(NSString*) powerupType startTime:(float) start durationTime:(float) duration
                 x:(float) X y:(float) Y;

-(void) addPlayer:(int) x posY:(int) y lives:(int) playerLives;

-(void) setFireballAlgo:(float) spawnTime fireballCap:(unsigned int) fireballNumCap speedIncrease:(float) increaseValue speedCap:(float) speedCap startSpeed:(float) startSpeed;

-(void) setFireballs:(float*) spawnDuration speedIncrease:(float*) fireBallSpeedIncrease startSpeed:(float*) fireBallStartSpeed 
            speedCap:(float*) fireBallSpeedCap
         fireballCap:(unsigned int*) fireBallCap;

-(vector<CGPoint>) getWallStarts;

-(vector<CGPoint>) getWallEnds;

-(vector<CGPoint>) getWallAnchor;

-(vector<float>) getWallDis;

-(vector<float>) getWallDisStart;

-(vector<float>) getWallDisFreq;

-(vector<float>) getWallInactiveTime;

-(vector<float>) getWallInactiveAfter;

-(vector<float>) getWallRotSpeed;

-(vector<BOOL>) getWallInactive;

-(vector<BOOL>) getWallInvis;

-(NSMutableArray*) getCoins;

-(NSMutableArray*) getPowerups;

//-(NSMutableArray*) getWalls;

-(void) setPlayerLoc:(float*) playerX yLoc:(float*) playerY;

-(void) setCoinsNeeded:(int*) coinsNeeded;

-(int) getCoinsTwoStar;

-(int) getCoinsThreeStar;

-(float) getTotalTime;

@end
