//
//  LevelSelect.m
//  Fireballin
//
//  Created by Jeffrey Russell Ellis on 4/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "LiteModeLevelSelect.h"
#import "MenuScene.h"
#import "cocos2d.h"
#import "SlidingMenuGrid.h"
#import "GameScene.h"
#import "SimpleAudioEngine.h"
#import "SpecialPushScene.h"
#import "WorldSelect.h"
#import "CCScrollLayer.h"
#import "CCVideoPlayer.h"

@implementation LiteModeLevelSelect

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	LiteModeLevelSelect *layer = [LiteModeLevelSelect node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) initWithWorld:(int) worldNum
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        
		curWorld = worldNum;
		pushCheck = YES;
        
        self.anchorPoint = CGPointZero;
		self.position = CGPointZero;
		
		id target = self;
		int iMaxLevels = 50;
        int levelsPerPage = 10;
        int iWorldPages = ceil((float)iMaxLevels/10);
        //iMaxLevels = [levels count] - 1 - (curWorld-1)*10;
		//if(iMaxLevels > 10) iMaxLevels = 10;
		
        stars_collected = 0;
		//NSMutableArray* allItems = [NSMutableArray arrayWithCapacity:51];
        for(int worldPage = 1; worldPage <= 1; ++worldPage) 
        {
            if(worldPage == iWorldPages) levelsPerPage = iMaxLevels % levelsPerPage;
            if(levelsPerPage == 0) levelsPerPage = 10;
            int max_unlocked = 1;
            CCLayer *page = [[CCLayer alloc] init];
            for (int i = 1; i <= 5; ++i)
            {
                
                // create a menu item for each character
                NSString* image = [NSString stringWithFormat:@"GlowLevelButtonLocked"];
                NSString* level_string = [NSString stringWithFormat:@"%i", i+10*(worldPage-1)];
                NSString* lock_key_string = [level_string stringByAppendingString:@"Lock"];
                int lock_val = [[NSUserDefaults standardUserDefaults] floatForKey:lock_key_string];
                if (lock_val == 0) {
                    image = [NSString stringWithFormat:@"GlowLevelButtonLocked"];
                }
                else {
                    int num_stars = 0;
                    NSString* star_key_string = [level_string stringByAppendingString:@"Star"];
                    num_stars = [[NSUserDefaults standardUserDefaults] floatForKey:star_key_string];
                    
                    stars_collected += num_stars;
                    
                    switch (num_stars) {
                        case 0:
                            image = [NSString stringWithFormat:@"GlowLevelButtonNoStars"];
                            break;
                        case 1:
                            image = [NSString stringWithFormat:@"GlowLevelButtonOneStar"];
                            break;
                        case 2:
                            image = [NSString stringWithFormat:@"GlowLevelButtonTwoStars"];
                            break;
                        case 3:
                            image = [NSString stringWithFormat:@"GlowLevelButtonThreeStars"];
                            break;
                        default:
                            break;
                    }
                    //YELLOW TO BLACK/WHITE STARS = BLACK&WHITE YELLOW TO 110%
                    max_unlocked++;
                }
                
                NSString* normalImage = [NSString stringWithFormat:@"%@.png", image];
                NSString* selectedImage = [NSString stringWithFormat:@"%@.png", image];
                CCSprite* normalSprite = [CCSprite spriteWithFile:normalImage];
                CCSprite* selectedSprite = [CCSprite spriteWithFile:selectedImage];
                
                // If it's unlocked it can be selected, if not it gets a dummy selector
                CCMenuItemSprite* item;
                if ([image isEqualToString: @"GlowLevelButtonLocked"]) {
                    item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(Dummy:)];
                }
                else {
                    item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:target selector:@selector(LaunchLevel:)];
                }
                item.tag = i+10*(worldPage-1);
                CCMenu *level_icon = [CCMenu menuWithItems:item, nil];
                level_icon.position = ccp(70.0f + 90.0f*((i-1)%5), 190.0f);
                //[self addChild:level_icon];
                [page addChild:level_icon];
            }
            
            for (int i = 1; i < max_unlocked; i++) {
                NSString* level_string = [NSString stringWithFormat:@"%i", i+10*(worldPage-1)];
                CCLabelTTF* level_num_label = [CCLabelTTF labelWithString:level_string fontName:@"Futura" fontSize:40];
                level_num_label.position = ccp(70.0f + 90.0f*((i-1)%5), 200.0f);
                [page addChild:level_num_label z:2];
            }
            [self addChild:page];
			//[allItems addObject:page];
        }
        
        //SlidingMenuGrid* menuGrid = [SlidingMenuGrid menuWithArray:allItems cols:5 rows:2 position:CGPointMake(60.0f, 200.0f) padding:CGPointMake(0.f, 0.f) verticalPages:false];
        //CCScrollLayer *scroller = [[CCScrollLayer alloc] initWithLayers:allItems widthOffset: 0];
        
        //[scroller setPage:curWorld];
        
        //[self addChild:menuGrid];
        //[self addChild:scroller];
        
		// Back Button
		CCSprite* normalSprite = [CCSprite spriteWithFile:@"BackButton.png"];
        CCSprite* selectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
		CCMenuItemSprite *menuItem1 = [CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(onBack:)];
		
		CCMenu *menu = [CCMenu menuWithItems:menuItem1, nil];
		menu.position = ccp(35,25 + 32);
		[menu alignItemsVertically];
		[self addChild:menu];
        
        //Add stars_collected/30 image and text
		CCSprite* starSprite = [CCSprite spriteWithFile:@"Star.png"];
        starSprite.position = ccp(385, 27 + 32);
        if(stars_collected >= 100)
        {
            starSprite.position = ccp(370, 27);
        }
        
        NSString* starsCollectedString = [NSString stringWithFormat:@"%i/%i", stars_collected, 15];
        CCLabelTTF *starsCollectedLabel = [CCLabelTTF labelWithString:starsCollectedString fontName:@"Futura" fontSize:20];
        starsCollectedLabel.position = ccp(440, 25 + 32);
        
        [self addChild:starSprite];
        [self addChild:starsCollectedLabel];
        
		// Add labels
		//CCLabelTTF* level_num_label;
		
        
        if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) { [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Decisions.mp3" loop:YES]; }
        
	}
	return self;
}

- (void)onBack:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on back");
    MenuScene *menuSceneLayer = [MenuScene node];
    [self.parent addChild:menuSceneLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}

-(void)LaunchLevel:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on launch level");
    CCMenuItem *itm = (CCMenuItem *)sender;
    [[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"intro"];
    //[[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"slow"];
    //[[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"invincible"];
    //[[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"destroy"];
    //[[NSUserDefaults standardUserDefaults] setFloat:0 forKey:@"demolish"];
    
    if(itm.tag == 1)
    {
        [CCVideoPlayer setNoSkip:false];
        if([[NSUserDefaults standardUserDefaults] floatForKey:@"intro"] == 0) {
            [CCVideoPlayer setNoSkip:true];
        }
        [[CCDirector sharedDirector] replaceScene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:itm.tag]];
        [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:itm.tag]];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"intro"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(itm.tag == 11 && [[NSUserDefaults standardUserDefaults] floatForKey:@"slow"] == 0)
    {
        [CCVideoPlayer setNoSkip:true];
        [[CCDirector sharedDirector] replaceScene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:itm.tag]];
        [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:itm.tag]];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"slow"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(itm.tag == 21 && [[NSUserDefaults standardUserDefaults] floatForKey:@"invincible"] == 0)
    {
        [CCVideoPlayer setNoSkip:true];
        [[CCDirector sharedDirector] replaceScene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:itm.tag]];
        [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:itm.tag]];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"invincible"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(itm.tag == 31 && [[NSUserDefaults standardUserDefaults] floatForKey:@"destroy"] == 0)
    {
        [CCVideoPlayer setNoSkip:true];
        [[CCDirector sharedDirector] replaceScene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:itm.tag]];
        [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:itm.tag]];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"destroy"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else if(itm.tag == 41 && [[NSUserDefaults standardUserDefaults] floatForKey:@"demolish"] == 0)
    {
        [CCVideoPlayer setNoSkip:true];
        [[CCDirector sharedDirector] replaceScene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:itm.tag]];
        [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:itm.tag]];
        [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"demolish"];
		[[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:itm.tag]]];
    }
    //[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[[Game node] initWithGameDifficulty:HARD setMode:LEVEL levelNum:itm.tag]]];
    //if(pushCheck) [self specialPushLevelBegin:itm.tag];
}

-(void) Dummy: (id) sender
{
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

