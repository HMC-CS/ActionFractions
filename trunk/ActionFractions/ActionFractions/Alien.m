//
//  Alien.m
//  ActionFractions
//
//  Created by Admin on 10/31/12.
//
//

#import "Alien.h"

@implementation Alien
@synthesize isTouched;

@synthesize moveAction;
@synthesize stareAction;
@synthesize fallAction;

-(id) initWithValue:(Fraction*) f andPosition:(CGPoint) pos
{
	if( (self=[super init]) ) {
        [self setValue:f];
        position = pos;
        speed = 0;
        state = WALKING_LEFT;
        direction = arc4random() % 2*3.1415;
        isTouched = false;
        
        // Begin animation code
        
        // loading animation spritesheets
        [[CCSpriteFrameCache sharedSpriteFrameCache] addSpriteFramesWithFile:@"alien1_default.plist"];
        CCSpriteBatchNode * spriteSheet = [CCSpriteBatchNode batchNodeWithFile:@"alien1_default.png"];
        [self addChild:spriteSheet];
        
        // load images for walking
        NSMutableArray * moveAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 7; ++i) {
            [moveAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"walk%d.png", i]]];
        }

        // load images for staring
        NSMutableArray * stareAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 2; ++i) {
            [stareAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"stare%d.png", i]]];
        }
        
        // load images for falling
        NSMutableArray * fallAnimFrames = [NSMutableArray array];
        for(int i = 1; i <= 2; ++i) {
            [fallAnimFrames addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:[NSString stringWithFormat:@"fall%d.png", i]]];
        }
        
        
        // set animations from the frames
        CCAnimation * moveAnim = [CCAnimation animationWithSpriteFrames:moveAnimFrames delay:0.1f];
        self.moveAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:moveAnim]];

        CCAnimation * stareAnim = [CCAnimation animationWithSpriteFrames:stareAnimFrames delay:0.2f];
        self.stareAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:stareAnim]];
        
        CCAnimation * fallAnim = [CCAnimation animationWithSpriteFrames:fallAnimFrames delay:0.2f];
        self.fallAction = [CCRepeatForever actionWithAction:[CCAnimate actionWithAnimation:fallAnim]];
        
        [self setSprite:[CCSprite spriteWithSpriteFrameName:@"stare1.png"]];
        
        [[self sprite] runAction:stareAction];
        [spriteSheet addChild: [self sprite]];
        
        // End animation code
        
        self.sprite.position = self->position;
        [self resizeSpritetoWidth:150 toHeight:105];
        
        label = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:18];
        [self updateLabel];
        //label.position = position; //this seems to do nothing?
        label.color = ccc3(200,15,225);
        [self addChild: label];
        
        self.guessedWrong = NO;
	}
	return self;
}

- (void)onEnter
{
	[[[CCDirector sharedDirector] touchDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	[super onEnter];
}

- (void)onExit
{
	[[[CCDirector sharedDirector] touchDispatcher] removeDelegate:self];
	[super onExit];
}

-(BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event
{
    // behavior for when the alien is picked up
    
    CGPoint location = [touch locationInView: [touch view]];
    location = [[CCDirector sharedDirector] convertToGL:location];
    
    if (CGRectContainsPoint( [self.sprite boundingBox], location)) {
        [self setTouched: true];
        return YES;
    }
    return NO;
}

-(void) ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event
{
    // behavior for when the alien is moved
    
    CGPoint location = [self convertTouchToNodeSpace:touch];
    [self updatePositionWithPoint: location];
}

-(void) ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event
{
    // behavior for when the alien is dropped
    
    [self setTouched: false];
    self.guessedWrong = NO;
}

-(void) ccTouchCancelled:(NSSet *)touch withEvent:(UIEvent *)event
{
    [self setTouched: false];
}


-(void) updatePositionWithPoint:(CGPoint) location
{
    if (isTouched) {
        position = location;
        self.sprite.position = position;
        label.position = position;
    }
}

-(void) updatePosition:(ccTime) dt givenBounds:(CGSize) bounds
{
    // controls state and movement of alien
    
    if (isTouched) {
        if (state != STARING) {
            state = STARING;
            [self updateAnimationWithBounds:bounds];
        }
        speed = 0.0;
        return;
    }
    
    if (position.y > bounds.height) {
        if (state != FALLING) {
            state = FALLING;
            [self updateAnimationWithBounds:bounds];
        }
        speed+=9.8f;
        direction = -3.14159/2;
        position.x += speed * cos(direction) * dt;
        position.y += speed * sin(direction) * dt;
    } else {
        if (state == FALLING) {
            state = STARING;
            [self updateAnimationWithBounds:bounds];
        }        
        /*
        if (arc4random() % 300 == 12) {
            state = WALKING_LEFT;
            [self updateAnimationWithBounds:bounds];
        }*/

        else if (arc4random() % 300 == 193) {
            state = WALKING_RIGHT;
            [self updateAnimationWithBounds:bounds];
        }
        
    }
    
    // If alien is walking then we are using the ccsprite ccmoveto method so we must update position based on that
    // otherwise we are calculating position ourselves so we must make sprite match
    if (state == WALKING_LEFT || state == WALKING_RIGHT)
        position = self.sprite.position;
    else
        self.sprite.position = position;
    label.position = position;
}


-(void) updateAnimationWithBounds: (CGSize) bounds
{
    // sets animation based on state. This function is only called on state change, not at every update.
    
    if (state == STARING) {
        [[self sprite] stopAllActions];
        self.sprite.flipX = NO;
        [[self sprite] runAction:stareAction];
    }
    
    else if (state == FALLING) {
        [[self sprite] stopAllActions];
        self.sprite.flipX = NO;
        [[self sprite] runAction:fallAction];
    }
    
    else if (state == WALKING_LEFT) {
        [[self sprite] stopAllActions];
        self.sprite.flipX = NO;
        [[self sprite] runAction:moveAction];
        id actionMoveToPoint = [CCMoveTo actionWithDuration:3 position:
                                   ccp( (arc4random() % (int)(self.position.x-self.sprite.boundingBox.size.width))+self.sprite.boundingBox.size.width, (arc4random() % (int)(bounds.height-self.sprite.boundingBox.size.height))+self.sprite.boundingBox.size.height)];
        id actionMoveFinished = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
        [[self sprite] runAction:[CCSequence actions:actionMoveToPoint, actionMoveFinished, nil]];
    }

    
    else if (state == WALKING_RIGHT) {
        [[self sprite] stopAllActions];
        self.sprite.flipX = YES;
        [[self sprite] runAction:moveAction];
        id actionMoveToPoint = [CCMoveTo actionWithDuration:3 position:
                                ccp( (int)self.position.x + (arc4random()  % (int)(bounds.width - self.position.x-self.sprite.boundingBox.size.width)), (arc4random() % (int)bounds.height-self.sprite.boundingBox.size.height)+self.sprite.boundingBox.size.height)];
        id actionMoveFinished = [CCCallFuncN actionWithTarget:self selector:@selector(spriteMoveFinished:)];
        [[self sprite] runAction:[CCSequence actions:actionMoveToPoint, actionMoveFinished, nil]];
    }
    
}


-(void) spriteMoveFinished:(id) sender
{
    state = STARING;
    [[self sprite] stopAllActions];
    [[self sprite] runAction:stareAction];
    
}


-(void) setTouched:(bool) b {
    
    // changes alien color when you pick them up
    
    isTouched = b;
    if (b) {
        [self.sprite setColor: ccc3(0,155,10)];
    } else {
        [self.sprite setColor: ccc3(255,255,255)];
    }
}


@end
