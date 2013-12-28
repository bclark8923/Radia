//
//  Highscores.m
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 1/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "HighScoreSelector.h"
#import "Highscores.h"
#import "Difficulty.h"
#import "SurvivalSelector.h"
#import "SimpleAudioEngine.h"
#import "GameCenterManager.h"
#import "CCScrollLayer.h"
#import "cocos2d.h"
#import <UIKit/UIKit.h>
#import <iAd/iAd.h>

@implementation Highscores

//#define LITEMODE

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Highscores *layer = [Highscores node];
	
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
        
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
		
		NSMutableArray* allItems = [[NSMutableArray arrayWithCapacity:51] retain];
#ifdef LITEMODE
        NSMutableArray* pages = [NSMutableArray arrayWithObjects:@"medium", @"collect", nil];
        NSMutableArray* titles = [NSMutableArray arrayWithObjects:@"TImed.png", @"RadiaTitle.png", nil];
#else
        NSMutableArray* pages = [NSMutableArray arrayWithObjects:@"easy", @"medium", @"hard", @"extreme", @"collect", nil];
        NSMutableArray* titles;
        if(isIpad) {
            titles = [NSMutableArray arrayWithObjects:@"Easy-hd.png", @"Medium-hd.png", @"Hard-hd.png", @"Extreme-hd.png", @"RadiaTitle-hd.png", nil];
        } else {
            titles = [NSMutableArray arrayWithObjects:@"Easy.png", @"Medium.png", @"Hard.png", @"Extreme.png", @"RadiaTitle.png", nil];
        }
#endif
        //float difficultyTitleYVal = 5*screenSize.height/8;
        
		//CCLabelTTF *easyTitle = [CCLabelTTF labelWithString:@"Easy" fontName:@"Futura" fontSize:30];
        for(int i = 0; i < [pages count]; i++)
        {
            CCLayer *page = [[CCLayer alloc] init];
            NSString *curItem = [pages objectAtIndex:i];
            CCSprite* easyTitle = [CCSprite spriteWithFile:[titles objectAtIndex:i]];
            easyTitle.scale = 0.75;
            //easyTitle.color = ccc3(0, 150, 250);
            easyTitle.position = ccp(screenSize.width/2, 5*screenSize.height/8);
            [page addChild:easyTitle];
            
            NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];  
            [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *totalEndText = @" Points";
            int highScoreFontSize = 20;
            if(isIpad) {
                highScoreFontSize = 40;
            }
            
            if([[NSUserDefaults standardUserDefaults] stringForKey:[curItem stringByAppendingString:@"1"]] != nil) {
                float num = [[NSUserDefaults standardUserDefaults] floatForKey:[curItem stringByAppendingString:@"1"]];
                if(num) {
                    NSString *formattedOutput = [formatter stringFromNumber:[NSNumber numberWithInteger:(int)num]];
                    
                    formattedOutput = [formattedOutput stringByAppendingString:totalEndText];
                    CCLabelTTF *easy1;
                    if([curItem isEqualToString:@"collect"])
                    {
                        easy1 = [CCLabelTTF labelWithString:formattedOutput fontName:@"Futura" fontSize:highScoreFontSize];
                    }else {
                        easy1 = [CCLabelTTF labelWithString:[self formattedHighScore:num] fontName:@"Futura" fontSize:highScoreFontSize];
                    }
                    easy1.position = ccp(screenSize.width/2, 4*screenSize.height/8);
                    [page addChild:easy1];
                }
            }		
            if([[NSUserDefaults standardUserDefaults] stringForKey:[curItem stringByAppendingString:@"2"]] != nil) {
                float num = [[NSUserDefaults standardUserDefaults] floatForKey:[curItem stringByAppendingString:@"2"]];
                if(num) {
                    NSString *formattedOutput = [formatter stringFromNumber:[NSNumber numberWithInteger:(int)num]];
                    
                    formattedOutput = [formattedOutput stringByAppendingString:totalEndText];
                    CCLabelTTF *easy2;
                    if([curItem isEqualToString:@"collect"])
                    {
                        easy2 = [CCLabelTTF labelWithString:formattedOutput fontName:@"Futura" fontSize:highScoreFontSize];
                    }else{
                        easy2 = [CCLabelTTF labelWithString:[self formattedHighScore:num] fontName:@"Futura" fontSize:highScoreFontSize];
                    }
                    easy2.position = ccp(screenSize.width/2, 3*screenSize.height/8);
                    [page addChild:easy2];
                }
            }
            if([[NSUserDefaults standardUserDefaults] stringForKey:[curItem stringByAppendingString:@"3"]] != nil) {
                float num = [[NSUserDefaults standardUserDefaults] floatForKey:[curItem stringByAppendingString:@"3"]];
                if(num) {
                    NSString *formattedOutput = [formatter stringFromNumber:[NSNumber numberWithInteger:(int)num]];
                    
                    formattedOutput = [formattedOutput stringByAppendingString:totalEndText];
                    CCLabelTTF *easy3;
                    if([curItem isEqualToString:@"collect"])
                    {
                        easy3 = [CCLabelTTF labelWithString:formattedOutput fontName:@"Futura" fontSize:highScoreFontSize];
                    }else{
                        easy3 = [CCLabelTTF labelWithString:[self formattedHighScore:num] fontName:@"Futura" fontSize:highScoreFontSize];
                    }
                    easy3.position = ccp(screenSize.width/2, 2*screenSize.height/8);
                    [page addChild:easy3];
                }
            }
            [allItems addObject:page];
        }
        scroller = [[CCScrollLayer alloc] initWithLayers:allItems widthOffset: 0];
        
        // finally add the scroller to your scene
        [self addChild:scroller];
//#endif
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
		
        CCSprite* normalSprite5 = [CCSprite spriteWithFile:@"ResetMenu.png"];
        CCSprite* selectedSprite5 = [CCSprite spriteWithFile:@"ResetMenu.png"];
        
		CCMenuItemFont *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite5 selectedSprite:selectedSprite5 target:self selector:@selector(onReset:)];
		
		CCMenu *menu2 = [CCMenu menuWithItems:menuItem2, nil];
		menu2.position = ccp(screenSize.width/2,15 + litemodeOffset);
		[menu2 alignItemsVertically];
		//[self addChild:menu2];
        
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
			formattedTime = [NSString stringWithFormat:@"Time: %i:0%i.0%i", minutes, seconds, milliseconds];
		else
			formattedTime = [NSString stringWithFormat:@"Time: %i:0%i.%i", minutes, seconds, milliseconds];
	}
	else
	{	
		if (milliseconds < 10)
			formattedTime = [NSString stringWithFormat:@"Time: %i:%i.0%i", minutes, seconds, milliseconds];
		else
			formattedTime = [NSString stringWithFormat:@"Time: %i:%i.%i", minutes, seconds, milliseconds];
	}	
	return formattedTime;
}

- (void)onDifficulty:(id)sender
{
	NSLog(@"on difficulty");
    Difficulty *DifficultyLayer = [[Difficulty node] initWithMode:curMode];
    [self.parent addChild:DifficultyLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	[[CCDirector sharedDirector] replaceScene:[[Difficulty node] initWithMode:curMode]];
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

- (void)onHighScoreSelector:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on difficulty");
    if([[GameCenterManager sharedGameCenterManager] hasGameCenter])
    {
#ifndef LITEMODE
        NSLog(@"game center api is available");
        HighScoreSelector *HighScoreSelectorLayer = [[HighScoreSelector node] initWithMode:curMode];
        [self.parent addChild:HighScoreSelectorLayer z:0];
        [self.parent removeChild:self cleanup:YES];
        //[[CCDirector sharedDirector] replaceScene:[[HighScoreSelector node] initWithMode:curMode]];
#else
        SurvivalSelector *SurvivalSelectorLayer = [[SurvivalSelector node] init];
        [self.parent addChild:SurvivalSelectorLayer z:0];
        [self.parent removeChild:self cleanup:YES];
        //[[CCDirector sharedDirector] replaceScene:[[SurvivalSelector node] init]];
#endif
    }
    else
    {
        SurvivalSelector *SurvivalSelectorLayer = [[SurvivalSelector node] init];
        [self.parent addChild:SurvivalSelectorLayer z:0];
        [self.parent removeChild:self cleanup:YES];
        //[[CCDirector sharedDirector] replaceScene:[[SurvivalSelector node] init]];
    }
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
		for (int i = 0; i < 5; i++) {
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
				case 4:
					mode = @"collect";
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
        //[self removeChild:scroller];
        [scroller release];
		[self initWithMode:curMode];
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
