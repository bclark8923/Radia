//
//  FireballinAppDelegate.m
//  Fireballin
//
//  Created by Tom King on 1/16/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import "cocos2d.h"

#import "FireballinAppDelegate.h"
#import "GameConfig.h"
#import "MainMenu.h"
#import "RootViewController.h"
#import "PauseScene.h"
#import "GameCenterManager.h"
#import "AccelerometerSimulation.h"
#import "UIDeviceHardware.h"
//#import "TestFlight.h"

//#define LITEMODE

@implementation FireballinAppDelegate

@synthesize window;
@synthesize bannerView;

- (NSUInteger)application:(UIApplication*)application supportedInterfaceOrientationsForWindow:(UIWindow*)window
{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}


-(void)moveBannerViewOffscreen
{
    /*CGRect newBannerFrame = self.bannerView.frame;
    newBannerFrame.origin.y = -32.0f;
     
    self.bannerView.frame = newBannerFrame;*/
    [bannerView setCenter:CGPointMake(-16, 240)];
}

-(void)moveBannerViewOnscreen
{
    /*CGRect newBannerFrame = self.bannerView.frame;
    newBannerFrame.origin.y = 16.0f;
     
    [UIView beginAnimations:@"BannerViewIntro" context:NULL];
    self.bannerView.frame = newBannerFrame;
    [UIView commitAnimations];*/
    [bannerView setCenter:CGPointMake(16, 240)];
}

-(void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    [self moveBannerViewOffscreen];
}

-(void)bannerViewDidLoadAd:(ADBannerView *)banner
{
    [self moveBannerViewOnscreen];
}

- (void) removeStartupFlicker
{
	//
	// THIS CODE REMOVES THE STARTUP FLICKER
	//
	// Uncomment the following code if you Application only supports landscape mode
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController

//	CC_ENABLE_DEFAULT_GL_STATES();
//	CCDirector *director = [CCDirector sharedDirector];
//	CGSize size = [director winSize];
//	CCSprite *sprite = [CCSprite spriteWithFile:@"Default.png"];
//	sprite.position = ccp(size.width/2, size.height/2);
//	sprite.rotation = -90;
//	[sprite visit];
//	[[director openGLView] swapBuffers];
//	CC_ENABLE_DEFAULT_GL_STATES();
	
#endif // GAME_AUTOROTATION == kGameAutorotationUIViewController	
}
- (void) applicationDidFinishLaunching:(UIApplication*)application
{
    [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444]; // add this line at the very beginning

	// Init the window
	window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        
    //[CCDirector useFastDirector];
	
	// Try to use CADisplayLink director
	// if it fails (SDK < 3.1) use the default director
	if( ! [CCDirector setDirectorType:kCCDirectorTypeDisplayLink] )
		[CCDirector setDirectorType:kCCDirectorTypeMainLoop];
#ifdef BETA
    //NSLog([[UIDevice currentDevice] uniqueIdentifier]);
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    [TestFlight takeOff:@"3ba7354251989f77faaaad5b064eba47_ODgwNTgyMDEyLTA1LTA3IDIyOjAyOjE4LjA0NzE3Ng"];
#endif

	CCDirector *director = [CCDirector sharedDirector];
	
	// Init the View Controller
	viewController = [[RootViewController alloc] initWithNibName:nil bundle:nil];
	viewController.wantsFullScreenLayout = YES;
    viewController.navigationBar.hidden = YES;
	
	//
	// Create the EAGLView manually
	//  1. Create a RGB565 format. Alternative: RGBA8
	//	2. depth format of 0 bit. Use 16 or 24 bit for 3d effects, like CCPageTurnTransition
	//
	//
	EAGLView *glView = [EAGLView viewWithFrame:[window bounds]
                                    pixelFormat:kEAGLColorFormatRGB565	// kEAGLColorFormatRGBA8
                                    depthFormat:0						// GL_DEPTH_COMPONENT16_OES
                                    preserveBackbuffer:YES
                                    sharegroup:nil
                                    multiSampling:YES
                                    numberOfSamples:4
                        ];
	
	// attach the openglView to the director
	[director setOpenGLView:glView];
    
    /*NSString *deviceType = [UIDevice currentDevice].model;
    NSString *deviceName = [UIDevice currentDevice].name;
    NSString *deviceSysName = [UIDevice currentDevice].systemName;
    NSString *deviceSysVersion = [UIDevice currentDevice].systemVersion;*/
	//NSString *platform = [self platform];
    
    UIDeviceHardware *h=[[UIDeviceHardware alloc] init];
    NSString *platform = [h platformString];
    
    
    CGSize winSize = [CCDirector sharedDirector].winSize;
    // detect which device is currently running
    if(winSize.width == 1024) {
        isIpad = YES;
    }
    else  {
        isIpad = NO;
    }
    
//	// Enables High Res mode (Retina Display) on iPhone 4 and maintains low res on all other devices
	//if ([platform isEqualToString:@"iPhone 4S"]) {
    if(!isIpad) {
        if( ! [director enableRetinaDisplay:YES] )
            CCLOG(@"Retina Display Not supported");
    }
    //}
    //} else {
    //    if( ! [director enableRetinaDisplay:NO] ) {}
    //}
    //[director setContentScaleFactor:1];
	
	//
	// VERY IMPORTANT:
	// If the rotation is going to be controlled by a UIViewController
	// then the device orientation should be "Portrait".
	//
	// IMPORTANT:
	// By default, this template only supports Landscape orientations.
	// Edit the RootViewController.m file to edit the supported orientations.
	//
#if GAME_AUTOROTATION == kGameAutorotationUIViewController
	[director setDeviceOrientation:kCCDeviceOrientationPortrait];
#else
	[director setDeviceOrientation:kCCDeviceOrientationLandscapeLeft];
#endif
	
	[director setAnimationInterval:1.0/240];
	[[UIAccelerometer sharedAccelerometer] setUpdateInterval:1/240];
#ifdef BETA
	[director setDisplayFPS:YES];
#else
	[director setDisplayFPS:NO];
#endif
    
	
	
	// make the OpenGLView a child of the view controller
	[viewController setView:glView];
	
	// make the View Controller a child of the main window
	[window addSubview: viewController.view];
	[window makeKeyAndVisible];
	
	// Default texture format for PNG/BMP/TIFF/JPEG/GIF images
	// It can be RGBA8888, RGBA4444, RGB5_A1, RGB565
	// You can change anytime.
	[CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA8888];
#ifndef LITEMODE
    //[GameCenterManager loadState];
#endif
    
#ifdef LITEMODE
    bannerView = [[ADBannerView alloc] initWithFrame:CGRectZero];
    bannerView.requiredContentSizeIdentifiers = [NSSet setWithObjects:ADBannerContentSizeIdentifierLandscape, nil];
    [bannerView setCurrentContentSizeIdentifier:ADBannerContentSizeIdentifierLandscape];
    [bannerView setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90))];
    [bannerView setCenter:CGPointMake(16, 240)];
    bannerView.delegate = self;
    
    [self moveBannerViewOffscreen];
    //[window addSubview:bannerView];
    [[[CCDirector sharedDirector] openGLView] addSubview:bannerView];
#endif
	[[AnnoTree sharedInstance] loadAnnoTree:UIInterfaceOrientationMaskLandscapeRight withTree:@"c2356069e9d1e79ca924378153cfbbfb4d4416b1f99d41a2940bfdb66c5319db"];
	
	// Removes the startup flicker
	[self removeStartupFlicker];
    
    
    //if ([[NSUserDefaults standardUserDefaults] floatForKey:@"sound"] == 0 || [[CDAudioManager sharedManager] isOtherAudioPlaying]) {
      //  [[CDAudioManager sharedManager] setMode:kAMM_FxOnly];
   // }
    //else {
        [[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio];
    //}
    
    //[[CDAudioManager sharedManager] setMode:kAMM_FxOnly];
    //[[CDAudioManager sharedManager] setMode:kAMM_FxPlusMusicIfNoOtherAudio];
    
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"Decisions.mp3"];
    [[SimpleAudioEngine sharedEngine] preloadBackgroundMusic:@"CupidsRevenge.mp3"];
	
	// Run the intro Scene
	[[CCDirector sharedDirector] runWithScene: [MainMenu scene]];
}


- (void)applicationWillResignActive:(UIApplication *)application {
	[[CCDirector sharedDirector] pause];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //Check for sound here?
    
	[[CCDirector sharedDirector] resume];
}

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
	//[[CCDirector sharedDirector] purgeCachedData];
}

-(void) applicationDidEnterBackground:(UIApplication*)application {
	//[[CCDirector sharedDirector] pushScene:[PauseScene node]];
	[[CCDirector sharedDirector] stopAnimation];
}

-(void) applicationWillEnterForeground:(UIApplication*)application {
	[[CCDirector sharedDirector] startAnimation];
}

- (void)applicationWillTerminate:(UIApplication *)application {
#ifndef LITEMODE
    //[GameCenterManager saveState];
#endif
	CCDirector *director = [CCDirector sharedDirector];
	
	[[director openGLView] removeFromSuperview];
	
	[viewController release];
	
	[window release];
	
	[director end];	
}

- (void)applicationSignificantTimeChange:(UIApplication *)application {
	[[CCDirector sharedDirector] setNextDeltaTimeZero:YES];
}

- (void)dealloc {
	[[CCDirector sharedDirector] release];
    bannerView.delegate = nil;
	[window release];
    [bannerView release];
	[super dealloc];
}

@end
