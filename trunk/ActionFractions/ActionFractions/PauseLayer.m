//
//  PauseLayer.m
//  Pause
//
//  Created by Pablo Ruiz on 06/06/11.
//  Copyright 2011 PlaySnack. All rights reserved.
//

#import "PauseLayer.h"
#import "MenuLayer.h"

@implementation PauseLayer

@synthesize delegate;

+ (id) layerWithColor:(ccColor4B)color delegate:(id)_delegate
{
	return [[[self alloc] initWithColor:color delegate:_delegate] autorelease];
}

- (id) initWithColor:(ccColor4B)c delegate:(id)_delegate {
    self = [super initWithColor:c];
    if (self != nil) {
        
		CGSize wins = [[CCDirector sharedDirector] winSize];
        
		delegate = _delegate;
		[self pauseDelegate];

		CCMenuItemImage * resume = [CCMenuItemLabel itemWithLabel:                                 
                                   [CCLabelTTF labelWithString:@"Resume" fontName:@"Marker Felt" fontSize:80]
                                   target:self selector:@selector(doResume:)];
        
        CCMenuItemImage * main = [CCMenuItemLabel itemWithLabel:
                                  [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:80]
                                                         target:self selector:@selector(returnToMainMenu:)];
        
        CCMenu * menu = [CCMenu menuWithItems:main,resume,nil];
        
		[menu setPosition:ccp(0,0)];
		//[resume setPosition:ccp([background boundingBox].size.width/2,[background boundingBox].size.height/2)];
        [resume setPosition:ccp(wins.width/2,wins.height/2)];
        [main setPosition:ccp(wins.width/2,wins.height/2 + 140)];
        
        [self addChild:menu];
    }
    return self;
}

-(void)pauseDelegate
{
	if([delegate respondsToSelector:@selector(pauseLayerDidPause)])
		[delegate pauseLayerDidPause];
	[delegate onExit];
	[delegate.parent addChild:self z:10];
}

-(void)doResume: (id)sender
{
	[delegate onEnter];
	if([delegate respondsToSelector:@selector(pauseLayerDidUnpause)])
		[delegate pauseLayerDidUnpause];
	[self.parent removeChild:self cleanup:YES];
}

-(void) returnToMainMenu: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene] withColor:ccBLACK]];
}

-(void)dealloc
{
	[super dealloc];
}

@end