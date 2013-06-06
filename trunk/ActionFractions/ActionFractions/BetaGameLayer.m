//
//  BetaGameLayer.m
//  ActionFractions
//
//  Created by Admin on 10/23/12.
//
//

#import "BetaGameLayer.h"

@implementation BetaGameLayer

@synthesize countTime = _countTime;
@synthesize score = _score;

const int NUMALIENS = 8;
const int LEVELTIME = 120;
const int STARTSCORE = 0;
const int CORRECTPOINTS = 10;
const int WRONGPOINTS = -5;
const int LABELFONTSIZE = 30;

// Helper class method that creates a Scene with the HelloWorldLayer as the only child.
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BetaGameLayer *layer = [BetaGameLayer node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

+(CCScene *) sceneWithLevel: (int) level
{
    
       
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	BetaGameLayer *layer = [BetaGameLayer alloc];
	layer->LEVEL = level;
    //[[layer init] autorelease];
	[layer init];
    // add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
	if( (self=[super init]) ) {
        self.isTouchEnabled = YES;
        
		// ask director for the window size
		CGSize size = [[CCDirector sharedDirector] winSize];


        // set up background
        backgroundLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 200, 255) width:size.width height:size.height];
        backgroundImage = [CCSprite spriteWithFile: @"planet_bg.png"];
        backgroundImage.scaleX = size.height / backgroundImage.contentSize.height;
        backgroundImage.scaleY = size.width / backgroundImage.contentSize.width;
        backgroundImage.anchorPoint = ccp(0,0);
        [backgroundLayer addChild:backgroundImage];

        // Set up galaxy
        [self setupGalaxy];
        [backgroundLayer addChild:galaxy];
        
        // set up ui layer
        // pause
        pauseButton = [CCLabelTTF labelWithString:@"Pause" fontName:@"Marker Felt" fontSize:LABELFONTSIZE];
        interfaceLayer = [CCLayerColor layerWithColor:ccc4(0, 0, 50, 55) width:size.width height: pauseButton.contentSize.height];
        interfaceLayer.position = ccp(0,size.height-pauseButton.contentSize.height);
        pauseButton.anchorPoint = ccp(0,0);
        pauseButton.position = ccp( size.width - pauseButton.contentSize.width, 0);
        [interfaceLayer addChild:pauseButton];
        
        // Timer
        _countTime = LEVELTIME;
        timerLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Time: %02d:%02d", self.countTime /60, self.countTime % 60] fontName:@"Marker Felt" fontSize:LABELFONTSIZE];
        timerLabel.anchorPoint = ccp(0,0);
        timerLabel.position = ccp(0,0);
        [interfaceLayer addChild:timerLabel];
        [self schedule:@selector(countDown:) interval:1.0f];  // Timer update
        
        // Score
        _score = STARTSCORE;
        scoreLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Score: %d", self.score] fontName:@"Marker Felt" fontSize:LABELFONTSIZE];
        NSLog(@"%d", self.score);
        scoreLabel.anchorPoint = ccp(0,0);
        scoreLabel.position = ccp(3.0*size.width/4.0 - scoreLabel.contentSize.width, 0);
        [interfaceLayer addChild:scoreLabel];
        
        
        //Target
        targetLabel = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"Goal: %d", [self targetScore]] fontName:@"Marker Felt" fontSize:LABELFONTSIZE];
        targetLabel.anchorPoint = ccp(0,0);
        targetLabel.position = ccp(size.width/4.0, 0);
        [interfaceLayer addChild:targetLabel];
        
        
        
        // Set up alien layer
        alienLayer = [CCLayerColor layerWithColor:ccc4(0, 100, 0, 0) width:size.width height:size.height/2 - 30];
        alienImage = [CCSprite spriteWithFile: @"alien_bg.png"];
        alienImage.anchorPoint = ccp(0,0);
        alienImage.scaleY = size.height / alienImage.contentSize.height;
        alienImage.scaleX = size.width / alienImage.contentSize.width;
        [alienLayer addChild: alienImage];
        
        // Add all layers
        [self addChild:backgroundLayer];
        [self addChild:alienLayer];
        [self addChild:interfaceLayer];

        // Setup game elements
        // Aliens
        [self setup: NUMALIENS AliensWithLevel: LEVEL];
        short alienIndex = arc4random()%NUMALIENS;
        // Portal
        Fraction* portalFraction = aliens[alienIndex].value;
        portal = [[Portal alloc] initWithValue:portalFraction andPosition: CGPointMake(size.width/2, 3*size.height/4)];
        [backgroundLayer addChild: portal];
        
        // Setup Background music
        [CDAudioManager initAsynchronously:kAMM_MediaPlayback]; // Plays music whether ipad is mute or not
        simpleAudioEngine = [SimpleAudioEngine sharedEngine];
        [simpleAudioEngine preloadBackgroundMusic:@"bgMusic.caf"];
        [simpleAudioEngine preloadBackgroundMusic:@"scream.mp3"];
        [simpleAudioEngine preloadBackgroundMusic:@"yeay.mp3"];
        [simpleAudioEngine preloadBackgroundMusic:@"uhoh.mp3"];
        [simpleAudioEngine playBackgroundMusic:@"bgMusic.caf"];
        [simpleAudioEngine setBackgroundMusicVolume:0.5f]; // slightly lower volume for other sound effects
        [simpleAudioEngine setEffectsVolume:1.5f];
        
        // Game loop update
        [self schedule:@selector(gameLoop:) interval: 1/60.0f];
	}
	return self;
}

-(void) setup: (int) numAliens AliensWithLevel: (int) Level {
    for(int i =0; i < NUMALIENS; ++i) {
        aliens[i] = [[Alien alloc] initWithValue:[self newFractionThroughAlien: i] andPosition:
                     CGPointMake((arc4random() % (int)alienLayer.contentSize.width- alienImage.boundingBox.size.width)+alienImage.boundingBox.size.width, (arc4random() % (int)alienLayer.contentSize.height- alienImage.boundingBox.size.height )+ alienImage.boundingBox.size.height)];
        [alienLayer addChild: aliens[i] ];
        //[self checkAliensBounds:aliens[i]];
    }
}

-(void) setupGalaxy {
    
    // parameter setup for the starry background particle system
    
    galaxy = [[CCParticleFlower alloc ] initWithTotalParticles:5000];
    galaxy.emitterMode = kCCParticleModeRadius;
    galaxy.texture = [[CCTextureCache sharedTextureCache] addImage:@"star.png"];
    galaxy.position = ccp( -100, - 100 );
    galaxy.startRadius = 800;
    galaxy.startRadiusVar = 800;
    galaxy.endRadius = 800;
    galaxy.endRadiusVar = 800;
    galaxy.rotatePerSecond = .3;
    galaxy.rotatePerSecondVar = .3;
    galaxy.life = 100000;
    galaxy.startColor = ccc4f(225, 225, 225, 0);
    galaxy.startSize = 12;
    galaxy.startSizeVar = 5;
    galaxy.blendAdditive = true;
    galaxy.emissionRate = 100000;
}

-(void)countDown:(ccTime) dt {
    
    // this function is called every second via a scheduler to update the clock countdown.
    
    self.countTime--;
    [timerLabel setString:[NSString stringWithFormat:@"Time: %02d:%02d", self.countTime /60, self.countTime % 60]];
    if (self.countTime <= 0) {
        [self unschedule:@selector(countDown:)];
        [self endGame];
    }
}

-(void)updateScore:(int) points {
    
    // increments score and updates score display
    
    self.score += points;
    if (self.score < 0) self.score = 0;
    [scoreLabel setString:[NSString stringWithFormat:@"Score: %d", self.score]];
}


-(void)pauseGame
{
    // brings up pause screen and menu (pauses game in background).
    // this is handled by a separate scene.
    
    ccColor4B c ={0,0,0,45};
	[PauseLayer layerWithColor:c delegate: (PauseLayerProtocol*)self];
}

-(void)endGame
{
    // brings up the post-game menu to display score and "play again" etc.
    // handled by a separate scene.
    
    ccColor4B c ={0,0,0,45};
	[ScoreLayer layerWithColor:c delegate: (ScoreLayerProtocol*)self score:self.score target:[self targetScore] diff:self->LEVEL];
}

-(int) targetScore
{
    // calculates target score based on difficulty
    return 75 + (self->LEVEL * 25);
}

-(void) registerWithTouchDispatcher
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // handles touch (so the pause button can be poked as well as the aliens).
    
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    // check if pause button is pressed
    if (CGRectContainsPoint( [pauseButton boundingBox], [interfaceLayer convertTouchToNodeSpace: touch] )) {
        [self pauseGame];
        return YES;
    }
    
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{

}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{

    
}

-(void) ccTouchCancelled:(NSSet *)touch withEvent:(UIEvent *)event
{

}



-(Fraction*) newFractionThroughAlien: (int) numAlien {
    
    // selects a fraction from the live aliens' fractions (for the portal).
    
    Fraction *current = [[Fraction alloc] initWithLvl:LEVEL];
    for (int j=0; j<numAlien; j++)
        if ([aliens[j].value exactlyEquals:current]) {
            return [self newFractionThroughAlien: numAlien];
        }
    
    return current;
}

-(void) gameLoop: (ccTime) dT
{
    // Check if alien is in portal
    for(int i =0; i < NUMALIENS; ++i) {
        // Alienlayer is a bit too tall relative to its graphic so we shrink the size aliens knows about..
        [aliens[i] updatePosition: dT givenBounds: CGSizeMake(alienLayer.contentSize.width, alienLayer.contentSize.height-35)];
        if ( aliens[i].isTouched && CGRectContainsPoint([[portal sprite] boundingBox], [aliens[i] sprite].position)) {
            if ([[portal value] equals: [aliens[i] value]]) {
                [simpleAudioEngine playEffect:@"yeay.mp3"]; // play happy soundeffect
                [self updateScore:CORRECTPOINTS]; // increase score
                NSLog(@"%d", self.score);
                short alienIndex = arc4random()%NUMALIENS;
                bool foundDifferentFraction = false;
                [aliens[i] updatePositionWithPoint: CGPointMake(arc4random() % (int)alienLayer.contentSize.width
                                                                ,arc4random() % (int)alienLayer.contentSize.height)];
                [aliens[i] setTouched: false];
                [aliens[i] updateValue: [self newFractionThroughAlien:NUMALIENS]];
                while (!foundDifferentFraction){
                    if ([aliens[alienIndex].value equals:[portal value]]){alienIndex = arc4random()%NUMALIENS;}
                         else {foundDifferentFraction = true;}
                }
                Fraction* portalFraction = aliens[alienIndex].value;
                [[portal value] setFraction:portalFraction];
                [portal updateLabel];
  
            } else {
                [simpleAudioEngine playEffect:@"uhoh.mp3"];
                [[aliens[i] sprite] setColor: ccc3(255,0,0)];
                
                if (!aliens[i].guessedWrong)
                {
                    aliens[i].guessedWrong = YES;
                    [self updateScore:WRONGPOINTS];
                }
                //aliens[i].guessedWrong = YES;
                //[aliens[i] setTouched:false];
            }
        }
    }
    
        
    
    [portal updatePosition: dT];
}

@end

