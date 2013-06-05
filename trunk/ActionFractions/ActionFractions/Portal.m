//
//  Portal.m
//  ActionFractions
//
//  Created by Admin on 10/31/12.
//
//

#import "Portal.h"

@implementation Portal

-(id) initWithValue:(Fraction*) f andPosition:(CGPoint) pos
{
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
        [self updateLabel];
        label.position = position;
        //label.color = ccc3(200,25,25);
        [self addChild: label];
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
    
    [label setString:[NSString stringWithFormat:@"%g", (1.0 * [[self value] getNumerator]) / (1.0 * [[self value] getDenominator]) ]];
}

@end
