//
//  FireballinAppDelegate.h
//  Fireballin
//
//  Created by Tom King on 1/16/11.
//  Copyright __MyCompanyName__ 2011. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import <AnnoTree/AnnoTree.h>

@class RootViewController;

@interface FireballinAppDelegate : NSObject <UIApplicationDelegate, ADBannerViewDelegate> {
	UIWindow			*window;
    ADBannerView        *bannerView;
	RootViewController	*viewController;
    BOOL                 isIpad;
}

@property (nonatomic, retain) UIWindow *window;
@property (nonatomic) BOOL isIpad;
@property (nonatomic, retain) ADBannerView *bannerView;


@end
