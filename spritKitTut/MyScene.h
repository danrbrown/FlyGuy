//
//  MyScene.h
//  spritKitTut
//

//  Copyright (c) 2014 15and50. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "FMMParallaxNode.h"

@interface MyScene : SKScene <SKPhysicsContactDelegate> {
    
    SKSpriteNode *player;
    SKSpriteNode *fuelSrite;
    SKSpriteNode *rockSprite;
    SKSpriteNode *timesTwoSprite;
    
    SKLabelNode *scoreLabel;
    SKLabelNode *GameOverLabel;
    SKLabelNode *YourScoreWasLabel;
    SKLabelNode *YourHighScoreWasLabel;
    SKLabelNode *tapToPlayLabel;
    SKSpriteNode *tapToPlayFirstLabel;
    
    SKShapeNode *fuelTank;
    
    int moveToX;
    int score;
    int highscore;
    int fuel;
    int maxFuel;

    BOOL gameOver;
    BOOL playing;
    BOOL done;
    BOOL unlockedTwo;
    
    FMMParallaxNode *_parallaxNodeBackgrounds;
    FMMParallaxNode *_parallaxSpaceDust;
    
}

typedef enum : uint8_t {
    JCColliderTypeRectangle = 1,
    JCColliderTypeObstacle  = 2
} JCColliderType;

@end