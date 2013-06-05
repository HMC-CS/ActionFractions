//
//  GameElement.h
//  ActionFractions
//
//  Created by Admin on 10/23/12.
//
//

#import <Foundation/Foundation.h>
#import "Fraction.h"
#import "cocos2d.h"

@interface GameElement : CCLayer {
    //Fraction * value;
    CCLabelTTF * label;
    CGPoint position;
}
@property(retain) CCSprite * sprite;
@property(retain) Fraction * value;

-(id) initWithValue:(Fraction*) f andPosition:(CGPoint) pos;
-(void) updateLabel;
-(void) updatePosition:(ccTime) dt;
-(void) updatePosition:(ccTime) dt givenBounds:(CGSize) bounds;
-(void) updateValue:(Fraction*) newValue;
-(void)resizeSpritetoWidth:(float)width toHeight:(float)height;

//-(void)setSprite:(CCSprite*) newSprite;
@end
