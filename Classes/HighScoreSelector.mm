//
//  Highscores.m
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HighScoreSelector.h"
#import "HighScoresGlobal.h"
#import "Highscores.h"
#import "Difficulty.h"
#import "SimpleAudioEngine.h"
#import "GameCenterManager.h"
#import "cocos2d.h"
#import "SurvivalSelector.h"

@implementation HighScoreSelector

//#define LITEMODE

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HighScoreSelector *layer = [HighScoreSelector node];
	
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
        
        CCSprite* normalSprite2;
        CCSprite* selectedSprite2;
        
        if(isIpad) {
            normalSprite2 = [CCSprite spriteWithFile:@"Local-hd.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"Local-hd.png"];
        } else {
            normalSprite2 = [CCSprite spriteWithFile:@"Local.png"];
            selectedSprite2 = [CCSprite spriteWithFile:@"Local.png"];
        }
        
        CCSprite* normalSprite3;
        CCSprite* selectedSprite3;
        
        if(isIpad) {
            normalSprite3 = [CCSprite spriteWithFile:@"Global-hd.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"Global-hd.png"];
        } else {
            normalSprite3 = [CCSprite spriteWithFile:@"Global.png"];
            selectedSprite3 = [CCSprite spriteWithFile:@"Global.png"];
        }
		
        CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite2 selectedSprite:selectedSprite2 target:self selector:@selector(onLocalLeaderboard:)];
		CCMenuItemSprite *menuItem3 = [CCMenuItemSprite itemFromNormalSprite:normalSprite3 selectedSprite:selectedSprite3 target:self selector:@selector(onGlobalLeaderboard:)];
        
		CCMenu *menu3 = [CCMenu menuWithItems:menuItem2, menuItem3, nil];
		menu3.position = ccp(screenSize.width - [normalSprite2 boundingBox].size.width/2, screenSize.height/4 + 10.0f);
		[menu3 alignItemsVerticallyWithPadding:0];
		[self addChild:menu3];

        CCSprite* backSprite;
        CCSprite* backSelectedSprite;
        if (isIpad) {
            backSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
        } else {
            backSprite = [CCSprite spriteWithFile:@"BackButton.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
        }
		CCMenuItemSprite *backMenuItem = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSelectedSprite target:self selector:@selector(onDifficulty:)];
        if (isIpad) {
            backMenuItem.position = ccp(-screenSize.width/2 + 70, -screenSize.height/2 + 50);
        } else {
            backMenuItem.position = ccp(-screenSize.width/2 + 35, -screenSize.height/2 + 25);
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

- (void)onDifficulty:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on difficulty");
    SurvivalSelector *SurvivalSelectorLayer = [[SurvivalSelector node] init];
    [self.parent addChild:SurvivalSelectorLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[SurvivalSelector node]];
}

- (void)onLocalLeaderboard:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on difficulty");
    Highscores *HighscoresLayer = [[Highscores node] initWithMode:curMode];
    [self.parent addChild:HighscoresLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[[Highscores node] initWithMode:curMode]];
}

- (void)onGlobalLeaderboard:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on difficulty");
    //[[GameCenterManager sharedGameCenterManager] showLeaderboardForCategory:nil];
    HighScoresGlobal *HighScoresGlobalLayer = [[HighScoresGlobal node] initWithMode:curMode];
    [self.parent addChild:HighScoresGlobalLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[[HighScoresGlobal node] initWithMode:curMode]];
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

-(void) onLeaderboards:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    [[GameCenterManager sharedGameCenterManager] showLeaderboardForCategory:@"com.ganbarugames.revolveball.world_1"];
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
