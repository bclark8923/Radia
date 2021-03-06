//
//  WorldSelect.m
//  Fireballin
//
//  Created by Brian Clark on 4/8/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "WorldSelect.h"
#import "LevelSelect.h"
#import "MainMenu.h"
#import "MenuScene.h"
#import "cocos2d.h"
#import "SimpleAudioEngine.h"
#import "CCScrollLayer.h"

@implementation WorldSelect

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WorldSelect *layer = [WorldSelect node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) initWithWorld:(int) curWorld
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
		screenSize = [[CCDirector sharedDirector] winSize];
		
		id target = self;
        int iMaxWorlds = [worlds count];
		iMaxWorlds = 1;
        
        float liteModeOffset = 0.0f;
#ifdef LITEMODE
        liteModeOffset = 32.0f;
#endif
		
		allItems = [[NSMutableArray arrayWithCapacity:51] retain];
		int max_unlocked = 1;
		int sprite_size = 0;
		for (int i = 1; i <= iMaxWorlds; ++i)
		{
            CCLayer *page = [[CCLayer alloc] init];
            
			// create a menu item for each character
			NSString* image = [NSString stringWithFormat:@"GlowWorldLocked"];
			NSString* level_string = [NSString stringWithFormat:@"World-%i", curWorld];
			NSString* lock_key_string = [level_string stringByAppendingString:@"Lock"];
			int lock_val = [[NSUserDefaults standardUserDefaults] floatForKey:lock_key_string];
			if (lock_val == 0) {
				image = [NSString stringWithFormat:@"GlowWorldLocked"];
			}
			//else {
                NSString* world_string = [NSString stringWithFormat:@"GlowWorld"];
                NSString* icon_text = [world_string stringByAppendingFormat:@"%i", i];
				//image = [NSString stringWithFormat:icon_text];
				image = icon_text;
                max_unlocked++;
			//}
			
            if(isIpad) {
                image = [image stringByAppendingString:@"-hd"];
            }
			NSString* normalImage = [NSString stringWithFormat:@"%@.png", image];
			NSString* selectedImage = [NSString stringWithFormat:@"%@.png", image];
			CCSprite* normalSprite = [CCSprite spriteWithFile:normalImage];
			CCSprite* selectedSprite = [CCSprite spriteWithFile:selectedImage];
			
			// If it's unlocked it can be selected, if not it gets a dummy selector
			CCMenuItemSprite* item;
			if ([image isEqualToString: @"GlowWorldLocked"]) {
				item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:self selector:@selector(Dummy:)];
			}
			else {
				item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:target selector:@selector(SelectWorld:)];
			}
            
			sprite_size = item.scaleX;
			item.tag = i;
            CCMenu *worldMenu = [CCMenu menuWithItems: item, nil];
            worldMenu.position = ccp(screenSize.width/2, screenSize.height/2);
            [page addChild:worldMenu];
			[allItems addObject:page];
		}
        
        NSString* newWorldString = [NSString stringWithFormat:@"GlowWorldSoon"];
        
        if(isIpad) {
            newWorldString = [newWorldString stringByAppendingString:@"-hd"];
        }
        NSString* normalImageNew = [NSString stringWithFormat:@"%@.png", newWorldString];
        NSString* selectedImageNew = [NSString stringWithFormat:@"%@.png", newWorldString];
        CCSprite* normalSpriteNew = [CCSprite spriteWithFile:normalImageNew];
        CCSprite* selectedSpriteNew = [CCSprite spriteWithFile:selectedImageNew];
        
        CCMenuItemSprite* newWorld =[CCMenuItemSprite itemFromNormalSprite:normalSpriteNew selectedSprite:selectedSpriteNew target:target selector:@selector(Dummy:)];
        
        CCMenu *worldMenu = [CCMenu menuWithItems: newWorld, nil];
        worldMenu.position = ccp(screenSize.width/2, screenSize.height/2);
        CCLayer *page = [[CCLayer alloc] init];
        [page addChild:worldMenu];
        
        [allItems addObject:page];
        
        if(isIpad) {
            scroller = [[CCScrollLayer alloc] initWithLayers:allItems widthOffset: 360];
        } else {
            scroller = [[CCScrollLayer alloc] initWithLayers:allItems widthOffset: 160];
        }
        [scroller setPage:curWorld];
        
        // finally add the scroller to your scene
        [self addChild:scroller];
        
        CCSprite* backSprite;
        CCSprite* backSelectedSprite;
        if (isIpad) {
            backSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
        } else {
            backSprite = [CCSprite spriteWithFile:@"BackButton.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
        }
		CCMenuItemSprite *backMenuItem = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSelectedSprite target:self selector:@selector(onMenu:)];
        if (isIpad) {
            backMenuItem.position = ccp(-screenSize.width/2 + 70, -screenSize.height/2 + 50);
        } else {
            backMenuItem.position = ccp(-screenSize.width/2 + 35, -screenSize.height/2 + 25);
        }
        
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
        [self addChild:backMenu]; 
        //[menuGrid addChild:menuItem1 z:1 tag:0];
        
        //-------------------
        
        int stars_collected = 0;
        for (int i = 1; i <= iMaxWorlds; ++i)
        {
            for (int j = 1; j <= 50; ++j)
            {
                // create a menu item for each character
                NSString* level_string = [NSString stringWithFormat:@"%i", j+10*(i-1)];
                NSString* lock_key_string = [level_string stringByAppendingString:@"Lock"];
                int lock_val = [[NSUserDefaults standardUserDefaults] floatForKey:lock_key_string];
                if (lock_val != 0) {
                    int num_stars = 0;
                    NSString* star_key_string = [level_string stringByAppendingString:@"Star"];
                    num_stars = [[NSUserDefaults standardUserDefaults] floatForKey:star_key_string];
                    
                    stars_collected += num_stars;
                }
            }
        }
        
        if(isIpad) {
            starSprite = [CCSprite spriteWithFile:@"Star-hd.png"];
            starSprite.position = ccp(960, 682);
        } else {
            starSprite = [CCSprite spriteWithFile:@"Star.png"];
            starSprite.position = ccp(450, 281);
        }
        
        //stars_collected = 222;
        NSString* starsCollectedString = [NSString stringWithFormat:@"Total:%i", stars_collected];
        int totalStarsFontSize = 20;
        if(isIpad) {
            totalStarsFontSize = 40;
            
        }
        starsCollectedLabel = [CCLabelTTF labelWithString:starsCollectedString fontName:@"Futura" fontSize:totalStarsFontSize];
        
        if(isIpad) {
            starsCollectedLabel.position = ccp(850, 682);
            if(stars_collected > 99) {
                starsCollectedLabel.position = ccp(830, 682);
            }
        } else {
            starsCollectedLabel.position = ccp(395, 280);
            if(stars_collected > 99) {
                starsCollectedLabel.position = ccp(390, 280);
            }
        }
        [self addChild:starSprite];
        [self addChild:starsCollectedLabel];
        
        //----------
		
        //make grid its own class and add as a layer
		//[self addChild:menuGrid];
        
        if(![[SimpleAudioEngine sharedEngine] isBackgroundMusicPlaying]) { [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Decisions.mp3" loop:YES]; }
        
	}
	return self;
}

- (void)onMenu:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on menu");
    MenuScene *menuSceneLayer = [MenuScene node];
    [self.parent addChild:menuSceneLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}

-(void) SelectWorld: (id) sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
    CCMenuItem *itm = (CCMenuItem *)sender;
    LevelSelect *LevelSelectLayer = [[LevelSelect node] initWithWorld:itm.tag page:1];
    [self.parent addChild:LevelSelectLayer z:0];
    [self.parent removeChild:self cleanup:YES];
    //[itm release];
    //[[CCDirector sharedDirector] replaceScene:[[LevelSelect node] initWithWorld:itm.tag]];
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
	[allItems release];
    [scroller release];
    //[starSprite release];
    //[starsCollectedLabel release];
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
