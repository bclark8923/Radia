//
//  GameCenterManager.h
//
//  Created by Nathan Demick on 4/17/11.
//  Copyright 2011 Ganbaru Games. All rights reserved.
//

#import <GameKit/GameKit.h>
#import "SynthesizeSingleton.h"

// Subclass our object from NSObject - allow it to be serialized, and make it the delegate for the leaderboard view
@interface GameCenterManager : NSObject <NSCoding, GKLeaderboardViewControllerDelegate>
{
	// Boolean that is set to true if device supports Game Center and a player has logged in
	BOOL hasGameCenter;
	
	// An array that holds scores that couldn't be sent to Game Center (network timeout, etc.)
	NSMutableArray *unsentScores;
	NSMutableArray *unsentAchievements;
	
	// Store saved Game Center achievement progress
	NSMutableDictionary *achievementsDictionary;
	
	// The view that shows the default Game Center leaderboards
	UIViewController *myViewController;
}

// Create accessible properties
@property (readwrite) BOOL hasGameCenter;
@property (nonatomic, retain) NSMutableArray *unsentScores;
@property (nonatomic, retain) NSMutableArray *unsentAchievements;
@property (nonatomic, retain) NSMutableDictionary *achievementsDictionary;

// Time-saving singleton generator - see http://cocoawithlove.com/2008/11/singletons-appdelegates-and-top-level.html
SYNTHESIZE_SINGLETON_FOR_CLASS_HEADER(GameCenterManager);

// Game Center methods
- (BOOL)isGameCenterAPIAvailable;
- (void)authenticateLocalPlayer;

// Leaderboards
- (void)reportScore:(int64_t)score forCategory:(NSString *)category;
- (void)showLeaderboardForCategory:(NSString *)category;
- (void)leaderboardViewControllerDidFinish:(GKLeaderboardViewController *)viewController;

// Achievements
- (GKAchievement *)getAchievementForIdentifier:(NSString *)identifier;
- (void)reportAchievementIdentifier:(NSString *)identifier percentComplete:(float)percent;
- (void)reportAchievementIdentifier:(NSString *)identifier incrementPercentComplete:(float)percent;
- (void)showAchievements;
- (void)achievementViewControllerDidFinish:(GKAchievementViewController *)viewController;

// Serialization methods
+ (void)loadState;
+ (void)saveState;

@end
