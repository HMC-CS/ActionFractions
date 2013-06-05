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
@property bool guessedWrong;
@property bool isTouched;
@property (nonatomic, strong) CCAction * moveAction;
@property (nonatomic, strong) CCAction * stareAction;
@property (nonatomic, strong) CCAction * fallAction;

-(void) setTouched:(bool) b;
-(void) updatePositionWithPoint:(CGPoint) location;
-(void) spriteMoveFinished:(id) sender;

@end
