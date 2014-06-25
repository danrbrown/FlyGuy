//
//  MyScene.h
//  spritKitTut
//

//  Copyright (c) 2014 15and50. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene <SKPhysicsContactDelegate> {

    UISwipeGestureRecognizer* swipeUp;
    UISwipeGestureRecognizer* swipeDown;
    
    SKSpriteNode *player;
    SKSpriteNode *TopCoin;
    SKSpriteNode *MidCoin;
    SKSpriteNode *BotCoin;
    
    SKLabelNode *scoreLabel;
    SKLabelNode *GameOverLabel;
    SKLabelNode *YourScoreWasLabel;
    SKLabelNode *YourHighScoreWasLabel;
    SKLabelNode *tapToPlayLabel;
    SKLabelNode *tapToPlayFirstLabel;
    
    int moveToX;
    int score;
    int lives;

    int CURRENT_COIN;
    BOOL ROW_ZERO, ROW_ONE, ROW_TWO;
    BOOL gameOver;
    
    NSTimeInterval _lastUpdateTime;
    NSTimeInterval _dt;
    CGPoint _velocity;
    
}

@end