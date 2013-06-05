//
//  PauseLayer.h
//  ActionFractions
//
//  Created by Admin on 11/4/12.
//
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"
#import "BetaGameLayer.h"

@interface ScoreLayerProtocol: CCNode
    -(void)scoreLayerDidPause;
    -(void)scoreLayerDidUnpause;
@end

@interface ScoreLayer : CCLayerColor {
    
	ScoreLayerProtocol * __weak delegate;
    int difficulty;
}

@property (nonatomic,weak)ScoreLayerProtocol * delegate;

+ (id) layerWithColor:(ccColor4B)color delegate:(ScoreLayerProtocol *)_delegate score:(int) s target:(int) t diff:(int) d;
- (id) initWithColor:(ccColor4B)c delegate:(ScoreLayerProtocol *)_delegate score:(int) s target:(int) t diff:(int) d;
-(void)scoreDelegate;

@end