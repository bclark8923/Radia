//
//  SpecialPushScene.m
//  Fireballin
//
//  Created by Brian Clark on 5/23/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "SpecialPushScene.h"
#import "CCVideoPlayer.h"
#import "CCTouchDispatcher.h"


@implementation SpecialPushScene

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	SpecialPushScene *layer = [SpecialPushScene node];
	
	// add layer as a child to scene
	[scene addChild: layer z:2];
	
	// return the scene
	return scene;
}

- (id) initAnimations:(int) number
{
    if( (self=[super init] )) {	
        [self initVideo:number];
    }
    return self;
}

- (id) initVideo:(int) number
{
    if( (self=[super init] )) {	
        screenSize = [[CCDirector sharedDirector] winSize];
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        ipadScale = [CCDirector sharedDirector].winSize.width == 1024 ? 2.133333 : 1;

        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        
        wait = 0.0f;
        levelOneWait = 1.0f;
        placed = NO;
        _number = number;
        soundPlayed = NO;
        
        if(isIpad) {
            normalSprite1 = [CCSprite spriteWithFile:@"ContinueButton-hd.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"ContinueButton-hd.png"];
        } else {
            normalSprite1 = [CCSprite spriteWithFile:@"ContinueButton.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"ContinueButton.png"];
        }
        menuItem1 = [CCMenuItemSprite itemFromNormalSprite:normalSprite1 selectedSprite:selectedSprite1 target:self selector:@selector(onResume:)];
        
        continueMenu = [CCMenu menuWithItems:menuItem1, nil];
        
        [continueMenu alignItemsVertically];
        continueMenu.position = ccp(screenSize.width/2, 40.0f*ipadScale);
        //if(isIpad) {
            //continueMenu.position = ccp(screenSize.width/2, 120.0f);
        //}
        
        slowLabel = [CCLabelTTF labelWithString:@"SLOW" fontName:@"Futura" fontSize:25*ipadScale];
        slowLabelCont = [CCLabelTTF labelWithString:@"New Powerup" fontName:@"Futura" fontSize:25*ipadScale];
		slowLabel.position = ccp(screenSize.width/2, screenSize.height - 2.5*screenSize.height/8 - 80.0f*ipadScale);
        slowLabelCont.position = ccp(screenSize.width/2, screenSize.height - 2.5*screenSize.height/8 - 30.0f*ipadScale);
        
        //Intro Animation
        if(number == 1)
        {
            [CCVideoPlayer playMovieWithFile:@"IntroAnimation.m4v"];
            [self schedule:@selector(update:)];
        }
        
        //Slow Intro
        if(number == 11)
        {
            [CCVideoPlayer playMovieWithFile:@"SlowAnimation.m4v"];
            //[self addChild:skipMenu z:20];
            [self schedule:@selector(update:)];
        }
        
        //Slow Unlocked
        if(number == 20)
        {
            //[[SimpleAudioEngine sharedEngine] playEffect:@"UnlockedPowerup.wav"];
            if(isIpad) {
                title = [CCSprite spriteWithFile:@"UnlockedTitle-hd.png"];
            } else {
                title = [CCSprite spriteWithFile:@"UnlockedTitle.png"];
            }
            title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
            title.scale = 0.8;
            
            CCSprite *invincibilitySprite;
            if(isIpad) {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereRed-hd.png"];
            } else {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereRed.png"];
            }            invincibilitySprite.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:invincibilitySprite];
            
            CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"SLOW" fontName:@"Futura" fontSize:30*ipadScale];
            powerupTitle.position = ccp(screenSize.width/2, screenSize.height/2 + 40.0f * ipadScale);
            [self addChild:powerupTitle];
            
            CCLabelTTF* powerupDescrip = [CCLabelTTF labelWithString:@"Now Unlocked in Endless Mode" fontName:@"Futura" fontSize:30*ipadScale];
            powerupDescrip.position = ccp(screenSize.width/2, screenSize.height/2 - 40.0f * ipadScale);
            [self addChild:powerupDescrip];
            
            [self addChild:title];
            [self addChild:continueMenu];
        }
        
        //Invincible Intro
        if(number == 21)
        {
            [CCVideoPlayer playMovieWithFile:@"InvincibleAnimation.m4v"];
            //[self addChild:skipMenu z:20];
            [self schedule:@selector(update:)];
        }
        
        //Invincible Unlocked
        if(number == 30)
        {
            //[[SimpleAudioEngine sharedEngine] playEffect:@"UnlockedPowerup.wav"];
            if(isIpad) {
                title = [CCSprite spriteWithFile:@"UnlockedTitle-hd.png"];
            } else {
                title = [CCSprite spriteWithFile:@"UnlockedTitle.png"];
            }            title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
            title.scale = 0.8;
            
            CCSprite *invincibilitySprite;
            if(isIpad) {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereYellow-hd.png"];
            } else {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereYellow.png"];
            }            invincibilitySprite.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:invincibilitySprite];
            
            CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"INVINCIBLE" fontName:@"Futura" fontSize:30*ipadScale];
            powerupTitle.position = ccp(screenSize.width/2, screenSize.height/2 + 40.0f * ipadScale);
            [self addChild:powerupTitle];
            
            CCLabelTTF* powerupDescrip = [CCLabelTTF labelWithString:@"Now Unlocked in Endless Mode" fontName:@"Futura" fontSize:30*ipadScale];
            powerupDescrip.position = ccp(screenSize.width/2, screenSize.height/2 - 40.0f * ipadScale);
            [self addChild:powerupDescrip];
            
            [self addChild:title];
            [self addChild:continueMenu];
        }
        
        //Destroy Intro
        if(number == 31)
        {
            [CCVideoPlayer playMovieWithFile:@"DestroyAnimation.m4v"];  
            //[self addChild:skipMenu z:20];
            [self schedule:@selector(update:)];   
        }
        
        //Destroy Unlocked
        if(number == 40)
        {
            //[[SimpleAudioEngine sharedEngine] playEffect:@"UnlockedPowerup.wav"];
            if(isIpad) {
                title = [CCSprite spriteWithFile:@"UnlockedTitle-hd.png"];
            } else {
                title = [CCSprite spriteWithFile:@"UnlockedTitle.png"];
            }            title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
            title.scale = 0.8;
            
            CCSprite *invincibilitySprite;
            if(isIpad) {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereGreen-hd.png"];
            } else {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereGreen.png"];
            }            invincibilitySprite.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:invincibilitySprite];
            
            CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"DESTROY" fontName:@"Futura" fontSize:30*ipadScale];
            powerupTitle.position = ccp(screenSize.width/2, screenSize.height/2 + 40.0f * ipadScale);
            [self addChild:powerupTitle];
            
            CCLabelTTF* powerupDescrip = [CCLabelTTF labelWithString:@"Now Unlocked in Endless Mode" fontName:@"Futura" fontSize:30*ipadScale];
            powerupDescrip.position = ccp(screenSize.width/2, screenSize.height/2 - 40.0f * ipadScale);
            [self addChild:powerupDescrip];
            
            [self addChild:title];
            [self addChild:continueMenu];
        }
        
        //Demolish Intro
        if(number == 41)
        {
            [CCVideoPlayer playMovieWithFile:@"DemolishAnimation.m4v"];
            //[self addChild:skipMenu z:20];
            [self schedule:@selector(update:)];
        }
        
        //Demolish Unlocked / Chapter 1 Finished
        if(number == 50)
        {
            [CCVideoPlayer playMovieWithFile:@"FinalAnimation.m4v"];
            //[self addChild:skipMenu z:20];
            [self schedule:@selector(update:)];
        }
        
        //[self addChild:slowLabel];
        //[self addChild:slowLabelCont];
        
        CCParticleSystem* particle_system;
        CCSprite* bg;
        //ccColor4F trailColor;
        if(_number == 20) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level20-1.plist"];
            bg = [CCSprite spriteWithFile:@"redBg.png"];
        } else if(_number == 30) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level30-1.plist"];
            bg = [CCSprite spriteWithFile:@"yellowBg.png"];
        } else if(_number == 40) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level40-1.plist"];
            bg = [CCSprite spriteWithFile:@"greenBg.png"];
        } else if(_number == 50) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level50-1.plist"];
            bg = [CCSprite spriteWithFile:@"darkBg.png"];
        }
        if(_number == 20 || _number == 30 || _number == 40 || _number == 50) {
            if(isIpad) {
                particle_system.endSize = particle_system.endSize * 2;
                particle_system.totalParticles = particle_system.totalParticles * 0.5;
            }
            bg.scale = 3;
            bg.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:bg z:-200];
            particle_system.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA};
            [self addChild:particle_system z:-100];
            particle_system.position = ccp(screenSize.width/2, screenSize.height/2);
            [particle_system resetSystem];
        }
    }
    return self;
}

-(void)skipMovie:(id) sender {
    [CCVideoPlayer cancelPlaying];
}

- (void) update:(ccTime)dt {
    wait += dt;
    
    if(!placed) {
        if(isIpad) {
            normalSprite1 = [CCSprite spriteWithFile:@"ContinueButton-hd.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"ContinueButton-hd.png"];
        } else {
            normalSprite1 = [CCSprite spriteWithFile:@"ContinueButton.png"];
            selectedSprite1 = [CCSprite spriteWithFile:@"ContinueButton.png"];
        }
        menuItem1 = [CCMenuItemSprite itemFromNormalSprite:normalSprite1 selectedSprite:selectedSprite1 target:self selector:@selector(onResume:)];
        
        continueMenu = [CCMenu menuWithItems:menuItem1, nil];
        
        [continueMenu alignItemsVertically];
        continueMenu.position = ccp(screenSize.width/2, 40.0f*ipadScale);
    }
    
    if((wait > 1.0f || ![CCVideoPlayer isPlaying])&& !placed) {
        placed = YES;
        //Intro Animation
        if(_number == 1)
        {
            CCSprite* introText;
            if(isIpad) {
                introText = [CCSprite spriteWithFile:@"ItBegins-hd.png"];
            } else {
                introText = [CCSprite spriteWithFile:@"ItBegins.png"];
            }
            introText.position = ccp(screenSize.width/2, screenSize.height/2 + 40*ipadScale);
            [self addChild:introText];
            
            [self addChild:continueMenu];
        }
        
        //Slow Intro
        if(_number == 11)
        {
            [[SimpleAudioEngine sharedEngine] playEffect:@"NewPowerup.mp3"];
            if(isIpad) {
                title = [CCSprite spriteWithFile:@"NewPowerup-hd.png"];
            } else {
                title = [CCSprite spriteWithFile:@"NewPowerup.png"];
            }
            title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
            title.scale = 0.8;
            
            CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"SLOW" fontName:@"Futura" fontSize:30*ipadScale];
            powerupTitle.position = ccp(screenSize.width/2, screenSize.height/2 + 20 * ipadScale);
            [self addChild:powerupTitle];
            
            CCSprite *invincibilitySprite;
            if(isIpad) {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereRed-hd.png"];
            } else {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereRed.png"];
            }
            invincibilitySprite.position = ccp(screenSize.width/2, screenSize.height/2 - 40 * ipadScale);
            [self addChild:invincibilitySprite];
            
            [self addChild:title];
            [self addChild:continueMenu];
        }
        
        //Invincible Intro
        if(_number == 21)
        {
            if(isIpad) {
                title = [CCSprite spriteWithFile:@"NewPowerup-hd.png"];
            } else {
                title = [CCSprite spriteWithFile:@"NewPowerup.png"];
            }
            title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
            title.scale = 0.8;
            
            CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"INVINCIBLE" fontName:@"Futura" fontSize:30*ipadScale];
            powerupTitle.position = ccp(screenSize.width/2, screenSize.height/2 + 20 * ipadScale);
            [self addChild:powerupTitle];
            
            CCSprite *invincibilitySprite;
            if(isIpad) {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereYellow-hd.png"];
            } else {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereYellow.png"];
            }
            invincibilitySprite.position = ccp(screenSize.width/2, screenSize.height/2 - 40 * ipadScale);
            [self addChild:invincibilitySprite];
            
            [self addChild:title];
            [self addChild:continueMenu];
        }
        
        //Destroy Intro
        if(_number == 31)
        {
            if(isIpad) {
                title = [CCSprite spriteWithFile:@"NewPowerup-hd.png"];
            } else {
                title = [CCSprite spriteWithFile:@"NewPowerup.png"];
            }            title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
            title.scale = 0.8;
            
            CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"DESTROY" fontName:@"Futura" fontSize:30*ipadScale];
            powerupTitle.position = ccp(screenSize.width/2, screenSize.height/2 + 20 * ipadScale);
            [self addChild:powerupTitle];
            
            CCSprite *invincibilitySprite;
            if(isIpad) {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereGreen-hd.png"];
            } else {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereGreen.png"];
            }
            invincibilitySprite.position = ccp(screenSize.width/2, screenSize.height/2 - 40 * ipadScale);
            [self addChild:invincibilitySprite];  
            
            [self addChild:title];
            [self addChild:continueMenu];
        }
        
        //Demolish Intro
        if(_number == 41)
        {
            if(isIpad) {
                title = [CCSprite spriteWithFile:@"NewPowerup-hd.png"];
            } else {
                title = [CCSprite spriteWithFile:@"NewPowerup.png"];
            }            title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
            title.scale = 0.8;
            
            CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"ANNIHILATE" fontName:@"Futura" fontSize:30*ipadScale];
            powerupTitle.position = ccp(screenSize.width/2, screenSize.height/2 + 20 * ipadScale);
            [self addChild:powerupTitle];
            
            CCSprite *invincibilitySprite;
            if(isIpad) {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereDark-hd.png"];
            } else {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereDark.png"];
            }
            invincibilitySprite.position = ccp(screenSize.width/2, screenSize.height/2 - 40 * ipadScale);
            [self addChild:invincibilitySprite];
            
            [self addChild:title];
            [self addChild:continueMenu];
        }
        
        //Demolish Unlocked / Chapter 1 Finished
        if(_number == 50 && [[NSUserDefaults standardUserDefaults] floatForKey:@"demolishRadia"] == 0)
        {
            ChapterComplete = [CCSprite spriteWithFile:@"FinalAnimationComplete.png"];
            ChapterComplete.position = ccp(screenSize.width/2, screenSize.height/2);
            //[self addChild:ChapterComplete z:1];
            
            CCSprite* normalSprite2 = [CCSprite spriteWithFile:@"ContinueButton.png"];
            CCSprite* selectedSprite2 = [CCSprite spriteWithFile:@"ContinueButton.png"];
            CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite2 selectedSprite:selectedSprite2 target:self selector:@selector(onPopImage:)];
            
            continueMenu2 = [CCMenu menuWithItems:menuItem2, nil];
            
            [continueMenu2 alignItemsVertically];
            continueMenu2.position = ccp(screenSize.width/2, 80.0f*ipadScale);
            
            //[self addChild:continueMenu2 z:2];
            
            
            if(isIpad) {
                title = [CCSprite spriteWithFile:@"UnlockedTitle-hd.png"];
            } else {
                title = [CCSprite spriteWithFile:@"UnlockedTitle.png"];
            }            title.position = ccp(screenSize.width/2, screenSize.height - screenSize.height/8);
            title.scale = 0.8;
            
            CCSprite *invincibilitySprite;
            if(isIpad) {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereDark-hd.png"];
            } else {
                invincibilitySprite = [CCSprite spriteWithFile:@"GlowSphereDark.png"];
            }
            invincibilitySprite.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:invincibilitySprite];
            
            CCLabelTTF* powerupTitle = [CCLabelTTF labelWithString:@"ANNIHILATE" fontName:@"Futura" fontSize:30*ipadScale];
            powerupTitle.position = ccp(screenSize.width/2, screenSize.height/2 + 40 * ipadScale);
            [self addChild:powerupTitle];
            
            CCLabelTTF* powerupDescrip = [CCLabelTTF labelWithString:@"Now Unlocked in Endless Mode" fontName:@"Futura" fontSize:30*ipadScale];
            powerupDescrip.position = ccp(screenSize.width/2, screenSize.height/2 - 40 * ipadScale);
            [self addChild:powerupDescrip];
            
            [self addChild:title];
            [self addChild:continueMenu];
            
            [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"demolishRadia"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        } else if (_number == 50) {
            CCSprite *normalSprite2;
            CCSprite *selectedSprite2;
            if(isIpad) {
                normalSprite2 = [CCSprite spriteWithFile:@"ContinueButton-hd.png"];
                selectedSprite2 = [CCSprite spriteWithFile:@"ContinueButton-hd.png"];
            } else {
                normalSprite2 = [CCSprite spriteWithFile:@"ContinueButton.png"];
                selectedSprite2 = [CCSprite spriteWithFile:@"ContinueButton.png"];
            }
            CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite2 selectedSprite:selectedSprite2 target:self selector:@selector(onResume:)];
            
            continueMenu2 = [CCMenu menuWithItems:menuItem2, nil];
            
            [continueMenu2 alignItemsVertically];
            continueMenu2.position = ccp(screenSize.width/2, screenSize.height/2);
            
            [self addChild:continueMenu2];
        }
        
        CCParticleSystem* particle_system;
        CCSprite* bg;
        //ccColor4F trailColor;
        if(_number >= 11 && _number <= 20) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level20-1.plist"];
            bg = [CCSprite spriteWithFile:@"redBg.png"];
        } else if(_number >= 21 && _number <= 30) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level30-1.plist"];
            bg = [CCSprite spriteWithFile:@"yellowBg.png"];
        } else if(_number >= 31 && _number <= 40) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level40-1.plist"];
            bg = [CCSprite spriteWithFile:@"greenBg.png"];
        } else if(_number >= 41 && _number <= 50) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level50-1.plist"];
            bg = [CCSprite spriteWithFile:@"darkBg.png"];
        } else {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level10-1.plist"];
            bg = [CCSprite spriteWithFile:@"blueBg.png"];
        }
        bg.position = ccp(screenSize.width/2, screenSize.height/2);
        bg.scale = 3;
        
        if(isIpad) {
            particle_system.endSize = particle_system.endSize * 2;
            particle_system.totalParticles = particle_system.totalParticles * 0.5;
        }
        [self addChild:bg z:-200];
        particle_system.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA};
        [self addChild:particle_system z:-100];
        particle_system.position = ccp(screenSize.width/2, screenSize.height/2);
        [particle_system resetSystem];
        
        
    }
    if(![CCVideoPlayer isPlaying]&& !soundPlayed) {
        //remove skip
        soundPlayed = YES;
        if(_number == 21 || _number == 31 || _number == 41 || _number == 11) {
            [[SimpleAudioEngine sharedEngine] playEffect:@"NewPowerup.wav"];
        }
        if(_number == 50) {
            //[[SimpleAudioEngine sharedEngine] playEffect:@"UnlockedPowerup.wav"];
        }
    }
    /*if(curLevel == 50 && [[NSUserDefaults standardUserDefaults] floatForKey:@"demolishRadia"] == 1 && ![CCVideoPlayer isPlaying])
    {
        CCSprite* normalSprite2 = [CCSprite spriteWithFile:@"ContinueButton.png"];
        CCSprite* selectedSprite2 = [CCSprite spriteWithFile:@"ContinueButton.png"];
        CCMenuItemSprite *menuItem2 = [CCMenuItemSprite itemFromNormalSprite:normalSprite2 selectedSprite:selectedSprite2 target:self selector:@selector(onPopImage:)];
        
        continueMenu2 = [CCMenu menuWithItems:menuItem2, nil];
        
        [continueMenu2 alignItemsVertically];
        continueMenu2.position = ccp(screenSize.width/2, screenSize.height/2);
        
        [self addChild:continueMenu2];
    }*/
}

- (void)onResume:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on resume");
    [CCVideoPlayer setNoSkip:true];
    [CCVideoPlayer cancelPlaying];
	[[CCDirector sharedDirector] popScene];
}

- (void)onPopImage:(id)sender
{
    [[SimpleAudioEngine sharedEngine] playEffect:@"buttonClick.WAV"];
	NSLog(@"on resume");
    [CCVideoPlayer cancelPlaying];
	[self removeChild:ChapterComplete cleanup:NO];
	[self removeChild:continueMenu2 cleanup:NO];
    
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
