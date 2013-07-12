//
//  ScoreLayer.m
//  Score screen
//
//  Created by Pablo Ruiz on 06/06/11.
//  Copyright 2011 PlaySnack. All rights reserved.
//

#import "ScoreLayer.h"

@implementation ScoreLayer

@synthesize delegate;

+ (id) layerWithColor:(ccColor4B)color delegate:(id)_delegate score:(int) s target:(int) t diff:(int) d
{
	return [[self alloc] initWithColor:color delegate:_delegate score:s target:t diff:d];
}

- (id) initWithColor:(ccColor4B)c delegate:(id)_delegate score:(int) s target:(int) t diff:(int) d
{

    NSAssert(s>=0, @"s is not >= 0");
    NSAssert(t>=0,@"t is not >=0");
    NSAssert(d>=1,@"d is not at least 1");
    NSAssert(d<=3,@"d is greater than 3");
    self = [super initWithColor:c];
    if (self != nil) {
        NSLog(@"self != nil");
		CGSize wins = [[CCDirector sharedDirector] winSize];
        
		delegate = _delegate;
        [self scoreDelegate];
        
        self->difficulty = d;
        
        
        NSString * playString = [[NSString alloc] initWithFormat:@"Retry"];
        
        if (s >= t && d < 3) {
            playString = [[NSString alloc] initWithFormat:@"Continue"];
        }

        if (s >= t && d == 3) {
            playString = [[NSString alloc] initWithFormat:@"You Won!"];
        }
        
		CCMenuItemImage * play = [CCMenuItemLabel itemWithLabel:
                                   [CCLabelTTF labelWithString:playString fontName:@"Marker Felt" fontSize:80]
                                                         target:self selector:@selector(restartLevel:)];
        
        CCMenuItemImage * main = [CCMenuItemLabel itemWithLabel:
                                   [CCLabelTTF labelWithString:@"Main Menu" fontName:@"Marker Felt" fontSize:80]
                                                         target:self selector:@selector(returnToMainMenu:)];
        
        if (s >= t && d < 3) {
            		play = [CCMenuItemLabel itemWithLabel:
                            [CCLabelTTF labelWithString:playString fontName:@"Marker Felt" fontSize:80]
                              target:self selector:@selector(playNextLevel:)];
        }
        
        
        CCMenu * menu = [CCMenu menuWithItems:play,main,nil];
        
		[menu setPosition:ccp(0,0)];
		//[resume setPosition:ccp([background boundingBox].size.width/2,[background boundingBox].size.height/2)];
        [play setPosition:ccp(wins.width/2,wins.height/2)];
        [main setPosition:ccp(wins.width/2,wins.height/2 + 140)];

        [self addChild:menu];
        
        NSString * scoreString = [[NSString alloc] initWithFormat:@"Score: %d   Target: %d", s, t];
        
        CCLabelTTF * score = [CCLabelTTF labelWithString:scoreString fontName:@"Marker Felt" fontSize:80];
        [score setColor: ccc3(180,180,0)];
        [score setPosition:ccp(wins.width/2,wins.height/2 - 240)];
        
        [self addChild: score];
    }
    return self;
}

-(void)scoreDelegate
{
	if([delegate respondsToSelector:@selector(scoreLayerDidPause)])
		[delegate scoreLayerDidPause];
	[delegate onExit];
	[delegate.parent addChild:self z:10];
}



-(void) playNextLevel: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BetaGameLayer sceneWithLevel:(self->difficulty + 1)] withColor:ccBLACK]];
}
    

-(void) restartLevel: (id) sender
{
   [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BetaGameLayer sceneWithLevel:self->difficulty] withColor:ccBLACK]];
}


-(void) returnToMainMenu: (id) sender
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[MenuLayer scene] withColor:ccBLACK]];
}

@end