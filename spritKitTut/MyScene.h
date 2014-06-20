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
    SKShapeNode *player;
    SKLabelNode *scoreLabel;
    
    int moveToX;
    int delay;
    int score;
    
}

@end