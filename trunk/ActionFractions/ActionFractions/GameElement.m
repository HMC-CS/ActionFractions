//
//  GameElement.m
//  ActionFractions
//
//  Created by Admin on 10/23/12.
//
//

#import "GameElement.h"

@implementation GameElement
@synthesize sprite;
@synthesize value;

-(id) initWithValue:(Fraction*) f andPosition:(CGPoint) pos
{

	if( (self=[super init]) ) {
        value = f;
        position = pos;
        sprite = [CCSprite alloc];
	}
	return self;
}

-(void) updatePosition:(ccTime) dt
{
    
}

-(void) updateValue: (Fraction*) newValue
{
    [self setValue: newValue];
    [self updateLabel];
}


-(void) updateLabel
{
    [label setString:[NSString stringWithFormat:@"%d / %d",
                      [[self value] getNumerator], [[self value] getDenominator]]];
}


-(void)resizeSpritetoWidth:(float)width toHeight:(float)height {
    sprite.scaleX = width / sprite.contentSize.width;
    sprite.scaleY = height / sprite.contentSize.height;
}


-(void)updatePosition:(ccTime)dt givenBounds:(CGSize)bounds
{
    
}
@end
