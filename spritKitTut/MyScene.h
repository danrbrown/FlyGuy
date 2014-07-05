//
//  MyScene.h
//  spritKitTut
//

//  Copyright (c) 2014 15and50. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#import "BMGlyphFont.h"
#import "BMGlyphLabel.h"

@interface MyScene : SKScene <SKPhysicsContactDelegate> {
    
    SKSpriteNode *player;
    SKSpriteNode *rockSprite;
    SKSpriteNode *timesTwoSprite;
    
    BMGlyphLabel *scoreLabel;
    BMGlyphLabel *GameOverLabel;
    BMGlyphLabel *YourScoreWasLabel;
    BMGlyphLabel *YourHighScoreWasLabel;
    BMGlyphLabel *tapToPlayFirstLabel;
    BMGlyphLabel *tapToPlayLabel;
    BMGlyphLabel *newHighScore;
    
    SKSpriteNode *gameOverBoard;
    SKSpriteNode *lifeONE;
    SKSpriteNode *lifeTWO;
    SKSpriteNode *lifeTHREE;
    SKSpriteNode *lifeEXTRA;
    
    NSInteger score;
    NSInteger highscore;
    
    int moveToX;
    int fuel;
    int maxFuel;
    int halfFuel;
    int almostDoneFuel;
    int lives;

    BOOL gameOver;
    BOOL playing;
    BOOL done;
    BOOL unlockedTwo;
    BOOL hit;
    
}

typedef enum : uint8_t {
    JCColliderTypeRectangle = 1,
    JCColliderTypeObstacle  = 2
} JCColliderType;

@end





