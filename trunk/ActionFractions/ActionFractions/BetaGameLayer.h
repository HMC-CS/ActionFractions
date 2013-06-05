//
//  BetaGameLayer.h
//  ActionFractions
//
//  Created by Admin on 10/23/12.
//
//

#import "cocos2d.h"
#import "GameElement.h"
#import "Alien.h"
#import "Portal.h"
#import "PauseLayer.h"
#import "SimpleAudioEngine.h"
#import "MenuLayer.h"
#import "ScoreLayer.h"



@interface BetaGameLayer : CCLayer {
    CCLayer * backgroundLayer;
    CCSprite * backgroundImage;
    CCParticleSystemQuad * galaxy;
    
    CCLayer * portalLayer;
    CCLayer * alienLayer;
    CCSprite * alienImage;
    
    CCLayer * interfaceLayer;
    CCLabelTTF * pauseButton;
    
    CCLabelTTF * timerLabel;
    
    CCLabelTTF * scoreLabel;
    
    CCLabelTTF * targetLabel;
    
    Alien* currentAlien;
  
    Portal * portal;
    Alien* aliens[50];
    
    SimpleAudioEngine* simpleAudioEngine;
    int LEVEL;
}

// returns a CCScene that contains the BetaGameLayer as the only child
+(CCScene *) scene;
+(CCScene *) sceneWithLevel: (int) level;

@property (nonatomic) int countTime;

@property (nonatomic) int score;

@end
