//
//  HelloWorldScene.m
//  Cocos2DBall
//
//  Created by Ray Wenderlich on 2/17/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "GameScene.h"
#import "CCTouchDispatcher.h"
#import "CCLabelTTF.h"
#import	"FireBall.h"
#import	"Coin.h"
#import "MenuScene.h"
#import "MainMenu.h"
#import "PauseScene.h"
#import "GameOverScene.h"
#import "LevelOverScene.h"
#import "LevelWonScene.h"
#import "SpecialPushScene.h"
#import "Wall.h"
#import "GameCenterManager.h"
#import "AccelerometerSimulation.h"
#import "CCVideoPlayer.h" 
#import "CDXPropertyModifierAction.h"
#import "UIDeviceHardware.h"
#ifdef BETA  
    #import "TestFlight.h"
#endif

#define PTM_RATIO 32.0
#define WALL_X 40
#define WALL_Y 4

//#define DEBUGMODE

//#define LITEMODE

@implementation Game

+ (id)scene {
    CCScene *scene = [CCScene node];
    Game *layer = [Game node];
    [scene addChild:layer];
    return scene;
    
}

- (b2Body *)addBall:(CGPoint)position {
    
    // Create sprite and add it to the layer
    if(isIpad) {
        ball = [CCSprite spriteWithFile:@"GlowPlayer-hd.png" rect:CGRectMake(0, 0, 120, 120)];
        ball.scale = ipadScale * 0.5;
    } else {
        ball = [CCSprite spriteWithFile:@"GlowPlayer.png" rect:CGRectMake(0, 0, 60, 60)];    
    }
    ballBg = [CCSprite spriteWithFile:@"GlowPlayerBg.png"];
    ballBg.scale = ipadScale;
    ballLarge = [CCSprite spriteWithFile:@"GlowPlayerLarge.png"];
    ballLarge.scale = ipadScale;
    ballLarge.visible = NO;
    ball.position = position;
    ballBg.position = position;
    ballLarge.position = position;
    [self addChild:ball];
    [self addChild:ballBg z:-1];
    [self addChild:ballLarge z:1];
    
    // Create ball body and shape
    b2BodyDef ballBodyDef;
    ballBodyDef.type = b2_dynamicBody;
    ballBodyDef.position.Set(position.x/PTM_RATIO, position.y/PTM_RATIO);
    ballBodyDef.userData = ball;
    ballBodyDef.allowSleep = false;
    b2Body *body = _world->CreateBody(&ballBodyDef);
    
    b2CircleShape circle;
    circle.m_radius = 12.5*ipadScale/PTM_RATIO;
    
    b2FixtureDef ballShapeDef;
    ballShapeDef.shape = &circle;
    ballShapeDef.density = 1.0f;
    ballShapeDef.friction = 0.0f;
    ballShapeDef.restitution = 0.0f;
    body->CreateFixture(&ballShapeDef);
    
    return body;
}

- (void)accelerometer:(UIAccelerometer*)accelerometer didAccelerate:(UIAcceleration*)acceleration
{	
	static float prevX=0, prevY=0;
	
//#define kFilterFactor 0.3f
#define kFilterFactor 0.8f // .55
    
    if(firstUseAcc && gameRunning) {
        float newaccelerometerOffset = -acceleration.x;
        //NSLog(@"%f", -acceleration.x);
        if (newaccelerometerOffset > 0.95 ) newaccelerometerOffset = 0.95;
        if (newaccelerometerOffset < 0 ) newaccelerometerOffset *= -1;
        [[NSUserDefaults standardUserDefaults] setFloat:newaccelerometerOffset forKey:@"accelerometerOffset"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        firstUseAcc = NO;
        accelerometerOffset = newaccelerometerOffset;
    }
    
    accelerometerOffset = [[NSUserDefaults standardUserDefaults] floatForKey:@"accelerometerOffset"];

    float preAccelX = acceleration.z < 0 ? acceleration.x + accelerometerOffset : (((1 + acceleration.x) * -1) + (accelerometerOffset - 1));
    float preAccelY = acceleration.z > 0 ? acceleration.y : acceleration.y;
	float accelX = (float) (preAccelX) * kFilterFactor + (1- kFilterFactor)*prevX;
    //NSLog(@"%f Accel X: %f Z: %f", preAccelX, accelX, acceleration.z);
	float accelY = (float) preAccelY * kFilterFactor + (1- kFilterFactor)*prevY;
    globalX = acceleration.x;
    globalY = preAccelX;
    globalZ = acceleration.z;
	
    static float staticX = 0;
    static float staticY = 0;
    if(gameRunning)
    {
        prevX = accelX;
        prevY = accelY;
        
        // accelerometer values are in "Portrait" mode. Change them to Landscape left
        // multiply the gravity by 10
        b2Vec2 gravity( -accelY * maxSpeed, accelX * maxSpeed);
                
        playerS->SetLinearVelocity(gravity);
        
        b2Vec2 friction(playerS->GetLinearVelocity().x * -0.2, playerS->GetLinearVelocity().y * -0.2);
        staticX = -accelY * maxSpeed; //playerS->GetLinearVelocity().x * -0.2;
        staticY = accelX * maxSpeed; //playerS->GetLinearVelocity().y * -0.2;
    }
    if(gameOver) {
        if(killed) {
            b2Vec2 hold( staticX * 0.0, staticY * 0.0);
            playerS->SetLinearVelocity(hold);
        } else {
            staticX *= 0.9;
            staticY *= 0.9;
            b2Vec2 hold( staticX, staticY);
            playerS->SetLinearVelocity(hold);
        }
    }
}

-(void) addWall:(b2PolygonShape&) box 
           posX:(CGPoint) posX
           posY:(CGPoint) posY
            def:(b2FixtureDef) def
           body:(b2Body*&) body
{
    b2Vec2 vertex = b2Vec2(posX.x/PTM_RATIO, posX.y/PTM_RATIO);
    b2Vec2 vertex2 = b2Vec2(posY.x/PTM_RATIO, posY.y/PTM_RATIO);
    
    wallx.push_back(posX);
    wally.push_back(posY);
    
    box.SetAsEdge(vertex, vertex2);
    body->CreateFixture(&def);
}

-(void) initWorld:(int) levelNum worldNum:(int) worldNum
{
    b2Vec2 gravity = b2Vec2(0.0f, 0.0f);
    bool doSleep = true;
    _world = new b2World(gravity, doSleep);
    
    // Create edges around the entire screen
    b2BodyDef groundBodyDef;
    groundBodyDef.position.Set(0,0);
    groundBody = _world->CreateBody(&groundBodyDef);
    b2PolygonShape groundBox;
    b2FixtureDef boxShapeDef;
    boxShapeDef.shape = &groundBox;
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(gameWidth/PTM_RATIO, 0));
    groundBody->CreateFixture(&boxShapeDef);
    groundBox.SetAsEdge(b2Vec2(0,0), b2Vec2(0, gameHeight/PTM_RATIO));
    groundBody->CreateFixture(&boxShapeDef);
    groundBox.SetAsEdge(b2Vec2(0, gameHeight/PTM_RATIO),
                        b2Vec2(gameWidth/PTM_RATIO, gameHeight/PTM_RATIO));
    groundBody->CreateFixture(&boxShapeDef);
    groundBox.SetAsEdge(b2Vec2(gameWidth/PTM_RATIO, gameHeight/PTM_RATIO),
                        b2Vec2(gameWidth/PTM_RATIO, 0));
    groundBody->CreateFixture(&boxShapeDef);
    
    initialX = gameWidth/2;
    initialY = gameHeight/2;
    collectorCoinSpawnTime = 2.0f;
    
    accelerometerOffset = [[NSUserDefaults standardUserDefaults] floatForKey:@"accelerometerOffset"];
    
    NSMutableArray * levels = [MenuScene getLevels:worldNum-1];
    
    if(curMode == COLLECTOR)
    {
        coins = [[[NSMutableArray alloc] initWithObjects:nil] retain];
        powerups = [[[NSMutableArray alloc] initWithObjects:nil] retain];
        destroys = [[[NSMutableArray alloc] initWithObjects:nil] retain];
#ifdef BETA  
        [TestFlight passCheckpoint:@"Endless"];
#endif
    }
    
    if(levels && curMode != COLLECTOR)
    {
        unsigned int curLevelChoice = levelNum;
        //float numLevels = [levels count];
        //if(curLevelChoice > [levels count] - 1) curLevelChoice = 0;
        Level * currentLevel = [levels objectAtIndex:curLevelChoice-1];

        vector<CGPoint> wallStarts = [currentLevel getWallStarts];
        vector<CGPoint> wallEnds = [currentLevel getWallEnds];
        vector<CGPoint> wallAnchor = [currentLevel getWallAnchor];
        vector<float> wallDis = [currentLevel getWallDis];
        vector<float> wallDisStart = [currentLevel getWallDisStart];
        vector<float> wallDisFreq = [currentLevel getWallDisFreq];
        vector<float> wallRotSpeed = [currentLevel getWallRotSpeed];
        vector<BOOL> wallInvis = [currentLevel getWallInvis];
        vector<float> wallInactiveTime = [currentLevel getWallInactiveTime];
        vector<float> wallInactiveAfter = [currentLevel getWallInactiveAfter];
    
        walls = [[[NSMutableArray alloc] initWithObjects:nil] retain]; 
        
        for (unsigned int i = 0; i < wallStarts.size(); i++) 
        {
            b2PolygonShape *groundBoxWall = new b2PolygonShape;
            b2FixtureDef *boxShapeDefWall = new b2FixtureDef;
            b2BodyDef wallBodyDef;
            wallBodyDef.position.Set(wallAnchor.at(i).x*ipadScale/PTM_RATIO, wallAnchor.at(i).y*ipadScale/PTM_RATIO);
            wallBodyDef.type = b2_kinematicBody;
            wallBodyDef.fixedRotation = false;
            wallBodyDef.angularVelocity = wallRotSpeed.at(i)/57.3; //lower is faster 57.2 - 57.4
            boxShapeDefWall->shape = groundBoxWall;
            b2Body *wallBody = _world->CreateBody(&wallBodyDef);
            
            b2Vec2 vertex = b2Vec2((wallStarts.at(i).x*ipadScale - wallAnchor.at(i).x*ipadScale)/PTM_RATIO, (wallStarts.at(i).y*ipadScale - wallAnchor.at(i).y*ipadScale)/PTM_RATIO);
            b2Vec2 vertex2 = b2Vec2((wallEnds.at(i).x*ipadScale - wallAnchor.at(i).x*ipadScale)/PTM_RATIO, (wallEnds.at(i).y*ipadScale - wallAnchor.at(i).y*ipadScale)/PTM_RATIO);
            
            groundBoxWall->SetAsEdge(vertex, vertex2);
            b2Fixture* wallFix;
            if(wallInactiveTime.at(i) == 0)
            {
                wallFix = wallBody->CreateFixture(boxShapeDefWall);
            }
                        
            bool disWall = wallDis.at(i) > 0 ? TRUE : FALSE;
            Wall* newWall = [[[Wall node] initWithVariables:wallStarts.at(i)
                                                       posY:wallEnds.at(i)
                                                 dissappear:disWall
                                                    disTime:wallDis.at(i)
                                                   disStart:wallDisStart.at(i)
                                                    disFreq:wallDisFreq.at(i)
                                                        box:groundBoxWall
                                                   shapeDef:boxShapeDefWall
                                                    fixture:wallFix
                                                  invisWall:wallInvis.at(i)
                                               inactiveTime:wallInactiveTime.at(i)
                                              inactiveAfter:wallInactiveAfter.at(i)
                                                     anchor:wallAnchor.at(i)
                                                   rotSpeed:wallRotSpeed.at(i)
                                                   wallBody:wallBody] retain];
            [walls addObject:newWall];
        }
        
        if(curMode == LEVEL)
        {
#ifdef BETA  
            NSString * testflightstartpointlevel = [NSString stringWithFormat:@"level%i-start", curLevel];
            [TestFlight passCheckpoint:testflightstartpointlevel];
#endif
            coins = [[[NSMutableArray alloc] initWithObjects:nil] retain];
            NSMutableArray* coinsToCopy = [currentLevel getCoins];
            for(Coin* curCoin in coinsToCopy)
            {
                Coin* newCoin = [[[Coin node] initWithVariables:[curCoin getStartTime] 
                                                       duration:[curCoin getEndTime]-[curCoin getStartTime] 
                                                           posX:[curCoin getXPos]*ipadScale
                                                           posY:[curCoin getYPos]*ipadScale
                                                         points:2
                                                         radius:[curCoin getRadius]*ipadScale
                                                       rotSpeed:[curCoin getRotSpeed]
                                                     startAngle:[curCoin getStartAngle]
                                                        ] retain];
                [coins addObject:newCoin];
            }
            
            powerups = [[[NSMutableArray alloc] initWithObjects:nil] retain];
            destroys = [[[NSMutableArray alloc] initWithObjects:nil] retain];
            NSMutableArray* powerupsToCopy = [currentLevel getPowerups];
            for(Powerup* curPowerup in powerupsToCopy)
            {
                NSString* type = [curPowerup getType];
                if ([type isEqualToString:@"TimeSlow"])
                {
                    Powerup* newPowerup = [[[Powerup node] initWithData:[curPowerup getType] 
                                                               setStart:[curPowerup getStartTime] 
                                                            setDuration:[curPowerup getDuration] 
                                                                   setX:[curPowerup getX]*ipadScale
                                                                   setY:[curPowerup getY]*ipadScale
                                                             activeTime:[curPowerup getActiveTime] 
                                                             slowFactor:[curPowerup getSlowFactor]] retain];
                    [powerups addObject:newPowerup];
                }
                else if ([type isEqualToString:@"Invincible"])
                {
                    Powerup* newPowerup = [[[Powerup node] initWithData:[curPowerup getType] 
                                                               setStart:[curPowerup getStartTime] 
                                                            setDuration:[curPowerup getDuration] 
                                                                   setX:[curPowerup getX]*ipadScale
                                                                   setY:[curPowerup getY]*ipadScale
                                                             activeTime:[curPowerup getActiveTime]] retain];
                    [powerups addObject:newPowerup];
                }
                else if ([type isEqualToString:@"Destroy"])
                {
                    Powerup* newPowerup = [[[Powerup node] initWithData:[curPowerup getType] 
                                                               setStart:[curPowerup getStartTime] 
                                                            setDuration:[curPowerup getDuration] 
                                                                   setX:[curPowerup getX]*ipadScale
                                                                   setY:[curPowerup getY]*ipadScale 
                                                             destroyCount:[curPowerup getDestroyCount]] retain];
                    [powerups addObject:newPowerup];
                }
                else if ([type isEqualToString:@"Demolish"])
                {
                    Powerup* newPowerup = [[[Powerup node] initWithData:[curPowerup getType] 
                                                               setStart:[curPowerup getStartTime] 
                                                            setDuration:[curPowerup getDuration] 
                                                                   setX:[curPowerup getX]*ipadScale
                                                                   setY:[curPowerup getY]*ipadScale] retain];
                    [powerups addObject:newPowerup];
                }
            }
            
            [currentLevel setPlayerLoc:&initialX yLoc:&initialY];
            playerX = initialX;
            playerY = initialY;
            
            [currentLevel setCoinsNeeded:&coinsNeeded];
            [currentLevel setFireballs:&spawnDuration speedIncrease:&fireBallSpeedIncrease startSpeed:&fireBallStartSpeed 
                              speedCap:&fireBallSpeedCap
                           fireballCap:&fireBallCap];
			time_limit = [currentLevel getTotalTime];
        }
    }
    
    playerS = [self addBall:ccp(initialX, initialY)];
}

// on "init" you need to initialize your instance
-(id) initWithGameDifficulty:(enum GameDifficulty) difficulty setMode:(enum GameMode) mode levelNum:(int) levelNum worldNum:(int) worldNum
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] ) != nil) {
        
        isIpad = [CCDirector sharedDirector].winSize.width == 1024 ? YES : NO;
        
		screenSize = [[CCDirector sharedDirector] winSize];
        ipadScale = 1;
        if(isIpad) {
            ipadScale = 2.133333;
            CCSprite *topBorder = [CCSprite spriteWithFile:@"iPadTopBorder.png"];
            topBorder.position = ccp(screenSize.width/2, screenSize.height - [topBorder boundingBox].size.height/2);
            //topBorder.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:topBorder z:-99];
        }
        
        gameWidth = 480*ipadScale;
        gameHeight = 320*ipadScale;
        
        ballSpeed = 200; //300 //200
        maxSpeed = 30;   //60  //30
        if(isIpad) {
            maxSpeed = maxSpeed * ipadScale;
        }
        
#ifdef LITEMODE
        NSArray * subviews = [[CCDirector sharedDirector]openGLView].subviews;
        for (ADBannerView *adView in subviews) {
            adView.hidden = YES;
            //[sv release];
        }
#endif
        NSMutableArray *levels = [MenuScene getLevels:worldNum-1];
        curWorld = worldNum;
		gameOver = NO;
		gameRunning = NO;
        initialFireball = YES;
        pushCheck = NO;
        initialOffset = YES;
        newHigh = NO;
        radiaHow = YES;
        dodgeHow = YES;
        killed = NO;
        firstUseAcc = YES;
        
        introMenu = nil;
        levelData = nil;
        oneStarNum = nil;
        twoStarNum = nil;
        threeStarNum = nil;
        dataLevelsMenu = nil;
        currentLevelString = nil;
        dataLevelsImage = nil;
        startMenu = nil;
        radiaHowTo = nil;
        
		[UIApplication sharedApplication].idleTimerDisabled = YES;
		
		fireBalls = [[NSMutableArray alloc] initWithObjects:nil];
        slowFactor = 1.0f;
        playerInvincible = false;
        playerSlowTime = false;
        playerDestroy = false;
        invinceFading = NO;
        tappedBegin = NO;
        slowSoundEnd = NO;
        
        collectorSlow = [[NSUserDefaults standardUserDefaults] floatForKey:@"20Star"] >= 1 ? YES : NO;
        collectorDestroy = [[NSUserDefaults standardUserDefaults] floatForKey:@"30Star"] >= 1 ? YES : NO;
        collectorInvincible = [[NSUserDefaults standardUserDefaults] floatForKey:@"40Star"] >= 1 ? YES : NO;
        collectorDemolish = [[NSUserDefaults standardUserDefaults] floatForKey:@"50Star"] >= 1 ? YES : NO;
        
#ifdef LITEMODE
        collectorSlow = NO;
        collectorDestroy = NO;
        collectorInvincible = NO;
        collectorDemolish = NO;
#endif
        

        
        slowPointsAdd = 0;
        
        destroyAll = NO;
        destroyAllTime = 1.5f;
		
        slowSpawntime = 40.0f; //40
        destroySpawntime = 60.0f; //60
        invincibleSpawntime = 90.0f; //90
        demolishSpawntime = 120.0f; //120
        invincePoints = 0.5;
		
		curDiff = difficulty;
		curMode = mode;
        curLevel = levelNum;

        coinsCollected = 0;
        
        game_time = 0.0f;
		coin_time = 0.0f;
		initial_pause = 0.0f;
        slowTime = 0.0f;
        invincibleTime = 0.0f;
        destroyCount = 0;
        radia_score_time = 0.0f;
        final_delay = 0.0f;
        shredTime = 0.3f;
        curShred = 1;
        killerX = 0.0f;
        killerY = 0.0f;
        failedTime = 2.0f;
        wonTime = 2.0f;
        
        playerX = gameWidth/2.0f;
        playerY = gameHeight/2.0f;
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"CoinCollect2.WAV"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"RadiaDeath.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"slow_end.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"annihilate.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"SlowSound.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Invincible.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"death.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"SpikeKill.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"InvinceFadeOut.wav"];
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"Demolish.wav"];
        
        collectParticle = [CCParticleSystemQuad particleWithFile:@"radiaCollect.plist"];
        dyingParticle = [CCParticleSystemQuad particleWithFile:@"radiaDestroy.plist"];
        [collectParticle stopSystem];
        [dyingParticle stopSystem];
        
        [CCMenuItemFont setFontName:@"Futura"];

        if(curMode == SURVIVAL || curMode == COLLECTOR)
        {
            switch (curDiff) {
                case EASY:
                    spawnDuration = 5.0f;
                    fireBallSpeedIncrease = 5.0f;
                    fireBallStartSpeed = 100.0f;
                    fireBallCap = 3;
                    fireBallSpeedCap = 450;
                    break;
                case MEDIUM:
                    spawnDuration = 5.0f;
                    fireBallSpeedIncrease = 7.5f;
                    fireBallStartSpeed = 150.0f;
                    fireBallCap = 4;
                    fireBallSpeedCap = 450;
                    break;
                case HARD:
                    spawnDuration = 5.0f;
                    fireBallSpeedIncrease = 10.0f;
                    fireBallStartSpeed = 200.0f;
                    fireBallCap = 5;
                    fireBallSpeedCap = 450;
                    break;
                case EXTREME:
                    spawnDuration = 3.0f;
                    fireBallSpeedIncrease = 10.0f;
                    fireBallStartSpeed = 350.0f;
                    fireBallCap = 6;
                    fireBallSpeedCap = 450;
                    break;
                case COLLECT:
                    spawnDuration = 20.0f;
                    fireBallSpeedIncrease = 2.0f;
                    fireBallStartSpeed = 100.0f;
                    fireBallCap = 6;
                    fireBallSpeedCap = 250;
                    break;
                default:
                    break;
            }
        }
            
        [self initWorld:curLevel worldNum:worldNum];
        
        spawn_time = 0.0f;
        int levelFontSize = 20;
        if(isIpad) {
            levelFontSize = 40;
        }
        currentLevelString = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Level: %i", curLevel] fontName:@"Futura" fontSize:levelFontSize];
        currentLevelString.position = ccp(screenSize.width/2, 250);
        if(isIpad) {
            currentLevelString.position = ccp(screenSize.width/2, 600);
        }
        
        if(curMode == SURVIVAL) {
            currentLevelString = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Dodge the saws as long as possible!"] fontName:@"Futura" fontSize:levelFontSize];
            currentLevelString.position = ccp(screenSize.width/2, 220);
            if(isIpad) {
               currentLevelString.position = ccp(screenSize.width/2, 480);
            }
        }
        if(curMode == LEVEL || curMode == SURVIVAL) {
            [self addChild:currentLevelString];
        }
        
        float timerFontSize = 16 * ipadScale;
		timer = [CCLabelTTF labelWithString: @"0:00" fontName:@"Futura" fontSize:timerFontSize];
		timer.position = ccp(35 * ipadScale, screenSize.height - 10 * ipadScale);
        if(isIpad) {
            timer.position = ccp(35 * ipadScale, screenSize.height - 32);
        }
        [self addChild:timer];
        
        float countDownFontSize = 60 * ipadScale;
        countdown = [CCLabelTTF labelWithString: @"" fontName:@"Futura" fontSize:countDownFontSize];
        countdown.position = ccp(screenSize.width/2, screenSize.height - 60.0f * ipadScale);
        if(isIpad) {
            countdown.position = ccp(screenSize.width/2, screenSize.height - 80.0f * ipadScale);
        }
        [self addChild:countdown z:20];
        
        introStarted = YES;
        
#ifdef DEBUGMODE
        NSString *globX = [NSString stringWithFormat:@"Accel X: %f Y: %f Z: %f", globalX, globalY, globalZ];
        accelXlabel = [CCLabelTTF labelWithString:globX fontName:@"Futura" fontSize:16];
        accelXlabel.position = ccp(screenSize.width/2, screenSize.height - 10);
        [self addChild:accelXlabel];
#endif
        firstPass = YES;
        
        if (curMode == COLLECTOR)
        {
            //NSLog(@"%ld", pointsCollected);
            multiplier = 1;
            pointsCollected = 0;
            NSString *lbl = [NSString stringWithFormat:@"Points: %ld", pointsCollected];
            coinCount = [CCLabelTTF labelWithString:lbl dimensions:CGSizeMake(180*ipadScale,20*ipadScale) alignment:CCTextAlignmentRight fontName:@"Futura" fontSize:16*ipadScale];
            coinCount.position = ccp(screenSize.width-100*ipadScale, screenSize.height - 10*ipadScale);
            if(isIpad) {
                coinCount.position = ccp(screenSize.width-100*ipadScale, screenSize.height - 32);
            }
            [self addChild:coinCount];
            
            NSString *lbl2 = [NSString stringWithFormat:@"Combo: %0.1fx", multiplier];
            multiplierLabel = [CCLabelTTF labelWithString:lbl2 dimensions:CGSizeMake(180*ipadScale,20*ipadScale) alignment:CCTextAlignmentLeft fontName:@"Futura" fontSize:16*ipadScale];
            multiplierLabel.position = ccp(100*ipadScale, screenSize.height - 10*ipadScale);
            if(isIpad) {
                 multiplierLabel.position = ccp(100*ipadScale, screenSize.height - 32);
            }
            [self addChild:multiplierLabel];
        }
        
        if (curMode == LEVEL)
        {
            int infoTextFontSize = 16;
            if(isIpad) {
                infoTextFontSize = 32;
            }
            if(curLevel == 1) {
                CCLabelTTF *topString = [CCLabelTTF labelWithString:@"Tilt to move your Radiite" fontName:@"Futura" fontSize:infoTextFontSize];
                CCLabelTTF *firstLevelString = [CCLabelTTF labelWithString: @"Tap the screen to pause" fontName:@"Futura" fontSize:infoTextFontSize];
                firstLevelString.position = ccp (screenSize.width/2, 300);
                topString.position = ccp(screenSize.width/2, 20);
                if(isIpad) {
                    firstLevelString.position = ccp (screenSize.width/2, 680);
                    topString.position = ccp(screenSize.width/2, 40);
                }
                [self addChild:topString];
                [self addChild:firstLevelString];
            }
            totalCoins = [coins count];
            activeCoins = [coins count];
            baseOpacity = 255 * ((float)totalCoins - (float)coinsNeeded)/(float)totalCoins;
            baseOpacity = 127.5 + 127.5;
            if(curMode != LEVEL) baseOpacity = 255;
            [ball setOpacity:baseOpacity];
            NSString *lbl = [NSString stringWithFormat:@"Radia: %i/%i", coinsCollected, totalCoins];
            coinCount = [CCLabelTTF labelWithString:lbl fontName:@"Futura" fontSize:16*ipadScale];
            coinCount.position = ccp(screenSize.width - 50*ipadScale, screenSize.height - 10*ipadScale);
            if(isIpad) {
                coinCount.position = ccp(screenSize.width - 50*ipadScale, screenSize.height - 32);
            }
            [self addChild:coinCount];
            
            if(isIpad) {
                dataLevelsImage = [CCSprite spriteWithFile:@"DataMenuLevels-hd.png"];
            } else {
                dataLevelsImage = [CCSprite spriteWithFile:@"DataMenuLevels.png"];
            }
            dataLevelsImage.position = ccp(screenSize.width/2, screenSize.height/2);
            [self addChild:dataLevelsImage z:2];
            
            CCSprite* resumeNormalSprite;
            CCSprite* resumeSelectSprite;
            if(isIpad) {
                resumeNormalSprite = [CCSprite spriteWithFile:@"beginButton-hd.png"];
                resumeSelectSprite = [CCSprite spriteWithFile:@"beginButton-hd.png"];
            } else {
                resumeNormalSprite = [CCSprite spriteWithFile:@"beginButton.png"];
                resumeSelectSprite = [CCSprite spriteWithFile:@"beginButton.png"];
            }
            CCMenuItemSprite *tapBegin = [CCMenuItemSprite itemFromNormalSprite:resumeNormalSprite selectedSprite:resumeSelectSprite target:self selector:@selector(tapToBegin:)];
            
            startMenu = [CCMenu menuWithItems:tapBegin, nil];
            [startMenu alignItemsVertically];
            startMenu.position = ccp(screenSize.width/2, 50);
            if(isIpad) {
                startMenu.position = ccp(screenSize.width/2, 120);
            }
            [self addChild:startMenu z:10];
             
            CCSprite* startSprite = [CCSprite spriteWithFile:@"StartButton.png"];
            CCSprite* selectedStartSprite = [CCSprite spriteWithFile:@"StartButton.png"];
            CCMenuItemSprite *gameStart = [CCMenuItemSprite itemFromNormalSprite:startSprite selectedSprite:selectedStartSprite target:self selector:@selector(onStart:)];
            
            introMenu = [CCMenu menuWithItems:gameStart, nil];
            introMenu.position = ccp(screenSize.width/2, screenSize.height/2 - 88);
            
            float xPosNums = screenSize.width/2 + 43;
            if(isIpad) {
                xPosNums = screenSize.width/2 + screenSize.width/12;
            }
            
            oneStarNum = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", coinsNeeded] fontName:@"Futura" fontSize:infoTextFontSize];
            oneStarNum.position = ccp(xPosNums, 170.0f);
            if(isIpad) {
                oneStarNum.position = ccp(xPosNums, screenSize.height/2 + screenSize.height/40);
            }
            
            Level * currentLevel = [levels objectAtIndex:curLevel-1];
            
            twoStarNum = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", [currentLevel getCoinsTwoStar]] fontName:@"Futura" fontSize:infoTextFontSize];
            twoStarNum.position = ccp(xPosNums, 145.0f);
            if(isIpad) {
                twoStarNum.position = ccp(xPosNums, screenSize.height/2 - screenSize.height/25);
            }
            
            threeStarNum = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%i", totalCoins] fontName:@"Futura" fontSize:infoTextFontSize];
            threeStarNum.position = ccp(xPosNums, 120.0f);
            if(isIpad) {
                threeStarNum.position = ccp(xPosNums, screenSize.height/2 - screenSize.height/9);
            }
            
            [self addChild:oneStarNum z:3];
            [self addChild:twoStarNum z:3];
            [self addChild:threeStarNum z:3];

            introStarted = NO;
        }
        
        //[CCMenuItemFont setFontSize:24];
        CCSprite* pauseSprite;
        CCSprite* selectedPauseSprite;
        if(isIpad) {
            pauseSprite = [CCSprite spriteWithFile:@"Pause-hd.png"];
            selectedPauseSprite = [CCSprite spriteWithFile:@"Pause-hd.png"];
        } else {
            pauseSprite = [CCSprite spriteWithFile:@"Pause.png"];
            selectedPauseSprite = [CCSprite spriteWithFile:@"Pause.png"];
        }
        CCMenuItemSprite *gamePause = [CCMenuItemSprite itemFromNormalSprite:pauseSprite selectedSprite:selectedPauseSprite target:self selector:@selector(onPause:)];        
        
		CCMenu *menu = [CCMenu menuWithItems:gamePause, nil];
		menu.position = ccp(gameWidth/2,gameHeight/2);
        [menu alignItemsVertically];
        [self addChild:menu];
		
		// schedule a repeating callback on every frame
        [self schedule:@selector(update:)];
        //[CCScheduler sharedScheduler].TimeScale = 0.2;
        
		self.isTouchEnabled = YES;
		self.isAccelerometerEnabled = YES;
        
        [[SimpleAudioEngine sharedEngine] stopBackgroundMusic];
        [self playBGMusic];
        initialMusic = YES;
        if (levelNum == 1 || levelNum == 11 || levelNum == 21 || levelNum == 31 || levelNum == 41) {
            initialMusic = NO;
        }
        
        trailParticle = [CCParticleSystemQuad particleWithFile:@"trail.plist"];
        trailParticle.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE};
        if(isIpad) {
            trailParticle.startSizeVar = 70;
        }
        [self addChild:trailParticle z:-20];
        trailParticle.position = ccp(playerX, playerY);
        [trailParticle resetSystem]; 
        
        
        CCParticleSystem* particle_system;
        if(levelNum >= 11 && levelNum <= 20) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level20-1.plist"];
            ccColor4F trailColor = {0.9f, 0.2f, 0.2f, 0.8f};
            trailParticle.startColor = trailColor;
            bg = [CCSprite spriteWithFile:@"redBg.png"];
        } else if(levelNum >= 21 && levelNum <= 30) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level30-1.plist"];
            ccColor4F trailColor = {0.9f, 0.8f, 0.3f, 0.8f};
            trailParticle.startColor = trailColor;
            bg = [CCSprite spriteWithFile:@"yellowBg.png"];
        } else if(levelNum >= 31 && levelNum <= 40) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level40-1.plist"];
            ccColor4F trailColor = {0.33f, 0.99f, 0.37f, 0.8f};
            trailParticle.startColor = trailColor;
            bg = [CCSprite spriteWithFile:@"greenBg.png"];
        } else if(levelNum >= 41 && levelNum <= 50) {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level50-1.plist"];
            ccColor4F trailColor = {0.9f, 0.2, 0.9f, 0.8f};
            trailParticle.startColor = trailColor;
            bg = [CCSprite spriteWithFile:@"darkBg.png"];
        } else {
            particle_system = [CCParticleSystemQuad particleWithFile:@"level10-1.plist"];
            bg = [CCSprite spriteWithFile:@"blueBg.png"];
        }
        if(isIpad) {
            particle_system.endSize = particle_system.endSize * 2;
            particle_system.totalParticles = particle_system.totalParticles * 0.5;
        }
        bg.scale = ipadScale;
        bg.position = ccp(gameWidth/2, gameHeight/2);
        if(curMode != COLLECTOR) [self addChild:bg z:-200];
        particle_system.blendFunc = (ccBlendFunc){GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA};
        [self addChild:particle_system z:-100];

        particle_system.position = ccp(screenSize.width/2, screenSize.height/2);
        [particle_system resetSystem]; 
        
        if(curMode == COLLECTOR) {
            //FIX THIS
            blueBg = [CCSprite spriteWithFile:@"blueBg.png"];
            blueBg.scale = ipadScale;
            blueBg.position = ccp(gameWidth/2,gameHeight/2);
            [self addChild:blueBg z:-200];
            redBg = nil;
            yellowBg = nil;
            greenBg = nil;
            darkBg = nil;
        }
        
        scale = [[CCDirector sharedDirector] contentScaleFactor];
        
        glColor4f(0.0, 0.0, 1.0, 0.2f);  
        red2 = 0;
        green2 = 0;
        blue2 = 1;
        alpha2 = 0.2;
        if(curMode == LEVEL) {
            if(curLevel >= 11 && curLevel <= 20) {
                red2 = 1;
                green2 = 0;
                blue2 = 0;
                alpha2 = 0.2;
            }
            if(curLevel >= 21 && curLevel <= 30) {
                red2 = 0.7;
                green2 = 0.7;
                blue2 = 0;
                alpha2 = 0.2;
            }
            if(curLevel >= 31 && curLevel <= 40) {
                red2 = 0;
                green2 = 0.7;
                blue2 = 0;
                alpha2 = 0.5;
            }
            if(curLevel >= 41 && curLevel <= 50) {
                red2 = 0.4;
                green2 = 0.2;
                blue2 = 0.7;
                alpha2 = 0.2;
            }
        }
        
        red3 = 0.0;
        green3 = 0.0;
        blue3 = 0.7;
        alpha3 = 0.1;
        if(curMode == LEVEL) {
            if(curLevel >= 11 && curLevel <= 20) {
                red3 = 0.7;
                green3 = 0.0;
                blue3 = 0.0;
                alpha3 = 0.1;
            }
            if(curLevel >= 21 && curLevel <= 30) {
                red3 = 0.3;
                green3 = 0.3;
                blue3 = 0.0;
                alpha3 = 0.1;
            }
            if(curLevel >= 31 && curLevel <= 40) {
                red3 = 0.0;
                green3 = 0.2;
                blue3 = 0.0;
                alpha3 = 0.4;
            }
            if(curLevel >= 41 && curLevel <= 50) {
                red3 = 0.2;
                green3 = 0.05;
                blue3 = 0.3;
                alpha3 = 0.1;
            }
        } 
    }
	return self;
}

- (void)draw {
	//draw the walls
    for (Wall *curWall in walls)
    {
        if([curWall isVisible] && ![curWall isInvisible] && [curWall isActive])
        {
            glEnable(GL_LINE_SMOOTH);
            glEnable(GL_BLEND);
            glColor4f(0.8, 0.9, 1.0, 0.2);  
            glLineWidth(0.25f * scale *ipadScale);
            ccDrawLine([curWall xPoint], [curWall yPoint]);
        
            
            glColor4f(red2, green2, blue2, alpha2);
            glLineWidth(3.0f * scale *ipadScale);
            ccDrawLine([curWall xPoint], [curWall yPoint]);
            
            
            glColor4f(red3, green3, blue3, alpha3); 
            glLineWidth(5.0f * scale *ipadScale);
            ccDrawLine([curWall xPoint], [curWall yPoint]);
            
        }
    }
    glColor4f(1.0, 1.0, 1.0, 0.0);
    glEnable(GL_BLEND);
    
    
    }

- (void) playBGMusic {
    if(curMode == LEVEL ) {
        if(curLevel >= 1 && curLevel <= 10) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg1.mp3"];
        } else if (curLevel >= 11 && curLevel <= 20) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg2.mp3"];
        } else if (curLevel >= 21 && curLevel <= 30) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg3.mp3"];
        } else if (curLevel >= 31 && curLevel <= 40) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg4.mp3"];
        } else if (curLevel >= 41 && curLevel <= 50) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg5.mp3"];
        } else {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg1.mp3"];
        }
    } else if (curMode == COLLECTOR) {
        if(collectorDemolish) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg5.mp3"];
        } else if (collectorDestroy) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg4.mp3"];
        } else if (collectorInvincible) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg3.mp3"];
        } else if (collectorSlow) {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg2.mp3"];
        } else {
            [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"gameBg1.mp3"];
        }
    } else {
        [[SimpleAudioEngine sharedEngine] playBackgroundMusic:@"Endless_Mode.mp3"];
    }
}

- (void) update:(ccTime)dt {
    if (curMode == LEVEL) {
		float time_left = time_limit - game_time;
        if(time_left < 0) time_left = 0;
		minutes = time_left / 60;
		seconds = (int) time_left % 60;
		milliseconds = (int) (time_left * 100) % 100;
	}
	else {
		minutes = game_time / 60;
		seconds = (int) game_time % 60;
		milliseconds = (int) (game_time * 100) % 100;
	}
	
	if (seconds < 10)
	{	
		if (milliseconds < 10)
			[timer setString:[NSString stringWithFormat:@"%i:0%i.0%i", minutes, seconds, milliseconds]];
		else
			[timer setString:[NSString stringWithFormat:@"%i:0%i.%i", minutes, seconds, milliseconds]];
	}
	else
	{	
		if (milliseconds < 10)
			[timer setString:[NSString stringWithFormat:@"%i:%i.0%i", minutes, seconds, milliseconds]];
		else
			[timer setString:[NSString stringWithFormat:@"%i:%i.%i", minutes, seconds, milliseconds]];
	}
    
    if (curMode == LEVEL) {
        [coinCount setString:[NSString stringWithFormat:@"Radia: %i/%i", coinsCollected, totalCoins]];
    }
    
    if (curMode == COLLECTOR)
    {
        [timer setString:@""];
        [coinCount setString:[NSString stringWithFormat:@"Points: %ld", pointsCollected]];
        
        [multiplierLabel setString:[NSString stringWithFormat:@"Combo: %0.1fx", multiplier]];
    }
    
#ifdef DEBUGMODE
    [accelXlabel setString:[NSString stringWithFormat:@"Accel X: %f Y: %f Z: %f", globalX, globalY, globalZ]];
#endif
    
    if(curMode == COLLECTOR) {
        if((int)game_time % 200 >= 0 && (int)game_time % 200 <= 30) {
            if(darkBg) {
                [self removeChild:darkBg cleanup:NO];
                darkBg = nil;
            }
            blueBg.opacity = 255;
        }
        
        if((int)game_time % 200 >= 30 && (int)game_time % 200 <= 40) {
            if(!redBg) {
                redBg = [CCSprite spriteWithFile:@"redBg.png"];
                redBg.scale = ipadScale;
                redBg.position = ccp(gameWidth/2,gameHeight/2);
                [self addChild:redBg z:-200];
            } 
            float temp = fmod(game_time, 200) - 30;
            blueBg.opacity = ((10 - temp) / 10) * 255;
            redBg.opacity = (temp/10) * 255;
        }
        
        if((int)game_time % 200 >= 40 && (int)game_time % 200 <= 70) {
            if(blueBg) {
                [self removeChild:blueBg cleanup:NO];
                blueBg = nil;
            }            
            redBg.opacity = 255;
        }
        
        if((int)game_time % 200 >= 70 && (int)game_time % 200 <= 80) {
            if(!yellowBg) {
                yellowBg = [CCSprite spriteWithFile:@"yellowBg.png"];
                yellowBg.scale = ipadScale;
                yellowBg.position = ccp(gameWidth/2,gameHeight/2);
                [self addChild:yellowBg z:-200];
            } 
            float temp = fmod(game_time, 200) - 70;
            redBg.opacity = ((10 - temp) / 10) * 255;
            yellowBg.opacity = (temp/10) * 255;
        }
        
        if((int)game_time % 200 >= 80 && (int)game_time % 200 <= 110) {
            if(redBg) {
                [self removeChild:redBg cleanup:NO];
                redBg = nil;
            }            
            yellowBg.opacity = 255;
        }
        
        if((int)game_time % 200 >= 110 && (int)game_time % 200 <= 120) {
            if(!greenBg) {
                greenBg = [CCSprite spriteWithFile:@"greenBg.png"];
                greenBg.scale = ipadScale;
                greenBg.position = ccp(gameWidth/2,gameHeight/2);
                [self addChild:greenBg z:-200];
            } 
            float temp = fmod(game_time, 200) - 110;
            yellowBg.opacity = ((10 - temp) / 10) * 255;
            greenBg.opacity = (temp/10) * 255;
        }
        
        if((int)game_time % 200 >= 120 && (int)game_time % 200 <= 150) {
            if(yellowBg) {
                [self removeChild:yellowBg cleanup:NO];
                yellowBg = nil;
            }            
            greenBg.opacity = 255;
        }
        
        if((int)game_time % 200 >= 150 && (int)game_time % 200 <= 160) {
            if(!darkBg) {
                darkBg = [CCSprite spriteWithFile:@"darkBg.png"];
                darkBg.scale = ipadScale;
                darkBg.position = ccp(gameWidth/2,gameHeight/2);
                [self addChild:darkBg z:-200];
            } 
            float temp = fmod(game_time, 200) - 150;
            greenBg.opacity = ((10 - temp) / 10) * 255;
            darkBg.opacity = (temp/10) * 255;
        }
        
        if((int)game_time % 200 >= 160 && (int)game_time % 200 <= 190) {
            if(greenBg) {
                [self removeChild:greenBg cleanup:NO];
                greenBg = nil;
            }            
            darkBg.opacity = 255;
        }
        
        if((int)game_time % 200 >= 190 && (int)game_time % 200 <= 200) {
            if(!blueBg) {
                blueBg = [CCSprite spriteWithFile:@"blueBg.png"];
                blueBg.scale = ipadScale;
                blueBg.position = ccp(gameWidth/2,gameHeight/2);
                [self addChild:blueBg z:-200];
            } 
            float temp = fmod(game_time, 200) - 190;
            darkBg.opacity = ((10 - temp) / 10) * 255;
            blueBg.opacity = (temp/10) * 255;
        }
    }
    
    if(!initialMusic) {
        initialMusic = YES;
        [self playBGMusic];
    }
    
	if(introStarted) initial_pause += dt;
    if(!introStarted && !gameOver) radia_score_time += dt;
    
    [[UIAccelerometer sharedAccelerometer] setDelegate:self];
    [[UIAccelerometer sharedAccelerometer] setUpdateInterval:(1.0f / 60.0f)];
    
    if(tappedBegin && !introStarted){
        [self startGame];
    }
    
    if(!gameRunning && introStarted && !gameOver)
    {
        //output 3-inital_pause
        int countdownTime = ceil(3.0f-initial_pause);
        [countdown setString:[NSString stringWithFormat:@"%i", countdownTime]];
    }
    
	if(initial_pause > 3.0f && !gameRunning && !gameOver) 
    {
        gameRunning = YES;
        [countdown setString:[NSString stringWithFormat:@""]];
        game_time = 0.0f;
    }
    
    if(!gameRunning && initialFireball && !gameOver)
    {
        //if(curLevel != 1 || (curLevel == 1 && introStarted)) {
            [self createFireball];
            initialFireball = NO;
        //}
    }
    firstPass = NO;
    
    if(gameOver) {
        		
        
        _world->Step(dt, 10, 10);
        
        CCSprite *ballData;
        
        for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {    
            if (b->GetType() == b2_dynamicBody) {
                ballData = (CCSprite *)b->GetUserData();
                ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                        b->GetPosition().y * PTM_RATIO);
            }
        }
        
        ballLarge.position = ccp(ballData.position.x, ballData.position.y);
        ballBg.position = ccp(ballData.position.x, ballData.position.y);
        
        for (CCSprite* destroySprite in destroys)
        {
            int playerXPosition = playerS->GetPosition().x * PTM_RATIO;
            int playerYPosition = playerS->GetPosition().y * PTM_RATIO;
            destroySprite.position = ccp(playerXPosition, playerYPosition);
            //destroySprite.anchorPoint = ccp(playerXPosition, playerYPosition);
            destroySprite.rotation += 5;
        }
        
        if(curMode == LEVEL || curMode == COLLECTOR){
            for (Coin *curCoin in coins)
            {
                [curCoin stopSound];
                //[curCoin updateLifetime:dt];
            }
        }
        if(!killed) { 
            if(curMode == LEVEL)
            {
                if(coinsCollected >= coinsNeeded)
                {
                    //cool winning animation
                    wonTime -= dt;
                    ballLarge.visible = YES;
                    ballLarge.opacity = (2 - wonTime) * 127.5;
                    
                    if(wonTime <= 0) {
                        [self sendToGameDone];
                    }
                } else {
                    //cool losing animation
                    failedTime -= dt;
                    static float dtTotal = 0;
                    dtTotal += dt;
                    ball.opacity -= dt*50;
                    if(failedTime <= 0) {
                        [self sendToGameDone];
                    }               
                }
            } else {
                [self sendToGameDone];
            }
        } else {
            final_delay += dt;
            shredTime += dt;
            if(shredTime >= 0.11f) {
                float adjacent = ball.position.x-killerX;
                float opposite = ball.position.y-killerY;
                
                // calculate angle
                float angle = atan2f(adjacent, opposite); // radians over the x plane (anticlockwise)
                
                // convert to cocos2d
                angle = CC_RADIANS_TO_DEGREES(angle); // convert to degrees
                //angle -= 90; // rotate
                //angle *= -1;
                
                shredTime = 0.0f;
                if(curShred < 16){  
                    CCTexture2D *newTexture=[[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"ShredRadia%i.png", curShred]]]autorelease];  
                    [ball setTexture:newTexture];
                    float shredAngle = angle + (((float)curShred/16) * 360) - 20;
                    ball.rotation = shredAngle; 
                    curShred++;  
                }
            }
            
            for (FireBall *curFireBall in fireBalls)
            {
                if(![curFireBall isUsed])
                {   
                    [curFireBall rotate:dt];
                }
            }
            if(final_delay > 1.5f) {
                [self sendToGameDone];
            }
        }
    }
    
	if(gameRunning)
	{
		game_time += dt;
		spawn_time += dt;
		coin_time += dt;
        
        if(curMode == LEVEL && game_time > time_limit) [self endGame];
        
        if(curMode == LEVEL || curMode == SURVIVAL) {
            if(currentLevelString) {
                [self removeChild:currentLevelString cleanup:YES];
                currentLevelString = nil;
            }
		}
        _world->Step(dt, 10, 10);
        
        CCSprite *ballData;
        
        for(b2Body *b = _world->GetBodyList(); b; b=b->GetNext()) {    
            if (b->GetType() == b2_dynamicBody) {
                ballData = (CCSprite *)b->GetUserData();
                ballData.position = ccp(b->GetPosition().x * PTM_RATIO,
                                        b->GetPosition().y * PTM_RATIO);
                //ballData.rotation = -1 * CC_RADIANS_TO_DEGREES(b->GetAngle());
            }
        }
        
        if(curMode == LEVEL) {
            if(curLevel == 1) {
                if(game_time > 2 && radiaHow) {
                    if(isIpad) {
                        radiaHowTo = [CCSprite spriteWithFile:@"RadiaCollect-hd.png"];
                    } else {
                        radiaHowTo = [CCSprite spriteWithFile:@"RadiaCollect.png"];
                    }
                    radiaHowTo.position = ccp(40*ipadScale,190*ipadScale);
                    [self addChild:radiaHowTo z:2];
                    radiaHow = NO;
                }
                //do check for spike
                if(dodgeHow) {
                    if(isIpad) {
                        dodgeHowTo = [CCSprite spriteWithFile:@"DodgeAvoid-hd.png"];
                        dodgeHowToText = [CCSprite spriteWithFile:@"DodgeAvoidText-hd.png"];
                    } else {
                        dodgeHowTo = [CCSprite spriteWithFile:@"DodgeAvoid.png"];
                        dodgeHowToText = [CCSprite spriteWithFile:@"DodgeAvoidText.png"];
                    }
                    dodgeHowTo.position = ccp(240,160);
                    dodgeHowToText.position = ccp(240,160);
                    [self addChild:dodgeHowTo z:2];
                    [self addChild:dodgeHowToText z:2];
                    dodgeHow = NO;
                }
                for (FireBall *curFireBall in fireBalls) {
                    static float modX = 1;
                    static float modY = -1;
                    if([curFireBall getYPos] > 220 * ipadScale){
                        //flip up
                        dodgeHowTo.scaleY = 1;
                        modY = -1;
                    } else if ([curFireBall getYPos] < 100 * ipadScale) {
                        //flip down]
                        dodgeHowTo.scaleY = -1;
                        modY = 1;
                    }
                    if(modY == 1) dodgeHowTo.scaleY = -1;
                    if(modY == -1) dodgeHowTo.scaleY = 1;
                    
                    if([curFireBall getXPos] > 380 *ipadScale){
                        //flip left
                        dodgeHowTo.scaleX = 1;
                        modX = -1;
                    } else if ([curFireBall getXPos] < 100 *ipadScale) {
                        //flip right
                        dodgeHowTo.scaleX = -1;
                        modX = 1;
                    }
                    if(modX == 1) dodgeHowTo.scaleX = -1;
                    if(modX == -1) dodgeHowTo.scaleX = 1;
                    dodgeHowTo.position = ccp([curFireBall getXPos] + 10 * modX *ipadScale, [curFireBall getYPos] + 10 * modY *ipadScale);
                    dodgeHowToText.position = ccp([curFireBall getXPos] + 60 * modX *ipadScale, [curFireBall getYPos] + 70 * modY *ipadScale);
                }
            }
        }
        
        playerX = ballData.position.x;
        playerY = ballData.position.y;
        
        ballBg.position = ccp(playerX, playerY);
        ballLarge.position = ccp(playerX, playerY);
        trailParticle.position = ccp(playerX, playerY);
        
        for (Wall *curWall in walls)
        {
            [curWall move:dt world:groundBody];
            if([curWall isActive])
            {
                [curWall decreaseInactiveAfter:dt b2body:groundBody];
                /*if([curWall decreaseInactiveAfter:dt b2body:groundBody])
                {
                    [curWall turnOff:groundBody];
                }*/
                //if disappearing wall
                if([curWall disappearing])
                {
                    //NSLog(@"disappearing");
                    //if disappear start
                    if([curWall getActiveDisappear])
                    {
                        if([curWall getCurrentlyDisappeared])
                        {
                            //NSLog(@"bring back wall");
                            //if currently away, count down timer til comes back
                            [curWall decreaseTimeToReappear:dt];
                            //NSLog(@"%f", [curWall getTimeToReappear]);
                        }
                        else 
                        {
                            //if currently visible, count down timer til disappear
                            [curWall decreaseTimeToDisappear:dt];
                            //NSLog(@"%f",[curWall getTimeToNextDisappear]);
                        }
                        
                        //if disappear time < 0, disappear
                        if([curWall getTimeToNextDisappear] < 0 && [curWall getCurrentlyDisappeared] == FALSE)
                        {
                            [curWall turnOff:groundBody];
                        }
                        
                        //if reappear time < 0, reappear
                        if([curWall getTimeToReappear] < 0 && [curWall getCurrentlyDisappeared] == TRUE)
                        {
                            [curWall turnOn:groundBody];
                        }
                    }
                    if(game_time > [curWall disStartTime] && ![curWall disBegun])
                    {
                        //NSLog(@"set initial");
                        [curWall setInitialDisappear];
                    }
                }
            }
            else
            {
                //decrease time until active
                [curWall decreaseInactive:dt b2body:groundBody];
            }
        }
        
		//check for player collisions (CNode)
        //NSMutableArray *deadFireballs = [[NSMutableArray alloc] init];
        float NumFireballs = 0;
		for (FireBall *curFireBall in fireBalls)
		{
            float curX = 0.0f;
            float curY = 0.0f;
            if([curFireBall isUsed] && ![curFireBall fadeOutComplete])
            {
                [curFireBall fadeOout:dt];
            }
                     
			if ([curFireBall getIsAlive] && ![curFireBall isUsed]) {
				float fPlayerToFireball = pow(fabs(ballData.position.x - [curFireBall getXPos]), 2) 
											   + pow(fabs(ballData.position.y - [curFireBall getYPos]), 2);
                //NSLog(@"%f - %f",fireBallSize, fPlayerToFireball);
				if(fPlayerToFireball < fireBallSize)
				{
					//player hit fireball
                    if (destroyCount)
                    {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"SpikeKill.wav" pitch:1 pan:0 gain:5];
                        
                        [self removeChild:[curFireBall getSprite] cleanup:YES];
                        //[fireBalls removeObject:curFireBall];
                        [curFireBall use];
                        
                        [self addChild:[curFireBall getSprite]];
                        destroyCount --;
                        if(curMode == LEVEL) fireBallCap--;
                        pointsCollected += 5000;
                        spawn_time = 0.0f;
                        
                        [self removeChild:[destroys objectAtIndex:[destroys count]-1] cleanup:YES];
                         
                        [destroys removeLastObject];
                        
                        int curDestroy = 1;
                        int baseAngle = 0;
                        if(destroyCount != 0)
                        {
                            CCSprite* firstDestroy = [destroys objectAtIndex:0]; 
                            baseAngle = firstDestroy.rotation;
                        }
                        for (CCSprite* destroySprite in destroys)
                        {
                            destroySprite.rotation = baseAngle + (360/(destroyCount)) * curDestroy;
                            curDestroy++;
                        }
                    }
					else if(!playerInvincible) {
                        [[SimpleAudioEngine sharedEngine] playEffect:@"death.wav"];
                        [curFireBall isKiller];
                        killerX = [curFireBall getSprite].position.x;
                        killerY = [curFireBall getSprite].position.y;
                        killed = YES;
                        [self endGame];
                    }
                    
                    if(playerInvincible)
                    {
                        invincePoints -= dt;
                        if(invincePoints <= 0){
                            pointsCollected += 50;
                            invincePoints = 0.5;
                        }
                    }
				}
			}
            if([curFireBall fadeOutComplete])
            {
                [self removeChild:[curFireBall getSprite] cleanup:YES];
                if(playerSlowTime)
                {
                    [self removeChild:[curFireBall getSlowSprite] cleanup:YES];
                }
            }
            if([curFireBall getIsAlive] && ![curFireBall isUsed]) NumFireballs++;
            
            if(![curFireBall isUsed] && ![curFireBall fadeOutComplete])
            {
                if(playerSlowTime && slowTime - game_time < 3.0f)
                {
                    if(!slowSoundEnd) {
                        slowSound = [[SimpleAudioEngine sharedEngine] playEffect:@"slow_end.wav"];
                        slowSoundEnd = YES;
                    }
                    
                    [curFireBall setSlowOpacity:88.75*sin(game_time*10)+141.25];
                    
                }
                
                [curFireBall updateLifetime:dt];
                BOOL m_bCollided = NO;
                curX = [curFireBall getXPos];
                curY = [curFireBall getYPos];
                
                [curFireBall movePos:dt/slowFactor];
                
                //update speed
                if(/*curMode == SURVIVAL || (curMode == LEVEL && */[curFireBall getSpeed] < fireBallSpeedCap){
                    [curFireBall addSpeed:dt*fireBallSpeedIncrease * ipadScale];
                }
                
                CCSprite *curSprite = [curFireBall getSprite];
                float fSpriteWidth = [curSprite boundingBox].size.width;
                float fSpriteHeight = [curSprite boundingBox].size.height;
                float spriteOffset = 25.0f * ipadScale;
                
                //if pos.x > 480 - size/2, hits right
                if(curSprite.position.x > screenSize.width - fSpriteWidth/2 + spriteOffset)
                {
                    float curAngle = [curFireBall getAngle];
                    float newAngle = 0.0f;
                    if(curAngle > 0.0f) newAngle = (1.57 - curAngle) + 1.57;
                    if(curAngle <= 0.0f) newAngle = -1.57 - (1.57 + curAngle);
                    [curFireBall setAngle:newAngle];
                    m_bCollided = YES;
                    curX -= 5;
                }
                //if pos.x < 0 + size/2, hits left
                if(curSprite.position.x < fSpriteWidth/2 - spriteOffset)
                {
                    float curAngle = [curFireBall getAngle];
                    float newAngle = 0.0f;
                    if(curAngle > 0.0f) newAngle = 1.57 - (curAngle - 1.57);
                    if(curAngle <= 0.0f) newAngle = -1.57 - (curAngle + 1.57);
                    [curFireBall setAngle:newAngle];
                    m_bCollided = YES;
                    curX += 5;
                }
                //if pos.y > 320 - size/2, hits top
                if(curSprite.position.y > gameHeight - fSpriteHeight/2 + spriteOffset)
                {
                    [curFireBall setAngle:-[curFireBall getAngle]];
                    m_bCollided = YES;
                    curY -= 5;
                }
                //if pos.y < 0 + size/2, hits bottom
                if(curSprite.position.y < fSpriteHeight/2 - spriteOffset)
                {
                    [curFireBall setAngle:-[curFireBall getAngle]];
                    m_bCollided = YES;
                    curY += 5;
                }
                
                if(m_bCollided)
                {
                    [curFireBall setPos:curX setYPos:curY];
                    [curFireBall movePos:dt/slowFactor];
                }
                
                if(curSprite.position.x > 480 * ipadScale || curSprite.position.x < 0) {
                    [curFireBall resetRandomPos];
                }
                
                if(curSprite.position.y > 320 * ipadScale || curSprite.position.y < 0) {
                    [curFireBall resetRandomPos];
                }
            }
		}
        
        if(curMode == COLLECTOR)
        {
            if(game_time > 200){
                spawnDuration = 5.0f;   
                fireBallCap = 7;
            }
            if(game_time > 400)
            {
                spawnDuration = 2.5f;
                fireBallCap = 8;
            }
            collectorCoinSpawnTime -= dt;
            int powerupoffset = 10 * ipadScale;
            if(collectorCoinSpawnTime < 0)
            {
                float coinBaseSpawn = 4;
                if(game_time > 90) coinBaseSpawn = 3;
                
                float coinBase = 1;
                if(game_time > 60) coinBase = 2;
                if(game_time > 120) coinBase = 3;
                float coinsToSpawn = ((arc4random() % 4) + coinBase);
                for (int i = 0; i < coinsToSpawn; i++)
                {
                    Coin* newCoin = [[[Coin node] initWithVariables:game_time 
                                                           duration:(arc4random() % 4) + coinBaseSpawn
                                                               posX:(float)(arc4random() % 460 * ipadScale) + powerupoffset
                                                               posY:(float)(arc4random() % 300 * ipadScale) + powerupoffset
                                                             points:(arc4random() % 20) + 20
                                      radius:0 rotSpeed:0 startAngle:0] retain];
                    [coins addObject:newCoin];
                }
                collectorCoinSpawnTime = (arc4random() % 4) + coinBaseSpawn;
            }
            
            if(collectorSlow)
            {
                slowSpawntime -= dt;
                if(slowSpawntime < 0)
                {
                    float activeTimeLocal = (float)(arc4random() % 11) + 5;
                    float slowFactorLocal = (arc4random() % 6) + 1.5;
                    float slowDurationFactor = activeTimeLocal + slowFactorLocal - 6.5;
                    float slowDurationLocal =  2 + ((17 - slowDurationFactor)/3);  //from 2 to 5 based on slowDurationFactor
                    Powerup* newPowerup = [[[Powerup node] initWithData:@"TimeSlow"
                                                               setStart:game_time 
                                                            setDuration:slowDurationLocal
                                                                   setX:(float)(arc4random() % 460 * ipadScale) + powerupoffset 
                                                                   setY:(float)(arc4random() % 300 * ipadScale) + powerupoffset
                                                             activeTime:activeTimeLocal
                                                             slowFactor:slowFactorLocal] retain];
                    [powerups addObject:newPowerup];
                    slowSpawntime = (arc4random() % 20) + 15;
                }
            }
            
            if(collectorDestroy)
            {
                destroySpawntime -= dt;
                if(destroySpawntime < 0)
                {
                    Powerup* newPowerup = [[[Powerup node] initWithData:@"Destroy"
                                                               setStart:game_time 
                                                            setDuration:3 
                                                                   setX:(float)(arc4random() % 460 * ipadScale) + powerupoffset 
                                                                   setY:(float)(arc4random() % 300 * ipadScale) + powerupoffset
                                                           destroyCount:1] retain];
                    [powerups addObject:newPowerup];
                    destroySpawntime = (arc4random() % 20) + 30;
                }
            }
            
            if(collectorInvincible)
            {
                invincibleSpawntime -= dt;
                if(invincibleSpawntime < 0)
                {
                    float activeTimeLocal = (float)(arc4random() % 6) + 10;
                    float invinceDurationLocal =  2 + ((16 - activeTimeLocal)/4); 
                    Powerup* newPowerup = [[[Powerup node] initWithData:@"Invincible" 
                                                               setStart:game_time
                                                            setDuration:invinceDurationLocal
                                                                   setX:(float)(arc4random() % 460 * ipadScale) + powerupoffset
                                                                   setY:(float)(arc4random() % 300 * ipadScale) + powerupoffset 
                                                             activeTime:activeTimeLocal] retain];
                    [powerups addObject:newPowerup];
                    invincibleSpawntime = (arc4random() % 20) + 30;
                }
            }
            
            if(collectorDemolish)
            {
                demolishSpawntime -= dt;
                if(demolishSpawntime < 0)
                {
                    Powerup* newPowerup = [[[Powerup node] initWithData:@"Demolish" 
                                                               setStart:game_time
                                                            setDuration:2
                                                                   setX:(float)(arc4random() % 460 * ipadScale) + powerupoffset
                                                                   setY:(float)(arc4random() % 300 * ipadScale) + powerupoffset] retain];
                    [powerups addObject:newPowerup];
                    demolishSpawntime = (arc4random() % 20) + 80;;
                }
            }
        }
		
        //int coinCount = [coins count];
        // update coins
        if(curMode == LEVEL || curMode == COLLECTOR){
            for (Coin *curCoin in coins)
            {
                [curCoin updateLifetime:dt];
                if([curCoin isActive] && ![curCoin consumed])
                {
                    float fPlayerToCoin = pow(fabs(ballData.position.x - [curCoin getCurXPos]), 2) 
                                           + pow(fabs(ballData.position.y - [curCoin getCurYPos]), 2);
                    curCoinSize = pow((playerS->GetFixtureList()->GetShape()->m_radius
                                       + [[curCoin getSprite] boundingBox].size.width - ([[curCoin getSprite] boundingBox].size.width * 70 / 90)), 2);
                    if(fPlayerToCoin < curCoinSize 
									// The coin must be fully faded in (plus a small offset to be sure) to be picked up by the player
									// The coin must be fully faded in to be picked up by the player
									&& [curCoin getLifetime] > ([curCoin getFadeInTime] + 0.05))
                    {
                        //player got a coin
                        coinsCollected ++;
                        pointsCollected += [curCoin getPoints] * 10 * multiplier;
                        multiplier += 0.1;
                        [[curCoin getSprite] removeFromParentAndCleanup:YES];
                        [[curCoin getDyingSprite] removeFromParentAndCleanup:YES];
                        [curCoin consume];
                        collectParticle = [CCParticleSystemQuad particleWithFile:@"radiaCollect.plist"];
                        if(isIpad) {
                            collectParticle.startSize = 20;
                            collectParticle.speed = 200;
                        }
                        [self addChild:collectParticle z:-20];
                        collectParticle.position = ccp([curCoin getCurXPos], [curCoin getCurYPos]);
                        [collectParticle resetSystem]; 
                        if(radiaHowTo) {
                            [self removeChild:radiaHowTo cleanup:YES];
                            radiaHowTo = nil;
                        }
                        activeCoins--;
                        [[SimpleAudioEngine sharedEngine] playEffect:@"CoinCollect2.WAV"];
                        
                        //IF COLLECTS LAST COIN CALL END GAME
                        if(curMode == LEVEL)
                        {
                            if(activeCoins == 0) [self endGame];
                        }
                    }
                    else if ([curCoin getEndTime] < game_time)
                    {    
                        multiplier = 1;
                        [[curCoin getSprite] removeFromParentAndCleanup:YES];
                        [[curCoin getDyingSprite] removeFromParentAndCleanup:YES];
                        [curCoin remove];
                        dyingParticle = [CCParticleSystemQuad particleWithFile:@"radiaDestroy.plist"];
                        if(isIpad) {
                            dyingParticle.startSize = 20;
                            dyingParticle.speed = 200;
                        }
                        [self addChild:dyingParticle z:-20];
                        dyingParticle.position = ccp([curCoin getCurXPos], [curCoin getCurYPos]);
                        [dyingParticle resetSystem]; 
                        if(radiaHowTo) {
                            [self removeChild:radiaHowTo cleanup:YES];
                            radiaHowTo = nil;
                        }
                        activeCoins--;
                        
                        if(curMode == LEVEL)
                        {
                            if(activeCoins == 0) [self endGame];
                        }
                    }
                }
                
                // Take into account the fade in time and activate the coin early (it still can't be picked up until fade is done)
                float startingTime = [curCoin getStartTime] - [curCoin getFadeInTime];
                if(startingTime <= game_time && ![curCoin isActive])
                {
                    [curCoin activate];
                    [self addChild:[curCoin getSprite]];
                    [self addChild:[curCoin getDyingSprite]];
                     /*
                    if(curMode == COLLECTOR) {[self addChild:[curCoin getSprite]];}
                    else {[curCoin getSprite].visible = YES;}
                    if(curMode == COLLECTOR) {[self addChild:[curCoin getDyingSprite]];}
                    else {[curCoin getDyingSprite].visible = YES;}*/
                    [curCoin fadeIn];
                }
            }
            
            //if coinsneeded - coinscollected < activeCoins end game
            //end game if user can't win
            if(curMode == LEVEL)
            {
                //if(coinsNeeded - coinsCollected > activeCoins) [self endGame];
            }
            
            //opacity
            playerOpacity = baseOpacity + 127.5 * ((float)coinsCollected/(float)coinsNeeded);
            playerOpacity = 255;
            if(playerOpacity > 255) playerOpacity = 255;
            if(curMode != LEVEL) playerOpacity = 255;
            
            [ball setOpacity:playerOpacity];
            
            for (Powerup *curPowerup in powerups)
            {
                if([curPowerup isActive] && ![curPowerup isUsed])
                {
                    float fPlayerToPU = pow(fabs(ballData.position.x - [curPowerup getX]), 2) 
                                               + pow(fabs(ballData.position.y - [curPowerup getY]), 2);
                    powerupSize = pow(((playerS->GetFixtureList()->GetShape()->m_radius 
                                        + [[curPowerup getSprite] boundingBox].size.width) - 40.0f * ipadScale), 2);
                    if(fPlayerToPU < powerupSize)
                    {
                        if ([[curPowerup getType] isEqualToString:@"TimeSlow"])
                        {
                            bool alreadySlow = playerSlowTime;
                            playerSlowTime = true;
                            [[SimpleAudioEngine sharedEngine] playEffect:@"SlowSound.WAV" pitch:1 pan:0 gain:5];
                            slowTime = game_time + [curPowerup getActiveTime];
                            totalSlowTime = [curPowerup getActiveTime];
                            slowFactor = [curPowerup getSlowFactor];
                            
                            for(FireBall *curFireBall in fireBalls)
                            {
                                if (alreadySlow)
                                {
                                    [curFireBall setSlow:YES slowDownTime:[curPowerup getActiveTime] slowTime:[curPowerup getActiveTime]];
                                    [curFireBall setSlowOpacity:255];
                                    [[SimpleAudioEngine sharedEngine] stopEffect:slowSound];
                                }
                                else if ([curFireBall getIsAlive] && ![curFireBall isUsed]) {
                                    [curFireBall setSlow:YES slowDownTime:[curPowerup getActiveTime] slowTime:[curPowerup getActiveTime]];
                                    [curFireBall setSlowOpacity:255];
                                    [self addChild:[curFireBall getSlowSprite] z:-1];
                                }
                            }
                        }
                        else if ([[curPowerup getType] isEqualToString:@"Invincible"])
                        {
                            playerInvincible = true;
                            invincibleTime = game_time + [curPowerup getActiveTime];
                            invincibleFadeOffset = [curPowerup getActiveTime];
                            
                            CCTexture2D *newTexture=[[[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"GlowSphereYellow.png"]]autorelease];
                            
                            [ball setTexture:newTexture];
                            
                            [[SimpleAudioEngine sharedEngine] playEffect:@"Invincible.wav"];
                        }
                        else if ([[curPowerup getType] isEqualToString:@"Destroy"])
                        {
                            destroyCount += [curPowerup getDestroyCount];
                            
                            //add sprite of green destroy to player
                            CCSprite* destroySprite = [CCSprite spriteWithFile:@"GlowSphereGreen.png"];
                            [[SimpleAudioEngine sharedEngine] playEffect:@"DestroyCollect.wav"];
                            destroySprite.scale = 0.5 * ipadScale;
                            int playerXPosition = playerS->GetPosition().x * PTM_RATIO;
                            int playerYPosition = playerS->GetPosition().y * PTM_RATIO;
                            destroySprite.anchorPoint = ccp(1, 0);
                            destroySprite.position = ccp(playerXPosition, playerYPosition);
                            
                            [destroys addObject:destroySprite];
                            
                            int curDestroy = 1;
                            CCSprite* firstDestroy = [destroys objectAtIndex:0];
                            int baseAngle = firstDestroy.rotation;
                            for (CCSprite* destroySprite in destroys)
                            {
                                destroySprite.rotation = baseAngle + (360/(destroyCount)) * curDestroy;
                                curDestroy++;
                            }
                            
                            [self addChild:destroySprite];
                        }
                        else if ([[curPowerup getType] isEqualToString:@"Demolish"])
                        {
                            destroyAll = YES;
                            destroyAllTime = 0.0f;
                        }
                        
                        [self removeChild:[curPowerup getSprite] cleanup:YES];
                        [curPowerup use];
                    }
                    else if ([curPowerup getDuration] + [curPowerup getStartTime] < game_time)
                    {    
                        [self removeChild:[curPowerup getSprite] cleanup:YES];
                        [curPowerup use];
                    }
                }
                
                
                
                float startingTime = [curPowerup getStartTime];
                if(startingTime <= game_time && ![curPowerup isActive])
                {
                    [curPowerup activate];
                    [self addChild:[curPowerup getSprite]];
                }
            }
            
            if(destroyAll)
            {
                destroyAllTime -= dt;
                if(destroyAllTime <= 0.0f)
                {
                    pointsCollected += 10000 * NumFireballs;
                    //loop through fireballs and blow up
                    [[SimpleAudioEngine sharedEngine] playEffect:@"annihilate.wav" pitch:1 pan:0 gain:5]; // new annihilate sound
                    for (FireBall *curFireBall in fireBalls)
                    {
                        if(![curFireBall isUsed]) {
                            [self removeChild:[curFireBall getSprite] cleanup:YES];
                            [curFireBall use];
                            [self addChild:[curFireBall getSprite]];
                        }
                    }
                    destroyAll = NO;
                }
            }
            
            for (CCSprite* destroySprite in destroys)
            {
                int playerXPosition = playerS->GetPosition().x * PTM_RATIO;
                int playerYPosition = playerS->GetPosition().y * PTM_RATIO;
                destroySprite.position = ccp(playerXPosition, playerYPosition);
                destroySprite.rotation += 5;
            }
            
            if(playerSlowTime)
            {
                slowPointsAdd += dt;
                if(slowPointsAdd > 1)
                {
                    pointsCollected += (50 * NumFireballs);
                    slowPointsAdd = 0; 
                }
            }
            
            if (slowTime < game_time && playerSlowTime)
            {
                slowFactor = 1;
                playerSlowTime = false;
                for(FireBall *curFireball in fireBalls)
                {
                    [curFireball setSlow:NO slowDownTime:0 slowTime:0];
                    [self removeChild:[curFireball getSlowSprite] cleanup:YES];
                    slowSoundEnd = NO;
                }
            }
            if (invincibleTime - 3.0f < game_time && playerInvincible)
            {
                if(!invinceFading) {
                    invinceFading = YES;
                    [[SimpleAudioEngine sharedEngine] playEffect:@"InvinceFadeOut.wav"];
                }
                //set ball opacity to drop from 255 to 150 and back twice over the two seconds
                float opacityVal = game_time - invincibleTime;
                opacityVal = invincibleFadeOffset - invincibleTime - game_time;
                [ball setOpacity:88.75*sin(game_time*20)+141.25];
            }
            if (invincibleTime < game_time && playerInvincible)
            {
                invinceFading = NO;
                playerInvincible = false;
                ball.texture = [[CCTextureCache sharedTextureCache] addImage:@"GlowPlayer.png"];
                [ball setOpacity:255];
            }
        }
		
		//if time is past certain amount, add a fireball
		if(spawn_time > spawnDuration)
		{
			spawn_time = 0.0f;
            
            if(/*curMode == SURVIVAL || (curMode == LEVEL && */NumFireballs < fireBallCap){
                [self createFireball];
            }
        }
	}
}

-(void) addCoin:(float) m_initTime dur:(float) m_duration
{
	Coin *newCoin = [Coin node];
	
	//check for collision with user, if so reset initial fireball pos
	float fPlayerToCoin = pow(fabs(playerX - [newCoin getXPos]), 2) 
                                   + pow(fabs(playerY - [newCoin getYPos]), 2);

	while(fPlayerToCoin < 40000)
	{
		[newCoin resetRandomPos];
		fPlayerToCoin = pow(fabs(playerX - [newCoin getXPos]), 2) 
                                 + pow(fabs(playerY - [newCoin getYPos]), 2);
	}

	[coins addObject:newCoin];
	[newCoin setTime:m_initTime setDuration:m_duration];

	[self addChild:[newCoin getSprite]];
}

-(void) createFireball
{
	FireBall *newFireball = [[FireBall node] initWithPlayerLoc:playerX playerY:playerY];
	
	[fireBalls addObject:newFireball];
	[newFireball addSpeed:fireBallStartSpeed * ipadScale];
	
	float fFireBallAngle = atan(([newFireball getYPos] - playerY)/
                                ([newFireball getXPos] - playerX));
	if(playerX < [newFireball getXPos]) fFireBallAngle += 3.14;
	[newFireball setAngle:fFireBallAngle];
	
	[self addChild:[newFireball getSprite]]; //SOMETIMES FAILS

    if(playerSlowTime)
    {
        [newFireball setSlow:YES slowDownTime:totalSlowTime slowTime:slowTime-game_time];
        [self addChild:[newFireball getSlowSprite] z:-1];
    }
    
    fireBallSize = pow(((playerS->GetFixtureList()->GetShape()->m_radius 
                             + [newFireball getRadius]) - 3.0f) * ipadScale, 2);
    
	[newFireball fadeIn];
}

-(void) endGame
{
#ifdef DEBUGMODE
    return;
#endif
    gameRunning = NO;
    gameOver = YES;
    ballBg.visible = NO;
    [trailParticle stopSystem];
    
    for (Wall *curWall in walls)
    {
        [curWall endLife];
    }
    
    bgMusicePrefade = [SimpleAudioEngine sharedEngine].backgroundMusicVolume;
    [CDXPropertyModifierAction fadeBackgroundMusic:2.0f finalVolume:0.0f curveType:kIT_Exponential shouldStop:YES];
    
}

-(void) sendToGameDone
{
    [[SimpleAudioEngine sharedEngine] pauseBackgroundMusic];
    [SimpleAudioEngine sharedEngine].backgroundMusicVolume = bgMusicePrefade;
    
    if(curMode == LEVEL)
    {
        if(coinsCollected >= coinsNeeded || true)
        {
#ifdef BETA  
            NSString * testflightstartpointlevel = [NSString stringWithFormat:@"level%i-complete", curLevel];
            [TestFlight passCheckpoint:testflightstartpointlevel];
#endif
            [[CCDirector sharedDirector] replaceScene:[[LevelWonScene node] initWithInfo:coinsCollected setLevel:curLevel world:curWorld]];

            if(curLevel == 20 && curWorld == 1 && [[NSUserDefaults standardUserDefaults] floatForKey:@"slowRadia"] == 0)
            {
                [CCVideoPlayer setNoSkip:true];
                [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:curLevel]];
                [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"slowRadia"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }
            else if(curLevel == 30 && curWorld == 1 && [[NSUserDefaults standardUserDefaults] floatForKey:@"invincibleRadia"] == 0)
            {
                [CCVideoPlayer setNoSkip:true];
                [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:curLevel]];
                [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"invincibleRadia"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } 
            else if(curLevel == 40 && curWorld == 1 && [[NSUserDefaults standardUserDefaults] floatForKey:@"destroyRadia"] == 0)
            {
                [CCVideoPlayer setNoSkip:true];
                [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:curLevel]];
                [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"destroyRadia"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } 
            else if(curLevel == 50 && curWorld == 1 && [[NSUserDefaults standardUserDefaults] floatForKey:@"demolishRadia"] == 0)
            {
                [CCVideoPlayer setNoSkip:true];
                [[CCDirector sharedDirector] pushScene:[[SpecialPushScene node] initVideo:curLevel]];
                [[NSUserDefaults standardUserDefaults] setFloat:1 forKey:@"demolishRadia"];
                [[NSUserDefaults standardUserDefaults] synchronize];
            } 
        } else {
#ifdef BETA        
            NSString * testflightstartpointlevel = [NSString stringWithFormat:@"level%i-failed", curLevel];
            [TestFlight passCheckpoint:testflightstartpointlevel];
#endif
            [[CCDirector sharedDirector] replaceScene:[[LevelOverScene node] initWithInfo:coinsCollected setLevel:curLevel world:curWorld]];

        }
    } else {
        
        double intPart = 0;
        double fractPart = modf(game_time, &intPart);
        int isecs = (int)intPart;
        int min = isecs / 60;
        int sec = isecs % 60;
        int hund = (int) (fractPart * 100);
        
        int64_t time_to_send_through_game_center = min*6000 + (sec*100 + hund);
        
        if (curMode == SURVIVAL || curMode == COLLECTOR)
        {
            switch (curDiff) {
                case EASY:
                    [self writeHighscore:@"easy"];
    #ifndef LITEMODE
                    [[GameCenterManager sharedGameCenterManager] reportScore:time_to_send_through_game_center forCategory:@"Timed.Survival.Easy"];
    #endif
                    break;
                case MEDIUM:
                    [self writeHighscore:@"medium"];
    #ifndef LITEMODE
                    [[GameCenterManager sharedGameCenterManager] reportScore:time_to_send_through_game_center forCategory:@"Timed.Survival.Medium"];
    #endif
                    break;
                case HARD:
                    [self writeHighscore:@"hard"];
    #ifndef LITEMODE
                    [[GameCenterManager sharedGameCenterManager] reportScore:time_to_send_through_game_center forCategory:@"Timed.Survival.Hard"];
    #endif
                    break;
                case EXTREME:
                    [self writeHighscore:@"extreme"];
    #ifndef LITEMODE
                    [[GameCenterManager sharedGameCenterManager] reportScore:time_to_send_through_game_center forCategory:@"Timed.Survival.Extreme"];
#endif
                case COLLECT:
                    [self writeHighscore:@"collect"];
#ifndef LITEMODE
                    [[GameCenterManager sharedGameCenterManager] reportScore:pointsCollected forCategory:@"Endless"];
#endif
                    break;
                default:
                    break;
            }
        }
        if (curMode == COLLECTOR)
        {
            [[CCDirector sharedDirector] replaceScene:[[GameOverScene node] initWithScore:pointsCollected setDifficulty:curDiff setMode:curMode setLevel:curLevel highScore:newHigh]];
        } else {
            [[CCDirector sharedDirector] replaceScene:[[GameOverScene node] initWithScore:game_time setDifficulty:curDiff setMode:curMode setLevel:curLevel highScore:newHigh]];
        }
    }
}

-(void) writeHighscore:(NSString *) mode
{
	//load scores
	NSString *score1 = [mode stringByAppendingString:[NSString stringWithFormat:@"%i", 1]];
	NSString *score2 = [mode stringByAppendingString:[NSString stringWithFormat:@"%i", 2]];
	NSString *score3 = [mode stringByAppendingString:[NSString stringWithFormat:@"%i", 3]];
	float num1 = [[NSUserDefaults standardUserDefaults] floatForKey:score1];
	float num2 = [[NSUserDefaults standardUserDefaults] floatForKey:score2];
	float num3 = [[NSUserDefaults standardUserDefaults] floatForKey:score3];
	
	//if this far, all 3 full, modify
    float highScore = curMode == COLLECTOR ? pointsCollected : game_time;
	if(highScore > num1)
	{
        newHigh = TRUE;
		[[NSUserDefaults standardUserDefaults] setFloat:num2 forKey:score3];
		[[NSUserDefaults standardUserDefaults] setFloat:num1 forKey:score2];
		[[NSUserDefaults standardUserDefaults] setFloat:highScore forKey:score1];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else if (highScore > num2)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:num2 forKey:score3];
		[[NSUserDefaults standardUserDefaults] setFloat:highScore forKey:score2];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else if(highScore > num3)
	{
		[[NSUserDefaults standardUserDefaults] setFloat:highScore forKey:score3];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

- (void)onPause:(id)sender
{
	NSLog(@"on pause");
    if(!introStarted) {
        tappedBegin = YES;
    } else if(!gameOver /* && introStarted*/){
        [[CCDirector sharedDirector] pushScene:[[PauseScene node] initWithInfo:curDiff setMode:curMode setLevel:curLevel setWorld:curWorld]];
    }
}

- (void)tapToBegin:(id)sender {
    tappedBegin = YES;
}

- (void)startGame
{
    introStarted = YES;
    //delete intro menu
    if(introMenu){ 
        [self removeChild:introMenu cleanup:YES];
        introMenu = nil;
    }
    
    if(levelData){ 
        [self removeChild:levelData cleanup:YES];
        levelData = nil;
    }
    
    if(oneStarNum){ 
        [self removeChild:oneStarNum cleanup:YES];
        oneStarNum = nil;
    }
    
    if(twoStarNum){ 
        [self removeChild:twoStarNum cleanup:YES];
        twoStarNum = nil;
    }
    
    if(threeStarNum){ 
        [self removeChild:threeStarNum cleanup:YES];
        threeStarNum = nil;
    }
    
    if(dataLevelsMenu){ 
        [self removeChild:dataLevelsMenu cleanup:YES];
        dataLevelsMenu = nil;
    }
    
    if(curMode == LEVEL || curMode == SURVIVAL) {
        if(currentLevelString) {
            [self removeChild:currentLevelString cleanup:YES];
            currentLevelString = nil;
        }
    }
    
    if(dataLevelsImage){ 
        [self removeChild:dataLevelsImage cleanup:YES];
        dataLevelsImage = nil;
    }
    
    if(startMenu) { 
        [self removeChild:startMenu cleanup:YES]; 
        startMenu = nil;
    }
}

- (void)onStart:(id)sender
{
    introStarted = YES;
    //delete intro menu
    if(introMenu){ [self removeChild:introMenu cleanup:YES]; introMenu = nil;}
    
    if(levelData){ [self removeChild:levelData cleanup:YES]; levelData = nil;}
    
    if(oneStarNum){ [self removeChild:oneStarNum cleanup:YES]; oneStarNum = nil;}
    
    if(twoStarNum){ [self removeChild:twoStarNum cleanup:YES]; twoStarNum = nil;}

    if(threeStarNum){ [self removeChild:threeStarNum cleanup:YES]; threeStarNum = nil;}
    
    if(dataLevelsMenu){ [self removeChild:dataLevelsMenu cleanup:YES]; dataLevelsMenu = nil;}
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {
    return YES;
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {
	//CGPoint location = [self convertTouchToNodeSpace: touch];
	//[playerBall stopAllActions];
	//[playerBall runAction: [CCMoveTo actionWithDuration:1 position:location]];
}

-(void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

- (void)dealloc {
    
    delete _world;
    _world = NULL;
    [super dealloc];
    
}

@end
