//
//  WorldGrid.m
//  Fireballin
//
//  Created by Brian Clark on 4/8/11.
//  Copyright 2011 U of Michigan. All rights reserved.
//

#import "WorldGrid.h"
#import "SlidingMenuGrid.h"
#import "ReturnLayer.h"
#import "MenuScene.h"

@implementation WorldGrid

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	WorldGrid *layer = [WorldGrid node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

- (id) init
{
	if( (self=[super init] )) {
        self.anchorPoint = CGPointZero;
		self.position = CGPointZero;
		
		id target = self;
		//objc_selector* selector = @selector(LaunchLevel:);
		int iMaxLevels = 2;
		
		NSMutableArray* allItems = [NSMutableArray arrayWithCapacity:51];
		for (int i = 1; i <= iMaxLevels; ++i)
		{
			// create a menu item for each character
			NSString* image = [NSString stringWithFormat:@"LevelButton"];
			NSString* normalImage = [NSString stringWithFormat:@"%@.png", image];
			NSString* selectedImage = [NSString stringWithFormat:@"%@.png", image];
			
			CCSprite* normalSprite = [CCSprite spriteWithFile:normalImage];
			CCSprite* selectedSprite = [CCSprite spriteWithFile:selectedImage];
			CCMenuItemSprite* item =[CCMenuItemSprite itemFromNormalSprite:normalSprite selectedSprite:selectedSprite target:target selector:@selector(LaunchLevel:)];
			[allItems addObject:item];
		}
		
		SlidingMenuGrid* menuGrid = [SlidingMenuGrid menuWithArray:allItems cols:1 rows:1 position:CGPointMake(70.f, 280.f) padding:CGPointMake(90.f, 80.f) verticalPages:false];
        
        CCMenuItemFont *menuItem1 = [CCMenuItemFont itemFromString:@"Menu" target:self selector:@selector(onMenu:)];
        menuItem1.position = ccp(-20, -250);
		
		//CCMenu *menu = [CCMenu menuWithItems:menuItem1, nil];
		//menu.position = ccp(-20,-250);
		//[menu alignItemsVertically];
        
        [menuGrid addChild:menuItem1 z:1 tag:0];
        //make grid its own class and add as a layer
		[self addChild:menuGrid];
    }
    return self;
}

-(void) LaunchLevel: (id) sender
{
    //Do shit
    //int i = 0;
}

- (void)onMenu:(id)sender
{
	NSLog(@"on menu");
	[[CCDirector sharedDirector] replaceScene:[MenuScene node]];
}

@end
