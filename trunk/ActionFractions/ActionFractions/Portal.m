//
//  Portal.m
//  ActionFractions
//
//  Created by Admin on 10/31/12.
//
//

#import "Portal.h"

@implementation Portal{
    CCLabelTTF* newLabel;
}

-(id) initWithValue:(Fraction*) f andPosition:(CGPoint) pos
{
    CGSize winSize = [[CCDirector sharedDirector]winSize];
    NSAssert(f!=nil && pos.y<=winSize.height && pos.x<=winSize.width, @"Failed to initialize Portal with Fraction and/or position");
	if( (self=[super init]) ) {
        [self setValue:f];
        position = pos;
        
        // Set up the portal sprite
        
        [self setSprite:[CCSprite spriteWithFile: @"portal1.png"]];
        [self addChild: [self sprite]];
        self.sprite.position = self->position;
        [self resizeSpritetoWidth:300 toHeight:300];
        
        // set up label text
        
        label = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:24];
        newLabel = [CCLabelTTF labelWithString:@"" fontName:@"Arial" fontSize:24];
        [self updateLabel];
        label.position = position;
        newLabel.position = CGPointMake(position.x+28, position.y+25);
        [self addChild: label];
        [self addChild: newLabel];
    }
	return self;
}

-(void) updatePosition:(ccTime)dt
{
    // causes the portal to rotate in place.
    
    deltaRotation = 40;
    rotation += deltaRotation * dt;
    
    self.sprite.rotation = rotation;
}

-(void) updateLabel
{
    // change label text for when the portal is "reset"
    NSString* displayDecimal = [[NSString alloc] initWithFormat:@"%g", (1.0 * [[self value] getNumerator]) / (1.0 * [[self value] getDenominator])];
    int count = displayDecimal.length;
    if (count>6) {
        count = 6;
    }
    [label setString:[displayDecimal substringWithRange:NSMakeRange(0, count)]];
    [newLabel setString:@""];
    
    if ([[self value] isRepeating]){
        [newLabel setString:@"_"];
    }
    if ([[self value] getDenominator] == 11 && [[self value] getNumerator]!=11) {
        newLabel.position = CGPointMake(position.x+22, position.y+25);
        [newLabel setString:@"__"];
    }
}

@end
