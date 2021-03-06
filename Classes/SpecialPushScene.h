//
//  SpecialPushScene.h
//  Fireballin
//
//  Created by Brian Clark on 5/23/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "GameScene.h"

@interface SpecialPushScene : CCNode {
   	CGSize screenSize;
	enum GameDifficulty curDiff;
    enum GameMode curMode;
    int curLevel; 
    
    CCSprite* ChapterComplete;
    CCMenu *continueMenu2;
    
    CCSprite *title;
    CCMenu *continueMenu;
    
    CCSprite* normalSprite1;
    CCSprite* selectedSprite1;
    CCMenuItemSprite *menuItem1;
    
    CCLabelTTF *slowLabel;
    CCLabelTTF *slowLabelCont;
    CCMenu* skipMenu;
    
    float wait;
    float levelOneWait;
    bool placed;
    int _number;
    bool soundPlayed;
    BOOL isIpad;
    float ipadScale;
}

+(id) scene;

//- (id) initWithInfo:(int) number type:(NSString*) push;

- (id) initAnimations:(int) number;

- (id) initVideo:(int) number;

@end

/*
 
 - (id) initAnimations:(int) number
 {
 if( (self=[super init] )) {	
 screenSize = [[CCDirector sharedDirector] winSize];
 
 CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"Continue" target:self selector:@selector(onResume:)];
 
 CCMenu *continueMenu = [CCMenu menuWithItems:menuItem1, nil];
 
 [continueMenu alignItemsVertically];
 continueMenu.position = ccp(screenSize.width/2, 40.0f);
 [self addChild:continueMenu z:5];
 
 if(number == 11)
 {
 //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
 // @"SlowAnimation.plist"];
 //[[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:
 // @"SlowAnimationA.plist"];
 
 CCSpriteBatchNode *spriteSheet = [CCSpriteBatchNode 
 batchNodeWithFile:@"SlowAnimation.png"];
 //CCSpriteBatchNode *spriteSheetA = [CCSpriteBatchNode 
 //                                  batchNodeWithFile:@"SlowAnimationA.png"];
 [self addChild:spriteSheet];
 //[self addChild:spriteSheetA];
 
 NSMutableArray *slowAnimFrames = [NSMutableArray array];
 for(int i = 0; i <= 90; ++i) {
 [slowAnimFrames addObject:
 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
 [NSString stringWithFormat:@"SlowAnimation%d.png", i]]];
 }
 NSMutableArray *slowAnimFramesA = [NSMutableArray array];
 for(int i = 51; i <= 100; ++i) {
 [slowAnimFrames addObject:
 [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
 [NSString stringWithFormat:@"SlowAnimationA%d.png", i]]];
 }
 
 CCAnimation *slowAnim = [CCAnimation 
 animationWithFrames:slowAnimFrames delay:0.02f];
 //CCAnimation *slowAnimA = [CCAnimation 
 //                         animationWithFrames:slowAnimFramesA delay:0.025f];
 
 CCSprite *slow = [CCSprite spriteWithSpriteFrameName:@"SlowAnimation0.png"];        
 slow.position = ccp(screenSize.width/2, screenSize.height/2);
 CCAction* slowAction = [CCAnimate actionWithAnimation:slowAnim restoreOriginalFrame:NO];
 [slow runAction:slowAction];
 [spriteSheet addChild:slow];
 

}
}
return self;
}

- (id) initWithInfo:(int) number type:(NSString*) push
{
	if( (self=[super init] )) {		
		
		[CCMenuItemFont setFontName:@"Futura"];
		
		screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite *title;
        
        //self.isTouchEnabled = YES;
        
        
         if([push isEqualToString:@"NewPowerup"] && false)
         {
         if(number == 11)
         {
         NSMutableArray *walkAnimFrames = [NSMutableArray array];
         for(int i = 0; i <= 210; ++i) {
         [walkAnimFrames addObject:
         [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:
         [NSString stringWithFormat:@"SlowAnimation%d.png", i]]];
         }
         
         CCAnimation *walkAnim = [CCAnimation animationWithFrames:walkAnimFrames delay:0.1f];
         [CCAnimate actionWithAnimation:walkAnim restoreOriginalFrame:NO]];
         }
         else if(number == 11) //Invincibility
         {
         
         //show stuff for new invincibility
         title = [CCSprite spriteWithFile:@"NewPowerup.png"];
         
         CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"Invincibility" fontName:@"Futura" fontSize:40];
         powerupTitle.position = ccp(screenSize.width/2, 220.0f);
         [self addChild:powerupTitle];
         
         NSString* text_string = @"Your player will be invincible\nfor a variable amount of time!";
         CCLabelTTF* powerupDescrip = [CCLabelTTF labelWithString:NSLocalizedString(text_string, @"") dimensions:CGSizeMake(screenSize.width - 40, 190) alignment:UITextAlignmentCenter fontName:@"Futura" fontSize:26];
         powerupDescrip.position = ccp(screenSize.width/2, 50.0f);
         [self addChild:powerupDescrip];
         
         CCSprite *invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereYellow.png"];
         invincibilitySprite.position = ccp(screenSize.width/2, 170.0f);
         [self addChild:invincibilitySprite];
         }
         if(number == 6)
         {
         //show stuff for new invincibility
         title = [CCSprite spriteWithFile:@"NewPowerup.png"];
         
         CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"Slow Spike" fontName:@"Futura" fontSize:26];
         powerupTitle.position = ccp(screenSize.width/2, 220.0f);
         [self addChild:powerupTitle];
         
         NSString* text_string = @"All Spikes slow down\nfor a variable amount of time!";
         CCLabelTTF* powerupDescrip = [CCLabelTTF labelWithString:NSLocalizedString(text_string, @"") dimensions:CGSizeMake(screenSize.width - 40, 190) alignment:UITextAlignmentCenter  fontName:@"Futura" fontSize:26];
         powerupDescrip.position = ccp(screenSize.width/2, 50.0f);
         [self addChild:powerupDescrip];
         
         CCSprite *invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereRed.png"];
         invincibilitySprite.position = ccp(screenSize.width/2, 170.0f);
         [self addChild:invincibilitySprite];
         }
         if(number == 21)
         {
         //show stuff for new invincibility
         title = [CCSprite spriteWithFile:@"NewPowerup.png"];
         
         CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"Destroy Spike" fontName:@"Futura" fontSize:26];
         powerupTitle.position = ccp(screenSize.width/2, 220.0f);
         [self addChild:powerupTitle];
         
         NSString* text_string = @"The next spike you contact\nwill be destroyed!";
         CCLabelTTF* powerupDescrip = [CCLabelTTF labelWithString:NSLocalizedString(text_string, @"") dimensions:CGSizeMake(screenSize.width - 40, 190) alignment:UITextAlignmentCenter  fontName:@"Futura" fontSize:26];
         powerupDescrip.position = ccp(screenSize.width/2, 50.0f);
         [self addChild:powerupDescrip];
         
         CCSprite *invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereGreen.png"];
         invincibilitySprite.position = ccp(screenSize.width/2, 170.0f);
         [self addChild:invincibilitySprite];
         }
         }
         
         if([push isEqualToString:@"NewWorld"])
         {
         //show stuff for World (number)
         if(number == 10)
         {
         //push New World 2
         
         //show stuff for slow powerup
         title = [CCSprite spriteWithFile:@"NewWorld.png"];
         
         NSString* text_string = @"Congratulations you have completed\nWorld 1!";
         CCLabelTTF* worldDescrip = [CCLabelTTF labelWithString:NSLocalizedString(text_string, @"") dimensions:CGSizeMake(screenSize.width - 40, 210) alignment:UITextAlignmentCenter  fontName:@"Futura" fontSize:26];
         worldDescrip.position = ccp(screenSize.width/2, 80.0f);
         [self addChild:worldDescrip];
         }
         //show stuff for World (number)
         if(number == 20)
         {
         //push New World 2
         
         //show stuff for slow powerup
         title = [CCSprite spriteWithFile:@"NewWorld.png"];
         
         NSString* text_string = @"Congratulations you have completed\nWorld 2!";
         CCLabelTTF* worldDescrip = [CCLabelTTF labelWithString:NSLocalizedString(text_string, @"") dimensions:CGSizeMake(screenSize.width - 40, 210) alignment:UITextAlignmentCenter  fontName:@"Futura" fontSize:26];
         worldDescrip.position = ccp(screenSize.width/2, 80.0f);
         [self addChild:worldDescrip];
         }
         }
		
		CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"Continue" target:self selector:@selector(onResume:)];
        
		CCMenu *continueMenu = [CCMenu menuWithItems:menuItem1, nil];
        
		[continueMenu alignItemsVertically];
		continueMenu.position = ccp(screenSize.width/2, 40.0f);
		[self addChild:continueMenu];
		
        //title = [CCSprite spriteWithFile:@"Paused.png"];
		title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
        title.scale = 0.8;
		//title.color = ccc3(250, 0, 0);
		//[self addChild:title];
	}
	return self;
}
*/
