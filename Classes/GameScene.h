//
//  HelloWorldScene.h
//  Cocos2DBall
//
//  Created by Ray Wenderlich on 2/17/10.
//  Copyright 2010 Ray Wenderlich. All rights reserved.
//

#import "cocos2d.h"
#import "Box2D.h"
#import "Player.h"
#import "SimpleAudioEngine.h"
#include "vector.h"
#include <CoreMotion/CoreMotion.h>

enum GameDifficulty {
	EASY,
	MEDIUM,
	HARD,
	EXTREME,
    COLLECT,
	NUM_DIFFICULTIES
};

enum GameMode {
	SURVIVAL,
	LEVEL,
    COLLECTOR,
	NUM_MODES
};


@interface Game : CCLayer {
    
    //CMMotionManager *motionManager;
    b2World *_world;    
    Player *player;
	b2Body *playerS;
	b2Body *groundBody;
    
    int curWorld;
    
    bool lowRes;
    
    float playerX;
    float playerY;
    float playerRadius;
    float scale;
    CCSprite *ball;
    CCSprite *ballBg;
    CCSprite *ballLarge;
    CCParticleSystem *trailParticle;
    CCParticleSystemQuad *collectParticle;
    CCParticleSystemQuad *dyingParticle;
    
    float red1, red2, red3;
    float green1, green2, green3;
    float blue1, blue2, blue3;
    float alpha1, alpha2, alpha3;
    
    float accelerometerOffset;
    
	float game_time;
	float spawn_time;
	float coin_time;
	float initial_pause;
	float time_limit;
    float radia_score_time;
    float final_delay;
    float invincePoints;
    float bgMusicePrefade;
    float curCoinSize;
    float powerupSize;
    float fireBallSize;
	
	float spawnDuration;
	float fireBallStartSpeed;
	float fireBallSpeedIncrease;
    float fireBallSpeedCap;
    
    float slowTime;
    float invincibleTime;
    float invincibleFadeOffset;
    
    float slowFactor; /*to implement slow fireball, turn this variable to a val > 1 
                       (i.e. 2 would be half speed) for however long the powerup is active, 
                       then switch back to a value of 1*/
    
    float initialX, initialY;
    float baseOpacity;
	float playerOpacity;
    
    float collectorCoinSpawnTime;
    
	NSMutableArray *fireBalls;
	NSMutableArray *coins;
    NSMutableArray *powerups;
    NSMutableArray *destroys;
    NSMutableArray *walls;
	
    int coinsCollected;
    int totalCoins;
    int coinsNeeded;
    unsigned int fireBallCap;
    int destroyCount;
    int activeCoins;
    unsigned long pointsCollected;
    int slowSound;
    float multiplier;
    
	enum GameMode curMode;
	enum GameDifficulty curDiff;
	
	BOOL gameOver;
	BOOL gameRunning;
    BOOL initialFireball;
    BOOL introStarted;
    BOOL pushCheck;
    BOOL initialOffset;
    BOOL newHigh;
    BOOL radiaHow;
    BOOL dodgeHow;
    BOOL killed;
    BOOL firstUseAcc;
    BOOL invinceFading;
    BOOL initialMusic;
    BOOL firstPass;
    BOOL slowSoundEnd;
    
    BOOL collectorSlow;
    BOOL collectorDestroy;
    BOOL collectorInvincible;
    BOOL collectorDemolish;
    
    float slowSpawntime;
    float destroySpawntime;
    float invincibleSpawntime;
    float demolishSpawntime;
    float totalSlowTime;
    BOOL destroyAll;
    float destroyAllTime;
    float killerX;
    float killerY;
    float failedTime;
    float wonTime;
    
    float slowPointsAdd;
    
    BOOL playerInvincible;/*to implement invincible player, turn this variable to true 
                           for however long the powerup is active, 
                           then switch back to false*/
    BOOL playerSlowTime;
    BOOL playerDestroy;
    BOOL tappedBegin;
	
	CGSize screenSize;
	
	CCLabelTTF *timer;
    CCLabelTTF *coinCount;
    CCLabelTTF *multiplierLabel;
    CCLabelTTF *countdown;
    
    
    CCLabelTTF *levelTime;
    CCLabelTTF *oneStarNum;
    CCLabelTTF *twoStarNum;
    CCLabelTTF *threeStarNum;
    CCLabelTTF *currentLevelString;
    CCMenu *dataLevelsMenu;
    CCSprite *dataLevelsImage;
    CCSprite *radiaHowTo;
    CCSprite *dodgeHowTo;
    CCSprite *dodgeHowToText;
    CCLabelTTF *firstLevel;
    CCMenu *startMenu;
    
    CCRibbon *ribbon;
    
    CCLabelTTF *accelXlabel;
    float globalX, globalY, globalZ;
    
    CCSprite *levelData;
    
    CCMenu *introMenu;
    
	int minutes, seconds, milliseconds, curLevel;
    int curShred;
    float shredTime;
    
    vector <CGPoint> wallx, wally;
    
    SimpleAudioEngine *gameSounds;
    
    CCSprite* bg;
    CCSprite* blueBg;
    CCSprite* redBg;
    CCSprite* yellowBg;
    CCSprite* greenBg;
    CCSprite* darkBg;
    BOOL isIpad;
    float ipadScale;
    
    float gameWidth;
    float gameHeight;
    
    int maxSpeed;
    int ballSpeed;    
}

//@property (nonatomic, retain) CMMotionManager *motionManager;

+ (id) scene;

-(id) initWithGameDifficulty:(enum GameDifficulty) difficulty setMode:(enum GameMode) mode levelNum:(int) levelNum worldNum:(int) worldNum;

-(void) addCoin:(float) m_initTime dur:(float) m_duration;

-(void) writeHighscore:(NSString *) mode;

-(void) endGame;

-(void) createFireball;

-(void) specialPushLevelEnd;

- (void)startGame;

@end
