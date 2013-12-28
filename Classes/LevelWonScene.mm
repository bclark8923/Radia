//
//  LevelWonScene.mm
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 4/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LevelWonScene.h"
#import "MenuScene.h"
#import "GameScene.h"
#import "MainMenu.h"
#import "WorldSelect.h"
#import "LevelSelect.h"
#import "LiteModeLevelSelect.h"
#import "SpecialPushScene.h"
#import "cocos2d.h"
#import "CCVideoPlayer.h"


@implementation LevelWonScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LevelWonScene *layer = [LevelWonScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) initWithInfo:(int) energy setLevel:(int) level world:(int) worldNum;
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        float lightModeOffset = 0.0f;
#ifdef LITEMODE
        lightModeOffset = 32.0f;
#endif
        curWorld = worldNum;
        downloadImage = nil;
        CCSprite* normalSprite1;
        CCSprite* selectedSprite1;
        CCSprite* normalSprite2;
        CCSprite* selectedSprite2;
		CCSprite* normalSprite3;
        CCSprite* selectedSprite3;
        CCSprite* levelsNormalSprite;
        CCSprite* levelsSelectSprite;
        CCSprite* retryNormal;
        CCSprite* retrySelected;
        
        if(isIpad) {
            normalSprite1 = [CCSprite spriteWithFile:@"SelectButtonGlow-hd.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"SelectButtonGlow-hd.png"];
            normalSprite2 = [CCSprite spriteWithFile:@"RetryButton-hd.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"RetryButton-hd.png"];
            normalSprite3 = [CCSprite spriteWithFile:@"NextButtonGlow-hd.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"NextButtonGlow-hd.png"];
            levelsNormalSprite = [CCSprite spriteWithFile:@"LevelsButton-hd.png"];
            levelsSelectSprite = [CCSprite spriteWithFile:@"LevelsButton-hd.png"];
            retryNormal = [CCSprite spriteWithFile:@"RetryButton-hd.png"];
            retrySelected = [CCSprite spriteWithFile:@"RetryButton-hd.png"];
        } else {
            normalSprite1 = [CCSprite spriteWithFile:@"SelectButtonGlow.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"SelectButtonGlow.png"];
            normalSprite2 = [CCSprite spriteWithFile:@"RetryButton.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"RetryButton.png"];
            normalSprite3 = [CCSprite spriteWithFile:@"NextButtonGlow.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"NextButtonGlow.png"];
            levelsNormalSprite = [CCSprite spriteWithFile:@"LevelsButton.png"];
            levelsSelectSprite = [CCSprite spriteWithFile:@"LevelsButton.png"];
            retryNormal = [CCSprite spriteWithFile:@"RetryButton.png"];
            retrySelected = [CCSprite spriteWithFile:@"RetryButton.png"];
        }
        
        CCMenuItemSprite *menuItem1 = [CCMenuItemSprite itemFromNormalSprite:normalSprite1 selectedSprite:selectedSprite1 target:self selector:@selector(onSelect:)];
		
        CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite2 selectedSprite:selectedSprite2 target:self selector:@selector(onRetry:)];
        
        CCMenuItemSprite *menuItem3 = [CCMenuItemSprite itemFromNormalSprite:normalSprite3 selectedSprite:selectedSprite3 target:self selector:@selector(onNext:)];
        
        CCMenuItemSprite *menuItem4 = [CCMenuItemSprite itemFromNormalSprite:levelsNormalSprite selectedSprite:levelsSelectSprite target:self selector:@selector(onSelect:)];
		
        CCMenuItemSprite *menuItem5 = [CCMenuItemSprite itemFromNormalSprite:retryNormal selectedSprite:retrySelected target:self selector:@selector(onRetry:)];
		
        energy_collected = energy;
        curLevel = level;
        
		NSString* energy_string = [NSString stringWithFormat:@"%i", energy_collected];
		NSMutableArray * levels = [MenuScene getLevels:curWorld-1];
		Level * currentLevel = [levels objectAtIndex:curLevel-1];
		int possible_energy = [currentLevel getCoins].count;
		NSString* possible_energy_string = [NSString stringWithFormat:@"%i", possible_energy];
		
		screenSize = [[CCDirector sharedDirector] winSize];
		
		// Update number of stars for the level
		int numStarsAchieved = 1;
		if (energy_collected >= [currentLevel getCoinsThreeStar]) {
			numStarsAchieved = 3;
		}
		else if (energy_collected >= [currentLevel getCoinsTwoStar]) {
			numStarsAchieved = 2;
		}
		
		NSString* level_string = [NSString stringWithFormat:@"%i-", level];
		NSString* old_level_string = [NSString stringWithFormat:@"%i", level];
        NSString* world_string = [NSString stringWithFormat:@"%i", curWorld];
        NSString* star_key_string;
        if(worldNum == 1) {
            star_key_string = [old_level_string stringByAppendingString:@"Star"];
        } else {
            star_key_string = [level_string stringByAppendingString:@"Star-"];
            star_key_string = [star_key_string stringByAppendingString:world_string];
        }
		if ([[NSUserDefaults standardUserDefaults] floatForKey:star_key_string] < numStarsAchieved) {
			[[NSUserDefaults standardUserDefaults] setInteger:numStarsAchieved forKey:star_key_string];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		
		// Set up the menu - next level is only an option if this isn't the last level
		//if(curLevel < (int)levels.count-1) {
#ifdef LITEMODE
        if(curLevel == 5 && curWorld == 1)
        {
            //CHANGE THIS TO SCREENSHOT AND TO PUSH DOWNLOAD SCREEN
            //shit to call onFull: and show full version
            //downloadImage = [CCSprite spriteWithFile:@"DownloadFull.png"];
            //downloadImage.position = ccp(screenSize.width/2, screenSize.height/2);
            //[self addChild:downloadImage z:20];
            
            CCSprite* normalSprite5 = [CCSprite spriteWithFile:@"DownloadFull.png"];
            CCSprite* selectedSprite5 = [CCSprite spriteWithFile:@"DownloadFull.png"];
            CCMenuItemSprite *downloadSwallow = [CCMenuItemSprite itemFromNormalSprite:normalSprite5 selectedSprite:selectedSprite5 target:self selector:@selector(onFull:)];
            
            menu3 = [CCMenu menuWithItems:downloadSwallow, nil];
            [menu3 alignItemsVertically];
            menu3.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:menu3 z:20];
            
            CCSprite* normalSprite = [CCSprite spriteWithFile:@"BackButton.png"];
            CCSprite* selectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
            CCMenuItemSprite *backItem = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(onSelect:)];
            
            CCMenu *menu = [CCMenu menuWithItems:backItem, nil];
            menu.position = ccp(35,25 + 32);
            [menu alignItemsVertically];
            [self addChild:menu z:30];
            
            CCMenuItemFont *download = [CCMenuItemFont itemFromString:@"Download Now" target:self selector:@selector(onFull:)];

            menu2 = [CCMenu menuWithItems:download, nil];
            [menu2 alignItemsVertically];
            menu2.position = ccp(screenSize.width/2, screenSize.height/2 - screenSize.height/4);
            [self addChild:menu2 z:25];
        }
#endif
        float menuOffset = 20;
        
#ifdef LITEMODE
        if(curLevel != 5)
        {
            CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
            [menu alignItemsHorizontallyWithPadding:-20];
            menu.position = ccp(screenSize.width/2, screenSize.height/2 - screenSize.height/4 + menuOffset + 10);
            [self addChild:menu];
        } else {
            CCMenu *menu = [CCMenu menuWithItems:menuItem4, menuItem5, nil];
			[menu alignItemsHorizontally];
			menu.position = ccp(screenSize.width/2, screenSize.height/2 - screenSize.height/4);
			[self addChild:menu];
        }
#else
        if(curLevel != 50) {
			CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, menuItem3, nil];
			[menu alignItemsHorizontallyWithPadding:-20];
			menu.position = ccp(screenSize.width/2, screenSize.height/2 - screenSize.height/4);
			[self addChild:menu];
		}
		else {
			CCMenu *menu = [CCMenu menuWithItems:menuItem4, menuItem5, nil];
			[menu alignItemsHorizontally];
			menu.position = ccp(screenSize.width/2, screenSize.height/2 - screenSize.height/4);
			[self addChild:menu];
		}
#endif
        
        // Unlock next level
        int next_level = level+1;
        NSString* next_level_string = [NSString stringWithFormat:@"%i-", next_level];
        NSString* lock_key_string = [next_level_string stringByAppendingString:@"Lock-"];
        lock_key_string = [lock_key_string stringByAppendingString:world_string];
        [[NSUserDefaults standardUserDefaults] setInteger:1 forKey:lock_key_string];
        [[NSUserDefaults standardUserDefaults] synchronize];

		//NSString *endText = @"Level Passed!";
		//NSString *BaseEnergyText = @"You Collected ";
		//NSString *NumEnergyText = [BaseEnergyText stringByAppendingString:energy_string];
		NSString *SlashText = [energy_string stringByAppendingString:@"/"];
		NSString *totalEnergyText = [SlashText stringByAppendingString:possible_energy_string];
		//NSString *totalEnergyText = [PossibleEnergy stringByAppendingString:@" Radia"];		
		
		//CCLabelTTF *title = [CCLabelTTF labelWithString:endText fontName:@"Futura" fontSize:80];
        CCSprite *title;
        if(isIpad) {
            title = [CCSprite spriteWithFile:@"LevelPassedSmall-hd.png"];
        } else {
            title = [CCSprite spriteWithFile:@"LevelPassedSmall.png"];
        }
		title.position = ccp(screenSize.width/2, screenSize.height/2 + screenSize.height/4 + menuOffset);
		//title.color = ccc3(0, 150, 250);
        [self addChild:title];
        
		CCSprite *radia;
        if (isIpad) {
            radia = [CCSprite spriteWithFile:@"GlowEnergyBall-hd.png"];
            radia.position = ccp(screenSize.width - 60, 60);
        } else {
            radia = [CCSprite spriteWithFile:@"GlowEnergyBall.png"];
            radia.position = ccp(screenSize.width - 30, 30);
        }
        [self addChild:radia];
		
        int scoreFontSize = 30;
        if(isIpad) {
            scoreFontSize = 60;
        }
		CCLabelTTF *scoreLabel = [CCLabelTTF labelWithString:totalEnergyText fontName:@"Futura" fontSize:scoreFontSize];
		//scoreLabel.position = ccp(screenSize.width/2, screenSize.height - 2.5*screenSize.height/8);
        scoreLabel.anchorPoint = ccp(1,0);
		scoreLabel.position = ccp(screenSize.width - 60, 10 + lightModeOffset);
        if(isIpad) {
            scoreLabel.position = ccp(screenSize.width - 120, 20 + lightModeOffset);
        }
		[self addChild:scoreLabel];
        
		// Determine how many stars to show
        NSString* starsString;
		if (numStarsAchieved == 3) {
			starsString = [NSString stringWithFormat:@"GlowThreeStarLineLarge"];
		}
		else if (numStarsAchieved == 2) {
            starsString = [NSString stringWithFormat:@"GlowTwoStarLineLarge"];
		}
		else {
            starsString = [NSString stringWithFormat:@"GlowOneStarLineLarge"];
		}
        if(isIpad) {
            starsString = [starsString stringByAppendingString:@"-hd"];
        }
        starsString = [starsString stringByAppendingString:@".png"];
        CCSprite *stars = [CCSprite spriteWithFile:starsString];
        stars.position = ccp(screenSize.width/2, screenSize.height/2 + menuOffset - 10 + (lightModeOffset/2));
        [self addChild:stars];
	}
#ifdef LITEMODE
    NSArray * subviews = [[CCDirector sharedDirector]openGLView].subviews;
    for (ADBannerView *adView in subviews) {
        adView.hidden = NO;
        //[sv release];
    }
#endif
    //[self specialPushLevelWon];
    
    if(curLevel != 50) {
        soundEffect = [[SimpleAudioEngine sharedEngine] playEffect:@"win.mp3"];
    }
    
    CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"menu.plist"];
    [self addChild:particle_system z:-2];
    particle_system.blendFunc = (ccBlendFunc){GL_ONE, GL_ONE};
    if(isIpad) {
        particle_system.endSize = particle_system.endSize * 2;
        particle_system.totalParticles = particle_system.totalParticles * 0.5;
    }
    particle_system.position = ccp(screenSize.width/2, screenSize.height/2);
    [particle_system resetSystem];
    
    CCSprite *bg;
    if(curWorld == 1) {
        if(level >= 11 && level <= 20) {
            bg = [CCSprite spriteWithFile:@"redBg.png"];
        } else if(level >= 21 && level <= 30) {
            bg = [CCSprite spriteWithFile:@"yellowBg.png"];
        } else if(level >= 31 && level <= 40) {
            bg = [CCSprite spriteWithFile:@"greenBg.png"];
        } else if(level >= 41 && level <= 50) {
            bg = [CCSprite spriteWithFile:@"darkBg.png"];
        } else {
            bg = [CCSprite spriteWithFile:@"blueBg.png"];
        }
    } else {
        bg = [CCSprite spriteWithFile:@"blueBg.png"];
    }
    bg.position = ccp(screenSize.width/2, screenSize.height/2);
    if(isIpad) {
        bg.scale = 3;
    }
    [self addChild:bg z:-10];
    
	return self;
}

- (void)dummy:(id)sender
{
    
}

- (void)onSelect:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on select level");
    [[SimpleAudioEngine sharedEngine] stopEffect:soundEffect];
    float currentWorld;
    int tempLevel = curLevel;
    for(currentWorld = 0; tempLevel > 0; currentWorld++) {
        tempLevel -=10;
    }
#ifdef LITEMODE
    if(menu3) {
        [self removeChild:menu3 cleanup:YES];
        [self removeChild:menu2 cleanup:YES];
        menu3 = nil;
        return;
    }
#endif
	[[CCDirector sharedDirector] replaceScene:[[MainMenu node] initLevelOver:curWorld page:currentWorld]];
}

- (void)onFull:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.com/apps/Radia"]];
}

- (void)onRetry:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on retry");
    [[SimpleAudioEngine sharedEngine] stopEffect:soundEffect];
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:curLevel worldNum:curWorld]]];
}

- (void)onNext:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on next");
    [[SimpleAudioEngine sharedEngine] stopEffect:soundEffect];
    
    if(curLevel == 10 && [[NSUserDefaults standardUserDefaults] floatForKey:@"slow"] == 0 && curWorld == 1)
    {
        [CCVideoPlayer setNoSkip:true];
        [[CCDirector sharedDirector] replaceScene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:curLevel+1 worldNum:curWorld]];
        [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:curLevel+1]];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"slow"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(curLevel == 20 && [[NSUserDefaults standardUserDefaults] floatForKey:@"invincible"] == 0 && curWorld == 1)
    {
        [CCVideoPlayer setNoSkip:true];
        [[CCDirector sharedDirector] replaceScene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:curLevel+1 worldNum:curWorld]];
        [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:curLevel+1]];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"invincible"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(curLevel == 30 && [[NSUserDefaults standardUserDefaults] floatForKey:@"destroy"] == 0 && curWorld == 1)
    {
        [CCVideoPlayer setNoSkip:true];
        [[CCDirector sharedDirector] replaceScene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:curLevel+1 worldNum:curWorld]];
        [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:curLevel+1]];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"destroy"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(curLevel == 40 && [[NSUserDefaults standardUserDefaults] floatForKey:@"demolish"] == 0 && curWorld == 1)
    {
        [CCVideoPlayer setNoSkip:true];
        [[CCDirector sharedDirector] replaceScene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:curLevel+1 worldNum:curWorld]];
        [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:curLevel+1]];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"demolish"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:curLevel+1 worldNum:curWorld]]];
    }
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end

