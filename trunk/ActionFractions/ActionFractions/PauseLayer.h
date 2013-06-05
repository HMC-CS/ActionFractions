//
//  PauseLayer.h
//  ActionFractions
//
//  Created by Admin on 11/4/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface PauseLayerProtocol: CCNode

-(void)pauseLayerDidPause;
-(void)pauseLayerDidUnpause;
@end

@interface PauseLayer : CCLayerColor {
    
	PauseLayerProtocol * delegate;
}

@property (nonatomic,assign)PauseLayerProtocol * delegate;

+ (id) layerWithColor:(ccColor4B)color delegate:(PauseLayerProtocol *)_delegate;
- (id) initWithColor:(ccColor4B)c delegate:(PauseLayerProtocol *)_delegate;
-(void)pauseDelegate;

@end