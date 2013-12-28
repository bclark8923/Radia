//
//  Player.h
//  Fireballin
//
//  Created by Brian Clark on 1/29/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCNode {

	CCSprite *pPlayerImage;
	
	float fXPosition;
	float fYPosition;
	
	int lives;
	int coins;
    
	CGSize screenSize;
}

-(CCSprite *) getSprite;

-(void) addCoin;

-(int) getCoinCount;

@end
