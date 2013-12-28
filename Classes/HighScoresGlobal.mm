//
//  Highscores.m
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Difficulty.h"
#import "HighScoresGlobal.h"
#import "HighScoreSelector.h"
#import "SimpleAudioEngine.h"
#import "GameCenterManager.h"
#import "cocos2d.h"

@implementation HighScoresGlobal

//#define LITEMODE

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HighScoresGlobal *layer = [HighScoresGlobal node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) initWithMode:(GameMode) mode
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        curMode = mode;
        
		screenSize = [[CCDirector sharedDirector] winSize];
		//CCLabelTTF *title = [CCLabelTTF labelWithString:@"High Scores" fontName:@"Futura" fontSize:50];
        CCSprite *title;
        if(isIpad) {
            title = [CCSprite spriteWithFile:@"HighScoresTitle-hd.png"];
        } else {
            title = [CCSprite spriteWithFile:@"HighScoresTitle.png"];
        }
		title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/6);
		//title.color = ccc3(250, 0, 0);
		[self addChild:title];
        
        
        //[[GameCenterManager sharedGameCenterManager] authenticateLocalPlayer];
        
        CCSprite* normalSprite1;
        CCSprite* selectedSprite1;
        CCSprite* normalSprite2;
        CCSprite* selectedSprite2;
        CCSprite* normalSprite3;
        CCSprite* selectedSprite3;
        CCSprite* normalSprite4;
        CCSprite* selectedSprite4;
        
        if(isIpad) {
            normalSprite1 = [CCSprite spriteWithFile:@"EasyMenu-hd.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"EasyMenu-hd.png"];
            normalSprite2 = [CCSprite spriteWithFile:@"MediumMenu-hd.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"MediumMenu-hd.png"];
            normalSprite3 = [CCSprite spriteWithFile:@"HardMenu-hd.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"HardMenu-hd.png"];
            normalSprite4 = [CCSprite spriteWithFile:@"ExtremeMenu-hd.png"];
            selectedSprite4 = [CCSprite spriteWithFile:@"ExtremeMenu-hd.png"];
        } else {
            normalSprite1 = [CCSprite spriteWithFile:@"EasyMenu.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"EasyMenu.png"];
            normalSprite2 = [CCSprite spriteWithFile:@"MediumMenu.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"MediumMenu.png"];
            normalSprite3 = [CCSprite spriteWithFile:@"HardMenu.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"HardMenu.png"];
            normalSprite4 = [CCSprite spriteWithFile:@"ExtremeMenu.png"];
            selectedSprite4 = [CCSprite spriteWithFile:@"ExtremeMenu.png"];
        }
        
        CCMenuItemSprite *menuItem1 = [CCMenuItemSprite itemFromNormalSprite:normalSprite1 selectedSprite:selectedSprite1 target:self selector:@selector(onLeaderboardsEasy:)];
        CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite2 selectedSprite:selectedSprite2 target:self selector:@selector(onLeaderboardsMedium:)];
		CCMenuItemSprite *menuItem3 = [CCMenuItemSprite itemFromNormalSprite:normalSprite3 selectedSprite:selectedSprite3 target:self selector:@selector(onLeaderboardsHard:)];
		CCMenuItemSprite *menuItem4 = [CCMenuItemSprite itemFromNormalSprite:normalSprite4 selectedSprite:selectedSprite4 target:self selector:@selector(onLeaderboardsExtreme:)];
        
		CCMenu *menu4 = [CCMenu menuWithItems:menuItem3, menuItem4, nil];
		menu4.position = ccp(screenSize.width - [normalSprite2 boundingBox].size.width/2, screenSize.height/4 + 60.0f);
		[menu4 alignItemsVerticallyWithPadding:0];
		[self addChild:menu4];
        
		CCMenu *menu5 = [CCMenu menuWithItems:menuItem1, menuItem2, nil];
		menu5.position = ccp([normalSprite2 boundingBox].size.width/2, screenSize.height/4 + 60.0f);
		[menu5 alignItemsVerticallyWithPadding:0];
		[self addChild:menu5];
        
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
        
        CCSprite* normalSprite5;
        CCSprite* selectedSprite5;
        
        if(isIpad) {
            normalSprite5 = [CCSprite spriteWithFile:@"RadiaMenuBottom-hd.png"];
            selectedSprite5 = [CCSprite spriteWithFile:@"RadiaMenuBottom-hd.png"];
        } else {
            normalSprite5 = [CCSprite spriteWithFile:@"RadiaMenuBottom.png"];
            selectedSprite5 = [CCSprite spriteWithFile:@"RadiaMenuBottom.png"];
        }
        
		CCMenuItemFont *menuItem5 = [CCMenuItemSprite itemFromNormalSprite:normalSprite5 selectedSprite:selectedSprite5 target:self selector:@selector(onRadia:)];
		
		CCMenu *menu2 = [CCMenu menuWithItems:menuItem5, nil];
		menu2.position = ccp(screenSize.width/2,30 + litemodeOffset);
        if(isIpad) {
            menu2.position = ccp(screenSize.width/2,60 + litemodeOffset);
        }
		[menu2 alignItemsVertically];
        
        [self addChild:menu2];
        
        CCSprite* backSprite;
        CCSprite* backSelectedSprite;
        if (isIpad) {
            backSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
        } else {
            backSprite = [CCSprite spriteWithFile:@"BackButton.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
        }
		CCMenuItemSprite *backMenuItem = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSelectedSprite target:self selector:@selector(onHighScoreSelector:)];
        if (isIpad) {
            backMenuItem.position = ccp(-screenSize.width/2 + 70, -screenSize.height/2 + 50 + litemodeOffset);
        } else {
            backMenuItem.position = ccp(-screenSize.width/2 + 35, -screenSize.height/2 + 25 + litemodeOffset);
        }
        
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
		[self addChild:backMenu];
        
        if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) { [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Decisions.mp3" loop:YES]; }
	}
	return self;
}

-(NSString*) formattedHighScore:(float) time
{
	int minutes = time / 60;
	int seconds = (int) time % 60;
	int milliseconds = (int) (time * 100) % 100;
	NSString *formattedTime;
	
	if (seconds < 10)
	{	
		if (milliseconds < 10)
			formattedTime = [NSString stringWithFormat:@"%i:0%i.0%i", minutes, seconds, milliseconds];
		else
			formattedTime = [NSString stringWithFormat:@"%i:0%i.%i", minutes, seconds, milliseconds];
	}
	else
	{	
		if (milliseconds < 10)
			formattedTime = [NSString stringWithFormat:@"%i:%i.0%i", minutes, seconds, milliseconds];
		else
			formattedTime = [NSString stringWithFormat:@"%i:%i.%i", minutes, seconds, milliseconds];
	}	
	return formattedTime;
}

- (void)onHighScoreSelector:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on difficulty");
    HighScoreSelector *HighScoreSelectorLayer = [[HighScoreSelector node] initWithMode:curMode];
    [self.parent addChild:HighScoreSelectorLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[[HighScoreSelector node] initWithMode:curMode]];
}

- (void)onReset:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on reset scores");
	// Create alert popup for confirmation
	UIAlertView* dialog = [[UIAlertView alloc] init];
	[dialog setDelegate:self];
	[dialog setTitle:@"Reset Scores"];
	[dialog setMessage:@"Do you want to reset the high scores?"];
	[dialog addButtonWithTitle:@"Yes"];
	[dialog addButtonWithTitle:@"No"];
	[dialog show];
	[dialog release];
}

-(void) onLeaderboardsEasy:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    NSLog(@"Show Easy Leaderboard");
    [[GameCenterManager sharedGameCenterManager] showLeaderboardForCategory:@"Timed.Survival.Easy"];
}

-(void) onLeaderboardsMedium:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    NSLog(@"Show Medium Leaderboard");
    [[GameCenterManager sharedGameCenterManager] showLeaderboardForCategory:@"Timed.Survival.Medium"];
}

-(void) onLeaderboardsHard:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    NSLog(@"Show Hard Leaderboard");
    [[GameCenterManager sharedGameCenterManager] showLeaderboardForCategory:@"Timed.Survival.Hard"];
}

-(void) onLeaderboardsExtreme:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    NSLog(@"Show Extreme Leaderboard");
    [[GameCenterManager sharedGameCenterManager] showLeaderboardForCategory:@"Timed.Survival.Extreme"];
}

-(void) onRadia:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    NSLog(@"Show Extreme Leaderboard");
    [[GameCenterManager sharedGameCenterManager] showLeaderboardForCategory:@"Endless"];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	// This function catches the button click on the reset confirmation popup
	if (buttonIndex == 0)
	{
		// Yes, reset the scores
		NSString * mode;
		for (int i = 0; i < 4; i++) {
			switch (i) {
				case 0:
					mode = @"easy";
					break;
				case 1:
					mode = @"medium";
					break;
				case 2:
					mode = @"hard";
					break;
				case 3:
					mode = @"extreme";
					break;
				default:
					break;
			}
			NSString *score1 = [mode stringByAppendingString:[NSString stringWithFormat:@"%i", 1]];
			NSString *score2 = [mode stringByAppendingString:[NSString stringWithFormat:@"%i", 2]];
			NSString *score3 = [mode stringByAppendingString:[NSString stringWithFormat:@"%i", 3]];
			
			[[NSUserDefaults standardUserDefaults] setFloat:0 forKey:score3];
			[[NSUserDefaults standardUserDefaults] setFloat:0 forKey:score2];
			[[NSUserDefaults standardUserDefaults] setFloat:0 forKey:score1];
			[[NSUserDefaults standardUserDefaults] synchronize];
		}
		[self init];
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
