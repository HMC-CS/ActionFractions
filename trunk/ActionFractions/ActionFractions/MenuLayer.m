//
//  IntroLayer.m
//  ActionFractions
//
//  Created by Admin on 10/31/12.
//  Copyright __MyCompanyName__ 2012. All rights reserved.
//


// Import the interfaces
#import "MenuLayer.h"



#pragma mark - MenuLayer

// HelloWorldLayer implementation
@implementation MenuLayer

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	MenuLayer *layer = [MenuLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// 
-(void) onEnter
{
	[super onEnter];
	CGSize size = [[CCDirector sharedDirector] winSize];

    // Set up background
    CCSprite *backgroundImage = [CCSprite spriteWithFile: @"planet_bg.png"];
    backgroundImage.scaleX = 2*size.height / backgroundImage.contentSize.height;
    backgroundImage.scaleY = 2*size.width / backgroundImage.contentSize.width;
    [backgroundImage setPosition:ccp(0,50)];
    [self addChild:backgroundImage];
    
    // Set up galaxy background
    CCParticleSystemQuad * galaxy = [[CCParticleGalaxy alloc ] initWithTotalParticles:5000];
    galaxy.emitterMode = kCCParticleModeRadius;
    galaxy.texture = [[CCTextureCache sharedTextureCache] addImage:@"star.png"];
    galaxy.position = ccp( -100, - 100 );
    galaxy.startRadius = 800;
    galaxy.startRadiusVar = 800;
    galaxy.endRadius = 800;
    galaxy.endRadiusVar = 800;
    galaxy.rotatePerSecond = .53;
    galaxy.rotatePerSecondVar = .3;
    galaxy.life = 100000;
    galaxy.startColor = ccc4f(20,100,20,255);
    galaxy.startColorVar = ccc4f(200,200,200,150);
    galaxy.startSize = 12;
    galaxy.startSizeVar = 9;
    galaxy.blendAdditive = true;
    galaxy.emissionRate = 100000;
    [self addChild:galaxy];
    
    
    // Main title
    CCLabelTTF * titleLabel = [CCLabelTTF labelWithString:@"Action Fractions" fontName:@"Marker Felt" fontSize:140];
    
    [titleLabel setPosition: ccp(size.width/2, size.height*3/4)];
    [self addChild: titleLabel];
    
    // Menu
    CCMenuItemLabel *level1But = [CCMenuItemLabel
                                  itemWithLabel:[CCLabelTTF labelWithString:@"Level 1" fontName:@"Marker Felt" fontSize:60]
                                  target:self
                                  selector:@selector(startLevelOne)];
    [level1But setColor:ccc3(200, 200, 200)];
    
    CCMenuItemLabel *level2But = [CCMenuItemLabel
                                  itemWithLabel:[CCLabelTTF labelWithString:@"Level 2" fontName:@"Marker Felt" fontSize:60]
                                  target:self
                                  selector:@selector(startLevelTwo)];
    [level2But setColor:ccc3(200, 200, 200)];
    
    CCMenuItemLabel *level3But = [CCMenuItemLabel
                                  itemWithLabel:[CCLabelTTF labelWithString:@"Level 3" fontName:@"Marker Felt" fontSize:60]
                                  target:self
                                  selector:@selector(startLevelThree)];
    [level3But setColor:ccc3(200, 200, 200)];
    
    CCMenu * menu = [CCMenu menuWithItems:level1But,level2But,level3But,nil];
    [menu alignItemsHorizontallyWithPadding:95.0];
    [menu setPosition:ccp(size.width/2,size.height/2)];
    [self addChild:menu];
     
}

-(void) makeTransition:(ccTime)dt
{
	[[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BetaGameLayer scene] withColor:ccBLACK]];
}

-(void) startLevelOne
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BetaGameLayer sceneWithLevel:1] withColor:ccBLACK]];
}

-(void) startLevelTwo
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BetaGameLayer sceneWithLevel:2] withColor:ccBLACK]];
}

-(void) startLevelThree
{
    [[CCDirector sharedDirector] replaceScene:[CCTransitionFade transitionWithDuration:1.0 scene:[BetaGameLayer sceneWithLevel:3] withColor:ccBLACK]];
}

@end
