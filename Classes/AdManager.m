//
//  AdManager.m
//
//  Created by Samuel Ritchie on 10/11/10.
//  Copyright 2010 Threadlock Design. All rights reserved.
//

#import "AdManager.h"
#import "cocos2d.h"
//#import "CommonMacros.h"

static AdManager *sharedAdManager = nil;

@implementation AdManager

@synthesize adBannerView;

#pragma mark -
#pragma mark ADBannerView

-(id) init {
	if ((self = [super init])) {
		
		//Initialize the class manually to make it compatible with iOS < 4.0
		Class classAdBannerView = NSClassFromString(@"ADBannerView");
		if (classAdBannerView != nil) 
		{
			[self configureBanners];

			
			ADBannerView *adView = [[classAdBannerView alloc] initWithFrame:CGRectZero];
			[adView setDelegate:self];
			
			if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
				[adView setRequiredContentSizeIdentifiers: [NSSet setWithObjects:portraitBanner, landscapeBanner, nil]];
			} else {
				[adView setRequiredContentSizeIdentifiers: [NSSet setWithObjects:portraitBanner, nil]];
			}
			
			self.adBannerView = adView;
			[adView release];
													
			//Set bannerView to hidden so it shows only when it is loaded.
			[self.adBannerView setHidden:YES];
			
		}
		else
		{
			//No iAd Framework, iOS < 4.0
			CCLOG(@"No iAds avaiable for this version");
		}
		
	}
	
	return self;
}

-(void) configureBanners {
	/*if (&ADBannerContentSizeIdentifierPortrait != nil) {
		portraitBanner = ADBannerContentSizeIdentifierPortrait;
		landscapeBanner = ADBannerContentSizeIdentifierLandscape;
		NSLog(@"Running on iOS 4.2 or newer.");
	} else {
		portraitBanner = ADBannerContentSizeIdentifier320x50;
		landscapeBanner = ADBannerContentSizeIdentifier480x32;
		NSLog(@"Running on Pre-iOS 4.2.");
	}*/
    adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
    adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    [adBannerView setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90))];
    [adBannerView setCenter:CGPointMake(16, 240)];
}

//I'm using cocos2d for orientation, so you may have to modify this piece
/*-(UIInterfaceOrientation) interfaceOrientation {
	Cocos2DController *cocosController = [[[UIApplication sharedApplication] delegate] cocosController];
	UIInterfaceOrientation intOrientation = [cocosController interfaceOrientation];
	return intOrientation;
}*/

#pragma mark Singleton Methods

+ (id)sharedManager {
	
    @synchronized(self) {
        if(sharedAdManager == nil)
            sharedAdManager = [[super allocWithZone:NULL] init];
    }
    return sharedAdManager;
}

+ (id)allocWithZone:(NSZone *)zone {
    return [[self sharedManager] retain];
}

- (id)copyWithZone:(NSZone *)zone {
    return self;
}

- (id)retain {
    return self;
}

- (unsigned)retainCount {
    return UINT_MAX; //denotes an object that cannot be released
}

- (void)release {
    // never release
}

- (id)autorelease {
    return self;
}

//should never get called!
-(void) dealloc {
	[adBannerView release];
	[super dealloc];
}

#pragma mark -
#pragma mark Other Methods

-(void) startAds {
	//nothing!
}

-(void) attachAdToView:(UIView *)view {
	if (adBannerView) {
		if ([adBannerView superview])
			[self.adBannerView removeFromSuperview];
		
		[view addSubview:self.adBannerView];
	}
}

- (void)fixBannerToDeviceOrientation:(UIInterfaceOrientation)orientation
{
	//Don't rotate ad if it doesn't exist
	if (adBannerView != nil)
	{
		//Set the transformation for each orientation
		switch (orientation) 
		{
			case UIInterfaceOrientationPortrait:
			{				
				[adBannerView setCurrentContentSizeIdentifier:portraitBanner];
				CGSize size = [ADBannerView sizeFromBannerContentSizeIdentifier:portraitBanner];
				[adBannerView setCenter:CGPointMake(size.width / 2, size.height / 2)];

			}
				break;
			case UIInterfaceOrientationLandscapeLeft:
			case UIInterfaceOrientationLandscapeRight:
			{
				[adBannerView setCurrentContentSizeIdentifier:landscapeBanner];
				CGSize size = [ADBannerView sizeFromBannerContentSizeIdentifier:landscapeBanner];
				[adBannerView setCenter:CGPointMake(size.width / 2, size.height / 2)];	
			}
				break;
			default:
				break;
		}
	}
}

#pragma mark -
#pragma mark ADBannerViewDelegate

- (BOOL)allowActionToRun
{
	return TRUE;
}

- (void) stopActionsForAd
{
	
	/* remember to pause music too! */
	[[CCDirector sharedDirector] stopAnimation];
	[[CCDirector sharedDirector] pause];
}

- (void) startActionsForAd
{
	
	/* resume music, if paused */
	[[CCDirector sharedDirector] stopAnimation];
	[[CCDirector sharedDirector] resume];
	[[CCDirector sharedDirector] startAnimation];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave
{
	BOOL shouldExecuteAction = [self allowActionToRun];
    if (!willLeave && shouldExecuteAction)
    {
        // insert code here to suspend any services that might conflict with the advertisement
		[self stopActionsForAd];
    }
    return shouldExecuteAction;
}

- (void)bannerViewDidLoadAd:(ADBannerView *)banner
{
	//Show the bannerView
	//[self fixBannerToDeviceOrientation:[self interfaceOrientation]];
    adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
    adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    [adBannerView setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90))];
    [adBannerView setCenter:CGPointMake(16, 240)];
	[adBannerView setHidden:NO];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
	//Hide the bannerView if it fails to load
	[adBannerView setHidden:YES];
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner
{
	//Set the device orientation
	//[self fixBannerToDeviceOrientation:[self interfaceOrientation]];
    adBannerView.requiredContentSizeIdentifiers = [NSSet setWithObject:ADBannerContentSizeIdentifierLandscape];
    adBannerView.currentContentSizeIdentifier = ADBannerContentSizeIdentifierLandscape;
    [adBannerView setTransform:CGAffineTransformMakeRotation(CC_DEGREES_TO_RADIANS(90))];
    [adBannerView setCenter:CGPointMake(16, 240)];
	[self startActionsForAd];
}

@end
