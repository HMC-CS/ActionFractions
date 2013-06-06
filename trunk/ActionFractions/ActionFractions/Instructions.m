//
//  Instructions.m
//  ActionFractions
//
//  Created by Paige Garratt on 6/5/13.
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import "Instructions.h"
#import "MenuLayer.h"


@implementation Instructions

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Instructions *layer = [Instructions node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init{
    if (self = [super init]) {
        // ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
        
        CCSprite *backgroundImage = [CCSprite spriteWithFile: @"planet_bg.png"];
        backgroundImage.scaleX = 2*size.height / backgroundImage.contentSize.height;
        backgroundImage.scaleY = 2*size.width / backgroundImage.contentSize.width;
        [backgroundImage setPosition:ccp(500,50)];
        [self addChild:backgroundImage];

        
        // Get the file from the resources
        NSString* path = [[NSBundle mainBundle] pathForResource:@"Instructions" ofType:@"txt"];
        NSAssert(path !=nil, @"Cannot find Instructions file");
        NSString* fileContents = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        // Create the label to display instructions
        CCLabelTTF *label = [CCLabelTTF labelWithString:fileContents fontName:@"Marker Felt" fontSize:36];
        [label setColor: ccWHITE];
        
        // Position it on the screen
        label.position = ccp(512,384);
        
        // Add it to the scene so it can be displayed
        [self addChild:label];
        
        //Create the menu and its items
        [CCMenuItemFont setFontName:@"Marker Felt"];
        [CCMenuItemFont setFontSize:30];
        
        CCMenuItem *back = [CCMenuItemFont itemWithString:@"Main Menu" block:^(id sender) {
            [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer node] withColor:ccBLACK]];
        }];
        
        CCMenu* menu = [CCMenu menuWithItems:back, nil];
        menu.position = ccp(size.width/2, size.height/8);
        //[menu setColor: ccBLACK];
        [self addChild: menu];
        
        return self;
    }
    return nil;
}

@end
