//
//  Player.m
//  Fireballin
//
//  Created by Brian Clark on 1/29/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "Player.h"


@implementation Player

-(id) init
{
	if( (self=[super init] )) {
		screenSize = [[CCDirector sharedDirector] winSize];
		
		fXPosition = screenSize.width / 2;
		fYPosition = screenSize.height / 2;
	
        coins = 5;
        
		pPlayerImage = [CCSprite spriteWithFile: @"Sphere.png"];
		pPlayerImage.position = ccp(fXPosition, fYPosition);
	}
	
	return self;
}

-(CCSprite *) getSprite
{
	if(pPlayerImage) return pPlayerImage;
	
	return nil;
}

-(void) addCoin;
{
    coins = coins + 1;
}

-(int) getCoinCount;
{
    return coins;
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
