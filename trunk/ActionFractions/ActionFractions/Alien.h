//
//  Alien.h
//  ActionFractions
//
//  Created by Admin on 10/31/12.
//
//

#import "GameElement.h"

typedef enum alienStateTypes {
    WALKING_LEFT,
    WALKING_RIGHT,
    FALLING,
    STARING,
    IDLE
} AlienState;

@interface Alien : GameElement {
    double speed;
    double direction;
    AlienState state;
}
@property bool isTouched;
@property (nonatomic, retain) CCAction * moveAction;
@property (nonatomic, retain) CCAction * stareAction;
@property (nonatomic, retain) CCAction * fallAction;

-(void) setTouched:(bool) b;
-(void) updatePositionWithPoint:(CGPoint) location;
-(void) spriteMoveFinished:(id) sender;

@end
