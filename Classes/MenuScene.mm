//
//  MenuScene.m
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/19/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuScene.h"
#import "MainMenu.h"
#import "LevelSelect.h"
#import "Difficulty.h"
#import "Instructions.h"
#import	"FireBall.h"
#import "cocos2d.h"
#import "Level.h"
#import "Options.h"
#import "WorldSelect.h"
#import "LiteModeLevelSelect.h"
#import "LevelComing.h"
#import "GameCenterManager.h"
#import "SimpleAudioEngine.h"
#import "AdManager.h"
#import "SurvivalSelector.h"

NSMutableArray * worlds;

@implementation MenuScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuScene *menuLayer = [MenuScene node];
    //optionsLayer = [Options node];
	
	// add layer as a child to scene
	[scene addChild: menuLayer];
	
	// return the scene
	return scene;
}

//#define LITEMODE

- (id) init
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        
		[self initializeLevels];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"1-Lock-1"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"1-Lock-2"];
        for(int i = 1; i <= 50; i++) {
            NSString* level_string = [NSString stringWithFormat:@"%i", i];
            
            NSString* lock_key_string = [level_string stringByAppendingString:@"Lock"];
            //NSString* star_key_string = [level_string stringByAppendingString:@"Star"];
            
            int lock_val = [[NSUserDefaults standardUserDefaults] floatForKey:lock_key_string];
            if(lock_val == 1) {
                NSString* old_level_string = [NSString stringWithFormat:@"%i-Lock-1", i];
                [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:old_level_string];
            }
            
            /*int star_val = [[NSUserDefaults standardUserDefaults] floatForKey:star_key_string];
            NSString* old_star_string = [NSString stringWithFormat:@"%i-Star-1", star_val];
            [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:old_star_string];*/
        }
        
        /*[[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"2Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"3Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"4Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"5Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"6Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"7Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"8Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"9Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"10Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"11Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"12Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"13Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"14Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"15Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"16Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"17Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"18Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"19Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"20Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"21Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"22Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"23Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"24Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"25Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"26Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"27Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"28Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"29Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"30Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"31Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"32Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"33Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"34Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"35Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"36Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"37Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"38Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"39Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"40Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"41Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"42Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"43Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"44Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"45Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"46Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"47Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"48Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"49Lock"];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"50Lock"];*/
        
        
        /*[[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"slow"];
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"invincible"];
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"destroy"];
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"demolish"];
        
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"slowRadia"];
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"invincibleRadia"];
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"destroyRadia"];
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"demolishRadia"];*/

		float testEmpty = [[NSUserDefaults standardUserDefaults] floatForKey:@"easy1"];
		if(testEmpty == -1){
			/*[[NSUserDefaults standardUserDefaults] setFloat:3 forKey:@"easy1"];
			[[NSUserDefaults standardUserDefaults] setFloat:2 forKey:@"easy2"];
			[[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"easy3"];
			
			[[NSUserDefaults standardUserDefaults] setFloat:3 forKey:@"medium1"];
			[[NSUserDefaults standardUserDefaults] setFloat:2 forKey:@"medium2"];
			[[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"medium3"];
			
			[[NSUserDefaults standardUserDefaults] setFloat:3 forKey:@"hard1"];
			[[NSUserDefaults standardUserDefaults] setFloat:2 forKey:@"hard2"];
			[[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"hard3"];
			
			[[NSUserDefaults standardUserDefaults] setFloat:3 forKey:@"extreme1"];
			[[NSUserDefaults standardUserDefaults] setFloat:2 forKey:@"extreme2"];
             [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"extreme3"];*/
			
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		// Always unlock the first level
		[[NSUserDefaults standardUserDefaults] setInteger:1 forKey:@"1Lock"];
        [[NSUserDefaults standardUserDefaults] synchronize];
		
        [CCMenuItemFont setFontName:@"Futura"];
        [CCMenuItemFont setFontSize:32];
        
//#ifdef LITEMODE
//        [GameCenterManager loadState];
//        ADBannerView *bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
//        bannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
//        bannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
//        [bannerView setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90))];
//        [bannerView setCenter:CGPointMake(16, 240)];
//        //[window addSubview:bannerView];
//        [[[CCDirector sharedDirector] openGLView] addSubview:bannerView];
//#endif

        /*
		CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"Level Mode" target:self selector:@selector(onLevels:)];
		CCMenuItemFont *menuItem2 = [CCMenuItemFont itemFromString:@"Survival Mode" target:self selector:@selector(onSurvival:)];
		CCMenuItemFont *menuItem3 = [CCMenuItemFont itemFromString:@"Instructions" target:self selector:@selector(onInstructions:)];
         */
        CCSprite* normalSprite;
        CCSprite* selectedSprite;
        
        if(isIpad) {
            normalSprite = [CCSprite spriteWithFile:@"LevelMode-hd.png"];
            selectedSprite = [CCSprite spriteWithFile:@"LevelMode-hd.png"];
        } else {
            normalSprite = [CCSprite spriteWithFile:@"LevelMode.png"];
            selectedSprite = [CCSprite spriteWithFile:@"LevelMode.png"];
        }
        
        CCSprite* normalSprite2;
        CCSprite* selectedSprite2;
        
        if(isIpad) {
            normalSprite2 = [CCSprite spriteWithFile:@"SurvivalMenu-hd.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"SurvivalMenu-hd.png"];
        } else {
            normalSprite2 = [CCSprite spriteWithFile:@"SurvivalMenu.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"SurvivalMenu.png"];
        }
        
        CCSprite* normalSprite3;
        CCSprite* selectedSprite3;
        
        if(isIpad) {
            normalSprite3 = [CCSprite spriteWithFile:@"OptionsMenu-hd.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"OptionsMenu-hd.png"];
        } else {
            normalSprite3 = [CCSprite spriteWithFile:@"OptionsMenu.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"OptionsMenu.png"];
        }
        
        CCMenuItemSprite *menuItem1 = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(onLevels:)];
		CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite2 selectedSprite:selectedSprite2 target:self selector:@selector(onSurvival:)];
		CCMenuItemSprite *menuItem3 = [CCMenuItemSprite itemFromNormalSprite:normalSprite3 selectedSprite:selectedSprite3 target:self selector:@selector(onOptions:)];
		
		screenSize = [[CCDirector sharedDirector] winSize];
		
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
		CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
		[menu alignItemsVerticallyWithPadding:0.0f];
		menu.position = ccp(screenSize.width/2, screenSize.height/2 - screenSize.height/8);
		menu.position = ccp(screenSize.width - [normalSprite boundingBox].size.width/2, screenSize.height/4 + 10.0f + litemodeOffset);
		[self addChild:menu z:2];
		
        CCSprite* title;
        if(isIpad) {
            title = [CCSprite spriteWithFile:@"Title-hd.png"];
        } else {
            title = [CCSprite spriteWithFile:@"Title.png"];
        }
        CCSprite* lite = [CCSprite spriteWithFile:@"Lite.png"];
        
        /*CCMenuItemSprite *title = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(onLevels:)];*/
        if(isIpad) {
            title.position = ccp(250, screenSize.height - screenSize.height/6);
        } else {
            title.position = ccp(125, screenSize.height - screenSize.height/6);
        }
        lite.position = ccp(200, 230);
		//title.color = ccc3(250, 0, 0);
		[self addChild:title z:2];
#ifdef LITEMODE
        [self addChild:lite z:2];
        
        /*adView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        adView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
        adView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
        [adView setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90))];
        [adView setCenter:CGPointMake(16, 240)];
        [[[CCDirector sharedDirector] openGLView] addSubview:adView];*/
#endif
		
        /*CCSprite* soundSprite = [CCSprite spriteWithFile:@"SoundOn.png"];
        CCSprite* soundSpriteSelected = [CCSprite spriteWithFile:@"SoundOn.png"];
		//soundOn = [CCMenuItemSprite itemFromNormalSprite:soundSprite selectedSprite:soundSpriteSelected target:self selector:@selector(onSound:)];
        
        CCSprite* soundOffSprite = [CCSprite spriteWithFile:@"SoundOff.png"];
        CCSprite* soundOffSpriteSelected = [CCSprite spriteWithFile:@"SoundOff.png"];
		//soundOff = [CCMenuItemSprite itemFromNormalSprite:soundOffSprite selectedSprite:soundOffSpriteSelected target:self selector:@selector(offSound:)];
         */
        
        //[SimpleAudioEngine sharedEngine].backgroundMusicVolume = 1.0f;
        
        CCMenuItemToggle *soundBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSoundClick:) items:[CCMenuItemImage itemFromNormalImage:@"SoundOn.png" selectedImage:@"SoundOn.png"], [CCMenuItemImage itemFromNormalImage:@"SoundOff.png" selectedImage:@"SoundOff.png"], nil];
        
        [soundBtn setSelectedIndex:[[NSUserDefaults standardUserDefaults] floatForKey:@"sound"]];
        if([[NSUserDefaults standardUserDefaults] floatForKey:@"sound"] == 1)
        {
            [[SimpleAudioEngine sharedEngine] setMute:TRUE];
        }
        else
        {
            [[SimpleAudioEngine sharedEngine] setMute:FALSE];
        }
        
		CCMenu *soundMenu = [CCMenu menuWithItems:soundBtn, nil];
		soundMenu.position = ccp(230,35 + litemodeOffset);
		[soundMenu alignItemsVertically];
		//[self addChild:soundMenu];
		
		// Stuff to have fireballs in the background
		gameOver = NO;
		gameRunning = NO;
		
		[UIApplication sharedApplication].idleTimerDisabled = YES;
		
		//fireBalls = [[NSMutableArray alloc] initWithObjects:nil];
		
		game_time = 0.0f;
		initial_pause = 0.0f;

		spawnDuration = 0.1;
		fireBallStartSpeed = 100.0f;

		spawn_time = 0.0f;
		//spawn_time = spawnDuration + 1.0f;
		
		// schedule a repeating callback on every frame
        //[self schedule:@selector(update:)];
        
#ifndef LITEMODE
        //[[GameCenterManager sharedGameCenterManager] authenticateLocalPlayer];
#endif
        if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) { [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Motion.mp3" loop:YES]; }
        
        //[[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Motion.mp3" loop:YES];
        [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio]; // kAMM_FxPlusMusicIfNoOtherAudio kAMM_FxOnly
        [[CDAudioManager sharedManager] setResignBehavior:kAMRBStopPlay autoHandle:YES];
#ifdef BETA
        CCLabelTTF *currentRelease = [CCLabelTTF labelWithString:@"RC 1710" fontName:@"Futura" fontSize:20];
        currentRelease.position = ccp(50, 30);
        [self addChild:currentRelease];
#endif
	}
	return self;
}

- (void)onLevels:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on levels");
#ifdef LITEMODE
    LevelSelect *LevelSelectLayer = [[LevelSelect node] initWithWorld:1];
    [self.parent addChild:LevelSelectLayer z:0];
    [self.parent removeChild:self cleanup:YES];
#else
    WorldSelect *worldLayer = [[WorldSelect node] initWithWorld:1];
    [self.parent addChild:worldLayer z:0 tag:kOptionsScene];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[[WorldSelect node] initWithWorld:1]];
#endif
}

- (void)onSurvival:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on survival");
    SurvivalSelector *survivalLayer = [SurvivalSelector node];
    [self.parent addChild:survivalLayer z:0 tag:kOptionsScene];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[SurvivalSelector node]];
}

- (void)onOptions:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    Options *optionsLayer = [Options node];
    [self.parent addChild:optionsLayer z:0 tag:kOptionsScene];
    [self.parent removeChild:self cleanup:YES];
    //self.visible = NO;
    /*
	NSLog(@"on instructions");
    [self removeAdView];
    
	[[CCDirector sharedDirector] replaceScene:[Options node]];*/
}

- (void)onSoundClick:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on sound click %i", [sender selectedIndex]);
    //[[SimpleAudioEngine sharedEngine] backgroundMusicVolume :0.5f];
    if ([sender selectedIndex] == 1) {
        // button in off state
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"sound"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //[[CDAudioManager sharedManager] setMode:kAMM_FxOnly];
        [[SimpleAudioEngine sharedEngine] setMute:TRUE];
    }
    else {
        // button in on state
        [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"sound"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //[[CDAudioManager sharedManager] setMode:kAMM_MediaPlayback];
        //[[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio];
        
        [[SimpleAudioEngine sharedEngine] setMute:FALSE];
        
        if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) { [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Motion.mp3" loop:YES]; }
    }

}

+(NSMutableArray *) getLevels:(int) worldNum
{
    return worlds[worldNum];//levels;
}

//Level Initializer
-(void)initializeLevels
{
    if(!worlds)
    {
        worlds = [[[NSMutableArray alloc] init] retain];
        
        levelXML = [[TBXML tbxmlWithXMLFile:@"levels.xml"] retain];
        
        // Obtain root element
        TBXMLElement * root = levelXML.rootXMLElement;
        
        if (root) {
            
            TBXMLElement * world = [TBXML childElementNamed:@"World" parentElement:root];
            
            while(world != nil) {
                int levelcnt = 0;
                NSMutableArray *levels = [[[NSMutableArray alloc] init] retain];
                TBXMLElement * level = [TBXML childElementNamed:@"Level" parentElement:world];
                
                while(level != nil) {
                    levelcnt++;
                    //NSLog([NSString stringWithFormat:@"Level: %i", levelcnt]);
                    Level * currentLevel = [[[Level alloc] initWithData:[[TBXML valueOfAttributeNamed:@"onestar" forElement:level] intValue]
                                                               coinTwo:[[TBXML valueOfAttributeNamed:@"twostar" forElement:level] intValue]
                                                             coinThree:[[TBXML valueOfAttributeNamed:@"threestar" forElement:level] intValue]
                                                               setTime:[[TBXML valueOfAttributeNamed:@"limit" forElement:level] floatValue]] retain];
                    
                    //get player start loc
                    TBXMLElement * player = [TBXML childElementNamed:@"Player" parentElement:level];
                    
                    [currentLevel addPlayer:[[TBXML valueOfAttributeNamed:@"x" forElement:player] intValue] 
                                       posY:[[TBXML valueOfAttributeNamed:@"y" forElement:player] intValue]
                                      lives:[[TBXML valueOfAttributeNamed:@"lives" forElement:player] intValue]];
                
                    //get fireball setup info
                
                    //get walls
                    TBXMLElement * walls = [TBXML childElementNamed:@"Walls" parentElement:level];
                    
                    if(walls != nil)
                    {
                        TBXMLElement * wall = [TBXML childElementNamed:@"wall" parentElement:walls];
                
                        while (wall != nil) {
                            int x1, y1, x2, y2;
                            BOOL invisible;
                            float disappear, disappearstart, disappearfrequency, inActiveTime, inActiveAt;
                            float anchorX, anchorY, rotSpeed;
                        
                            x1 = [[TBXML valueOfAttributeNamed:@"x1" forElement:wall] intValue];
                            y1 = [[TBXML valueOfAttributeNamed:@"y1" forElement:wall] intValue];
                            x2 = [[TBXML valueOfAttributeNamed:@"x2" forElement:wall] intValue];
                            y2 = [[TBXML valueOfAttributeNamed:@"y2" forElement:wall] intValue];
                            disappear = [[TBXML valueOfAttributeNamed:@"disappear" forElement:wall] floatValue];
                            disappearstart = [[TBXML valueOfAttributeNamed:@"disappearstart" forElement:wall] floatValue];
                            disappearfrequency = [[TBXML valueOfAttributeNamed:@"disappearfrequency" forElement:wall] floatValue];
                            invisible = [[TBXML valueOfAttributeNamed:@"invisible" forElement:wall] boolValue];
                            inActiveTime = [[TBXML valueOfAttributeNamed:@"inactiveUntil" forElement:wall] floatValue];
                            inActiveAt = [[TBXML valueOfAttributeNamed:@"inactiveAfter" forElement:wall] floatValue];
                            anchorX = [[TBXML valueOfAttributeNamed:@"anchorX" forElement:wall] floatValue];
                            anchorY = [[TBXML valueOfAttributeNamed:@"anchorY" forElement:wall] floatValue];
                            rotSpeed = [[TBXML valueOfAttributeNamed:@"rotSpeed" forElement:wall] floatValue];
                            
                            [currentLevel addWall:x1 posX1:x1 posY1:y1 posX2:x2 posY2:y2 disappear:disappear disstart:disappearstart disfreq: disappearfrequency invisWall:invisible inactiveUntil:inActiveTime inactiveAt:inActiveAt anchorX:anchorX anchorY:anchorY rotSpeed:rotSpeed];
                        
                            wall = [TBXML nextSiblingNamed:@"wall" searchFromElement:wall];
                        }
                    }
                    
                    //get coins
                    TBXMLElement * coins = [TBXML childElementNamed:@"Coins" parentElement:level];
                    
                    if(coins != nil)
                    {
                        TBXMLElement * coin = [TBXML childElementNamed:@"coin" parentElement:coins];
                    
                        while (coin != nil) {
                            float start, duration, x, y, radius, rotSpeed, startAngle;
                            int points;
                        
                            start = [[TBXML valueOfAttributeNamed:@"time" forElement:coin] floatValue];
                            duration = [[TBXML valueOfAttributeNamed:@"duration" forElement:coin] floatValue];
                            x = [[TBXML valueOfAttributeNamed:@"x" forElement:coin] floatValue];
                            y = [[TBXML valueOfAttributeNamed:@"y" forElement:coin] floatValue];
                            points = [[TBXML valueOfAttributeNamed:@"points" forElement:coin] intValue];
                            radius = [[TBXML valueOfAttributeNamed:@"radius" forElement:coin] floatValue];
                            rotSpeed = [[TBXML valueOfAttributeNamed:@"rotSpeed" forElement:coin] floatValue];
                            startAngle = [[TBXML valueOfAttributeNamed:@"startAngle" forElement:coin] floatValue];
                        
                            [currentLevel addCoin:start duration:duration posX:x posY:y points:points radius:radius rotSpeed:rotSpeed startAngle:startAngle];
                        
                            coin = [TBXML nextSiblingNamed:@"coin" searchFromElement:coin];
                        }
                    }
                    
                    TBXMLElement * fireball = [TBXML childElementNamed:@"Fireballs" parentElement:level];
                    
                    if (fireball != nil) {
                        [currentLevel setFireballAlgo:[[TBXML valueOfAttributeNamed:@"spawntime" forElement:fireball] floatValue]
                                          fireballCap:[[TBXML valueOfAttributeNamed:@"cap" forElement:fireball] intValue]
                                        speedIncrease:[[TBXML valueOfAttributeNamed:@"speedincrease" forElement:fireball] floatValue]
                                             speedCap:[[TBXML valueOfAttributeNamed:@"speedcap" forElement:fireball] floatValue]
                                           startSpeed:[[TBXML valueOfAttributeNamed:@"startspeed" forElement:fireball] floatValue]];
                        
                    }
                
                    //get powerups
                    TBXMLElement * powerups = [TBXML childElementNamed:@"Powerups" parentElement:level];
                    
                    if (powerups != nil) {
                
                        TBXMLElement * powerup = [TBXML childElementNamed:@"powerup" parentElement:powerups];
                        
                        while (powerup != nil)
                        {        
                            NSString *type = [[TBXML valueOfAttributeNamed:@"type" forElement:powerup] retain];
                            
                            if ([type isEqualToString:@"TimeSlow"])
                            {
                                NSLog(@"added time slow powerup");
                                [currentLevel addPowerup:type 
                                               startTime:[[TBXML valueOfAttributeNamed:@"time" forElement:powerup] floatValue] 
                                            durationTime:[[TBXML valueOfAttributeNamed:@"duration" forElement:powerup] floatValue] 
                                                       x:[[TBXML valueOfAttributeNamed:@"x" forElement:powerup] floatValue] 
                                                       y:[[TBXML valueOfAttributeNamed:@"y" forElement:powerup] floatValue] 
                                              activeTime:[[TBXML valueOfAttributeNamed:@"active" forElement:powerup] floatValue] 
                                              slowFactor:[[TBXML valueOfAttributeNamed:@"slowfactor" forElement:powerup] floatValue]];
                            }
                            else if ([type isEqualToString:@"Invincible"])
                            {
                                NSLog(@"added invincible powerup");

                                [currentLevel addPowerup:type 
                                               startTime:[[TBXML valueOfAttributeNamed:@"time" forElement:powerup] floatValue] 
                                            durationTime:[[TBXML valueOfAttributeNamed:@"duration" forElement:powerup] floatValue] 
                                                       x:[[TBXML valueOfAttributeNamed:@"x" forElement:powerup] floatValue] 
                                                       y:[[TBXML valueOfAttributeNamed:@"y" forElement:powerup] floatValue] 
                                              activeTime:[[TBXML valueOfAttributeNamed:@"active" forElement:powerup] floatValue]];
                            }
                            else if ([type isEqualToString:@"Destroy"])
                            {
                                NSLog(@"added destroy powerup");

                                [currentLevel addPowerup:type 
                                               startTime:[[TBXML valueOfAttributeNamed:@"time" forElement:powerup] floatValue] 
                                            durationTime:[[TBXML valueOfAttributeNamed:@"duration" forElement:powerup] floatValue] 
                                                       x:[[TBXML valueOfAttributeNamed:@"x" forElement:powerup] floatValue] 
                                                       y:[[TBXML valueOfAttributeNamed:@"y" forElement:powerup] floatValue] 
                                              destroyCount:[[TBXML valueOfAttributeNamed:@"num" forElement:powerup] intValue]];
                            }
                            else if ([type isEqualToString:@"Demolish"])
                            {
                                NSLog(@"added demolish powerup");
                                
                                [currentLevel addPowerup:type 
                                               startTime:[[TBXML valueOfAttributeNamed:@"time" forElement:powerup] floatValue] 
                                            durationTime:[[TBXML valueOfAttributeNamed:@"duration" forElement:powerup] floatValue] 
                                                       x:[[TBXML valueOfAttributeNamed:@"x" forElement:powerup] floatValue] 
                                                       y:[[TBXML valueOfAttributeNamed:@"y" forElement:powerup] floatValue]];
                            }
                            
                            powerup = [TBXML nextSiblingNamed:@"powerup" searchFromElement:powerup];
                        }
                    }
                    
                    [levels addObject:currentLevel];
                    
                    level = [TBXML nextSiblingNamed:@"Level" searchFromElement:level];
                }
                [worlds addObject: levels];
                world = [TBXML nextSiblingNamed:@"World" searchFromElement:world];
            }
        }
    }
}

-(void)removeAdView
{
    /*adView.delegate = nil;
    [adView removeFromSuperview];
    [adView release];
    adView = nil;*/
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	[levelXML release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
