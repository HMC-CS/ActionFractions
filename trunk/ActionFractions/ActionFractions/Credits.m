//
//  Credits.m
//  ActionFractions
//
//  Created by Paige Garratt on 6/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Credits.h"
#import "MenuLayer.h"


@implementation Credits

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Credits *layer = [Credits node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
    if (self = [super init]) {
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        // Create Instructions Background
        CCSprite *background = [CCSprite spriteWithFile:@"full_bg.png"];
        background.position = ccp( size.width/2, size.height/2);
        [self addChild:background];
        
        // Get the file from the resources
        NSString* path = [[NSBundle mainBundle] pathForResource:@"Credits" ofType:@"txt"];
        NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        // Create the label to display instructions
        CCLabelTTF *label = [CCLabelTTF labelWithString:fileContents fontName:@"Marker Felt" fontSize:36];
        [label setColor:ccc3(200, 200, 200)];
        
        // Position it on the screen
        label.position = ccp(512,384);
        
        // Add it to the scene so it can be displayed
        [self addChild:label];
        
        //Create the menu and its items
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:24];
        
        CCMenuItem *back = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer node] withColor:ccBLACK]];
        }];
        
        CCMenu* menu = [CCMenu menuWithItems:back, nil];
        menu.position = ccp(size.width/2, size.height/8);
        [self addChild: menu];
        
        return self;
    }
    return nil;
}

@end
