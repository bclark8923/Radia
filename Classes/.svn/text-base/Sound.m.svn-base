//
//  Sound.m
//  Fireballin
//
//  Created by Brian Clark on 1/18/12.
//  Copyright (c) 2012 U of Michigan. All rights reserved.
//

#import "Sound.h"
#import "Options.h"
#import "SimpleAudioEngine.h"

@implementation Sound

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Sound *layer = [Sound node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init] )) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
		screenSize = [[CCDirector sharedDirector] winSize];
        
		//CCLabelTTF *title = [CCLabelTTF labelWithString:@"Difficulty" fontName:@"Futura" fontSize:50];
        CCSprite* title;
        if(isIpad) {
            title = [CCSprite spriteWithFile:@"SoundTitle-hd.png"];
        } else {
            title = [CCSprite spriteWithFile:@"SoundTitle.png"];
        }
		title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/6);
		//title.color = ccc3(250, 0, 0);
		[self addChild:title];
        
        float litemodeOffset = 0.0f;
#ifdef LITEMODE
        litemodeOffset = 32.0f;
#endif
        CGAffineTransform trans = CGAffineTransformMakeRotation(M_PI * 0.5);

        CGRect bgFrame = CGRectMake(72.0, 315.0, 250.0, 20.0);
        if(isIpad) {
            bgFrame = CGRectMake(144.0, 630.0, 500.0, 40.0);
        }
        bgSlider = [[UISlider alloc] initWithFrame:bgFrame];
        //bgSlider.transform = CGAffineTransformRotate(bgSlider.transform, 90.0/180*M_PI);
        bgSlider.transform = trans;
        [bgSlider addTarget:self action:@selector(bgSliderAction:) forControlEvents:UIControlEventValueChanged];
        [bgSlider setBackgroundColor:[UIColor clearColor]];
        bgSlider.minimumValue = 0.0;
        bgSlider.maximumValue = 1.0;
        bgSlider.continuous = YES;
        bgSlider.value = [SimpleAudioEngine sharedEngine].backgroundMusicVolume;
        [[[CCDirector sharedDirector] openGLView] addSubview:bgSlider];
        
        int fontSize = 25;
        if(isIpad) {
            fontSize = 50;
        }
        
        NSString* bgString = @"Background";
        CCLabelTTF *bgLabel = [CCLabelTTF labelWithString:bgString fontName:@"Futura" fontSize:fontSize];
        bgLabel.position = ccp(115, 200);
        if(isIpad) {
            bgLabel.position = ccp(230, 400);
        }
        [self addChild:bgLabel];
        
        CGRect fxFrame = CGRectMake(-10.0, 315.0, 250.0, 20.0);
        if(isIpad) {
            fxFrame = CGRectMake(-20.0, 630.0, 500.0, 40.0);
        }
        fxSlider = [[UISlider alloc] initWithFrame:fxFrame];
        //fxSlider.transform = CGAffineTransformRotate(fxSlider.transform, 90.0/180*M_PI);
        fxSlider.transform = trans;
        [fxSlider addTarget:self action:@selector(fxSliderAction:) forControlEvents:UIControlEventValueChanged];
        [fxSlider addTarget:self action:@selector(fxSliderStopped:) forControlEvents:UIControlEventTouchUpInside];
        [fxSlider setBackgroundColor:[UIColor clearColor]];
        fxSlider.minimumValue = 0.0;
        fxSlider.maximumValue = 1.0;
        fxSlider.continuous = YES;
        fxSlider.value = [SimpleAudioEngine sharedEngine].effectsVolume;
        
        [[[CCDirector sharedDirector] openGLView] addSubview:fxSlider];
        
        NSString* fxString = @"Effects";
        CCLabelTTF *fxLabel = [CCLabelTTF labelWithString:fxString fontName:@"Futura" fontSize:fontSize];
        fxLabel.position = ccp(83, 117);
        if(isIpad) {
            fxLabel.position = ccp(163, 234);
        }
        [self addChild:fxLabel];
        
        CCSprite* backSprite;
        CCSprite* backSelectedSprite;
        if (isIpad) {
            backSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton-hd.png"];
        } else {
            backSprite = [CCSprite spriteWithFile:@"BackButton.png"];
            backSelectedSprite = [CCSprite spriteWithFile:@"BackButton.png"];
        }
		CCMenuItemSprite *backMenuItem = [CCMenuItemSprite itemFromNormalSprite:backSprite selectedSprite:backSelectedSprite target:self selector:@selector(onOptions:)];
        if (isIpad) {
            backMenuItem.position = ccp(-screenSize.width/2 + 70, -screenSize.height/2 + 50 + litemodeOffset);
        } else {
            backMenuItem.position = ccp(-screenSize.width/2 + 35, -screenSize.height/2 + 25 + litemodeOffset);
        }
        
        CCMenu *backMenu = [CCMenu menuWithItems:backMenuItem, nil];
        [self addChild:backMenu]; 
        
        CCMenuItemToggle *soundBtn;
        
        if(isIpad) {
            soundBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSoundClick:) items:[CCMenuItemImage itemFromNormalImage:@"SoundOn-hd.png" selectedImage:@"SoundOn-hd.png"], [CCMenuItemImage itemFromNormalImage:@"SoundOff-hd.png" selectedImage:@"SoundOff-hd.png"], nil];
        } else {
            soundBtn = [CCMenuItemToggle itemWithTarget:self selector:@selector(onSoundClick:) items:[CCMenuItemImage itemFromNormalImage:@"SoundOn.png" selectedImage:@"SoundOn.png"], [CCMenuItemImage itemFromNormalImage:@"SoundOff.png" selectedImage:@"SoundOff.png"], nil];
        }
        [soundBtn setSelectedIndex:[[NSUserDefaults standardUserDefaults] floatForKey:@"sound"]];
        
		CCMenu *soundMenu = [CCMenu menuWithItems:soundBtn, nil];
		soundMenu.position = ccp(screenSize.width/2,35 + litemodeOffset);
        if(isIpad) {
            soundMenu.position = ccp(screenSize.width/2, 70 + litemodeOffset);
        }
		[soundMenu alignItemsVertically];
		[self addChild:soundMenu];
    }
	return self;
}

- (void)bgSliderAction:(UISlider *)sender
{
	NSLog(@"on menu");
	//[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = sender.value;
}

- (void)fxSliderAction:(UISlider *)sender
{
	NSLog(@"on menu");
	//[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
    [[SimpleAudioEngine sharedEngine] setEffectsVolume:sender.value];
}

- (void)fxSliderStopped:(UISlider *)sender
{
	NSLog(@"on stopped");
	//[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
    //[[SimpleAudioEngine sharedEngine] setEffectsVolume:sender.value];
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
}

- (void)onOptions:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on options");
    Options *optionsLayer = [Options node];
    [self.parent addChild:optionsLayer z:0];
    [self.parent removeChild:self cleanup:YES];
	//[[CCDirector sharedDirector] replaceScene:[Options node]];
}

- (void)onSoundClick:(id)sender
{
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

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
    [bgSlider removeFromSuperview];
    [fxSlider removeFromSuperview];
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
         
@end
