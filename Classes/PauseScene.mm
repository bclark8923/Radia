//
//  PauseScene.m
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PauseScene.h"
#import "MenuScene.h"
#import "MainMenu.h"
#import "LevelSelect.h"
#import "LiteModeLevelSelect.h"
#import "Difficulty.h"
#import "cocos2d.h"

@implementation PauseScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	PauseScene *layer = [PauseScene node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{
	accelerometerOffset = -acceleration.x;
    //NSLog(@"%f", -acceleration.x);
    if (accelerometerOffset > 0.95 ) accelerometerOffset = 0.95;
    if (accelerometerOffset < 0 ) accelerometerOffset *= -1;
}

- (id) init
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
        [CCMenuItemFont setFontName:@"Futura"];

		CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"Resume" target:self selector:@selector(onResume:)];
		CCMenuItemFont *menuItem2 = [CCMenuItemFont itemFromString:@"Menu" target:self selector:@selector(onMenu:)];
		
		CCMenu *menu = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
		[menu alignItemsVertically];
		[self addChild:menu];
        
        CCParticleSystem* particle_system = [CCParticleSystemQuad particleWithFile:@"menu.plist"];
        [self addChild:particle_system z:-2];
        particle_system.position = ccp(screenSize.width/2, screenSize.height/2);
        [particle_system resetSystem];
		
		screenSize = [[CCDirector sharedDirector] winSize];
		//CCLabelTTF *title = [CCLabelTTF labelWithString:@"Paused" fontName:@"Futura" fontSize:80];
        CCSprite *title = [CCSprite spriteWithFile:@"Paused.png"];
		title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
		//title.color = ccc3(250, 0, 0);
		[self addChild:title];
        
        
	}
	return self;
}

- (id) initWithInfo:(enum GameDifficulty) difficulty setMode:(enum GameMode) mode setLevel:(int) level setWorld: (int) worldNum;
{
	if( (self=[super init] )) {	
        
        [CCDirector sharedDirector].openGLView.backgroundColor = [UIColor clearColor];
        
#ifdef LITEMODE
        NSArray * subviews = [[CCDirector sharedDirector]openGLView].subviews;
        for (ADBannerView *adView in subviews) {
            adView.hidden = NO;
            //[sv release];
        }
#endif
        curWorld = worldNum;
        
        [[UIAccelerometer sharedAccelerometer] setDelegate:nil];
        [[UIAccelerometer sharedAccelerometer] setDelegate:self];
        
		self.isAccelerometerEnabled = YES;
        
        curDiff = difficulty;
        curMode = mode;
        curLevel = level;
		
		[CCMenuItemFont setFontName:@"Futura"];
		
		screenSize = [[CCDirector sharedDirector] winSize];
        
        CCSprite* resumeNormalSprite;
        CCSprite* resumeSelectSprite;
        CCSprite* menuNormalSprite;
        CCSprite* menuSelectSprite;
        CCSprite* restartNormalSprite;
        CCSprite* restartSelectSprite;
        CCSprite* levelsNormalSprite;
        CCSprite* levelsSelectSprite;
        CCSprite* difficultyNormalSprite;
        CCSprite* difficultySelectSprite;
        
        if (isIpad) {
            resumeNormalSprite = [CCSprite spriteWithFile:@"ResumeButton-hd.png"];
            resumeSelectSprite = [CCSprite spriteWithFile:@"ResumeButton-hd.png"];
            menuNormalSprite = [CCSprite spriteWithFile:@"MainMenuButtonNew-hd.png"];
            menuSelectSprite = [CCSprite spriteWithFile:@"MainMenuButtonNew-hd.png"];
            restartNormalSprite = [CCSprite spriteWithFile:@"RestartButton-hd.png"];
            restartSelectSprite = [CCSprite spriteWithFile:@"RestartButton-hd.png"];
            levelsNormalSprite = [CCSprite spriteWithFile:@"LevelsButton-hd.png"];
            levelsSelectSprite = [CCSprite spriteWithFile:@"LevelsButton-hd.png"];
            difficultyNormalSprite = [CCSprite spriteWithFile:@"MainMenuButtonNew-hd.png"];
            difficultySelectSprite = [CCSprite spriteWithFile:@"MainMenuButtonNew-hd.png"];
        } else {
            resumeNormalSprite = [CCSprite spriteWithFile:@"ResumeButton.png"];
            resumeSelectSprite = [CCSprite spriteWithFile:@"ResumeButton.png"];
            menuNormalSprite = [CCSprite spriteWithFile:@"MainMenuButtonNew.png"];
            menuSelectSprite = [CCSprite spriteWithFile:@"MainMenuButtonNew.png"];
            restartNormalSprite = [CCSprite spriteWithFile:@"RestartButton.png"];
            restartSelectSprite = [CCSprite spriteWithFile:@"RestartButton.png"];
            levelsNormalSprite = [CCSprite spriteWithFile:@"LevelsButton.png"];
            levelsSelectSprite = [CCSprite spriteWithFile:@"LevelsButton.png"];
            difficultyNormalSprite = [CCSprite spriteWithFile:@"MainMenuButtonNew.png"];
            difficultySelectSprite = [CCSprite spriteWithFile:@"MainMenuButtonNew.png"];
        }
        
        CCMenuItemSprite *menuItem1 = [CCMenuItemSprite itemFromNormalSprite:resumeNormalSprite selectedSprite:resumeSelectSprite target:self selector:@selector(onResume:)];
		
        CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:menuNormalSprite selectedSprite:menuSelectSprite target:self selector:@selector(onSurvival:)];
        
        CCMenuItemSprite *menuItem3 = [CCMenuItemSprite itemFromNormalSprite:restartNormalSprite selectedSprite:restartSelectSprite target:self selector:@selector(onRestart:)];
        
        CCMenuItemSprite *menuItem4 = [CCMenuItemSprite itemFromNormalSprite:levelsNormalSprite selectedSprite:levelsSelectSprite target:self selector:@selector(onSelect:)];
        
        CCMenuItemSprite *menuItem5 = [CCMenuItemSprite itemFromNormalSprite:difficultyNormalSprite selectedSprite:difficultySelectSprite target:self selector:@selector(onDifficulty:)];
        
		CCMenu *menu;
        
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
        //NSNumber* itemsPerRow = [NSNumber numberWithInt:2];
        //NSNumber* itemsPerRowSmall = [NSNumber numberWithInt:1];
        
        if(mode == LEVEL) { 
            menu = [CCMenu menuWithItems:menuItem4, menuItem3, menuItem1, nil];
            [menu alignItemsHorizontally];
        }
        else if(mode == COLLECTOR) {
            menu = [CCMenu menuWithItems:menuItem2, menuItem3, menuItem1, nil];
            [menu alignItemsHorizontally];
        }
        else { 
#ifdef LITEMODE
            menu = [CCMenu menuWithItems:menuItem1, menuItem3, menuItem2, nil]; 
            [menu alignItemsHorizontally];
#else
            menu = [CCMenu menuWithItems:menuItem5, menuItem3, menuItem1, nil]; 
            [menu alignItemsHorizontally];
#endif
        }
        
        
		menu.position = ccp(screenSize.width/2, screenSize.height/2 - 20);
		[self addChild:menu];
		
		//CCLabelTTF *title = [CCLabelTTF labelWithString:@"Paused" fontName:@"Futura" fontSize:80];
        CCSprite *title;
        if(isIpad) {
            title = [CCSprite spriteWithFile:@"Paused-hd.png"];
        } else {
            title = [CCSprite spriteWithFile:@"Paused.png"];
        }
		title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/6);
		//title.color = ccc3(250, 0, 0);
		[self addChild:title];
        
        CCMenuItemToggle *soundBtn;
        if(isIpad) {
            soundBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSoundClick:) items:[CCMenuItemImage itemFromNormalImage:@"SoundOn-hd.png" selectedImage:@"SoundOn-hd.png"], [CCMenuItemImage itemFromNormalImage:@"SoundOff-hd.png" selectedImage:@"SoundOff-hd.png"], nil];
        } else {
            soundBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSoundClick:) items:[CCMenuItemImage itemFromNormalImage:@"SoundOn.png" selectedImage:@"SoundOn.png"], [CCMenuItemImage itemFromNormalImage:@"SoundOff.png" selectedImage:@"SoundOff.png"], nil];
        }
        
        [soundBtn setSelectedIndex:[[NSUserDefaults standardUserDefaults] floatForKey:@"sound"]];
        
		CCMenu *soundMenu = [CCMenu menuWithItems:soundBtn, nil];
		soundMenu.position = ccp(35,35 + litemodeOffset);
        if(isIpad) {
            soundMenu.position = ccp(70,70 + litemodeOffset);
        }
		[soundMenu alignItemsVertically];
		[self addChild:soundMenu];
        
        
        
        CCSprite* normalSprite3;
        CCSprite* selectedSprite3;
        
        if(isIpad) {
            normalSprite3 = [CCSprite spriteWithFile:@"CrossHairIcon-hd.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"CrossHairIcon-hd.png"];
        } else {
            normalSprite3 = [CCSprite spriteWithFile:@"CrossHairIcon-hd.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"CrossHairIcon-hd.png"];
        }
        
        CCMenuItemSprite *calibrateItem = [CCMenuItemSprite itemFromNormalSprite:normalSprite3 selectedSprite:selectedSprite3 target:self selector:@selector(onCalibrate:)];
        
		CCMenu *calibrateMenu = [CCMenu menuWithItems:calibrateItem, nil];
		calibrateMenu.position = ccp(screenSize.width - 35,35 + litemodeOffset);
        if(isIpad) {
            calibrateMenu.position = ccp(screenSize.width - 70,70 + litemodeOffset);
        }
		[calibrateMenu alignItemsVertically];
		[self addChild:calibrateMenu];
        
        
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
        if(isIpad) {
            bg.scale = 3;
        }
        bg.position = ccp(screenSize.width/2, screenSize.height/2);
        [self addChild:bg z:-10];
	}
	return self;
}

- (void)onSelect:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	NSLog(@"on select level");
    float currentWorld;
    int tempLevel = curLevel;
    for(currentWorld = 0; tempLevel > 0; currentWorld++) {
        tempLevel -=10;
    }
	[[CCDirector sharedDirector] replaceScene:[[MainMenu node] initLevelOver:curWorld page:currentWorld]];
	//[[CCDirector sharedDirector] replaceScene:[[LevelSelect node] initWithWorld:curWorld]];
}

- (void)onResume:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on resume");
#ifdef LITEMODE
    NSArray * subviews = [[CCDirector sharedDirector]openGLView].subviews;
    for (ADBannerView *adView in subviews) {
        adView.hidden = YES;
        //[sv release];
    }
#endif
	[[CCDirector sharedDirector] popScene];
}

- (void)onRestart:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	NSLog(@"on restart");
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:curDiff setMode:curMode levelNum:curLevel worldNum:1]]];
}

- (void)onMenu:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	NSLog(@"on menu");
	[[CCDirector sharedDirector] replaceScene:[MainMenu node]];
}

- (void)onSurvival:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	NSLog(@"on menu");
	[[CCDirector sharedDirector] replaceScene:[[MainMenu node] initSurvival]];
}

- (void)onDifficulty:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
	NSLog(@"on difficulty");
	[[CCDirector sharedDirector] replaceScene:[[MainMenu node] initDifficulty:curMode]];
	//[[CCDirector sharedDirector] replaceScene:[[Difficulty node] initWithMode:curMode]];
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
        
        if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) { [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Decisions.mp3" loop:YES]; }
    }
    
}

- (void)onCalibrate:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on reset scores");
	// Create alert popup for confirmation
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Calibrate"];
	[dialog setMessage:@"Do you want to re-calibrate?"];
	[dialog addButtonWithTitle:@"Yes"];
	[dialog addButtonWithTitle:@"No"];
	[dialog show];
	[dialog release];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// This function catches the button click on the reset confirmation popup
	if (buttonIndex == 0)
	{
		// Yes, reset the calibration
        [[NSUserDefaults standardUserDefaults] setFloat:accelerometerOffset forKey:@"accelerometerOffset"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UIAlertView* angle = [[UIAlertView alloc] initWithTitle:@"Calibrate"
                                                        message:[NSString stringWithFormat:@"Angle is set at %i degrees", (int)(accelerometerOffset * 90)]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        //[angle setDelegate:self];
        //[angle setTitle:@"Calibrate"];
        //[angle setMessage:[NSString stringWithFormat:@"Angle is set at %i degrees", (int)(accelerometerOffset * 90)]];
        //[angle cancelButtonTitle:@"Ok"];
        [angle show];
        [angle release];
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
