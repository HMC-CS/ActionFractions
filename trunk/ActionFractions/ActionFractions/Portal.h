//
//  Portal.h
//  ActionFractions
//
//  Created by Admin on 10/31/12.
//
//

#import "GameElement.h"

@interface Portal : GameElement {
    float rotation;
    float deltaRotation;
}
-(void) updateLabel;
@end
