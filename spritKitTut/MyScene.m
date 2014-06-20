//
//  MyScene.m
//  spritKitTut
//
//  Created by Ricky Brown on 6/2/14.
//  Copyright (c) 2014 15and50. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size
{
    
    if (self = [super initWithSize:size])
    {
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor whiteColor];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, self.size.width, self.size.height)];
        self.physicsWorld.contactDelegate = self;
        [self performSelector:@selector(addTopEnemy) withObject:self afterDelay:3.0];
        [self performSelector:@selector(addMidEnemy) withObject:self afterDelay:6.0];
        [self performSelector:@selector(addBottomEnemy) withObject:self afterDelay:9.0];
        [self addLevels];
        
        /* Make Rectangle */
        player = [SKShapeNode node];
        player.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-5, -2, 10, 10)].CGPath;
        player.fillColor = [UIColor redColor];
        player.strokeColor = [UIColor redColor];
        player.glowWidth = 0.5;
        player.position = CGPointMake(50, 260);
        [self addChild:player];
        
        /* Set Varables */
        moveToX = -15;
        delay = (arc4random()%(5-2))+2;
        
        /* Make Score Label */
        score = 0;
        scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"times"];
        scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        scoreLabel.fontSize = 17;
        scoreLabel.fontColor = [SKColor blackColor];
        scoreLabel.position = CGPointMake(305, 143);
        [self addChild:scoreLabel];
        
    }
    
    return self;

}

-(void) didMoveToView:(SKView *) view
{
 
    swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(jump)];
    [swipeUp setDirection: UISwipeGestureRecognizerDirectionUp];
    
    [view addGestureRecognizer:swipeUp];
    
    swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(down)];
    [swipeDown setDirection: UISwipeGestureRecognizerDirectionDown];
    
    [view addGestureRecognizer:swipeDown];
    
}

#pragma mark Make Enemy

-(void) addTopEnemy
{
    
    SKShapeNode *topEnemy = [SKShapeNode node];
    topEnemy.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-10, -10, 25, 25)].CGPath;
    topEnemy.fillColor = [UIColor blackColor];
    topEnemy.strokeColor = [UIColor blackColor];
    topEnemy.glowWidth = 0.5;
    topEnemy.position = CGPointMake(340, 320);
    [self addChild:topEnemy];
    
    /* Run It Through */
    SKAction *moveObstacle = [SKAction moveToX:moveToX duration:2.0];
    [topEnemy runAction:moveObstacle];
    
    [topEnemy runAction:moveObstacle completion:^(void){
        [self blockEnded:topEnemy];
        delay = (arc4random()%(5-2))+2;
        [self performSelector:@selector(addTopEnemy) withObject:self afterDelay:delay];
    }];
    
}

-(void) addMidEnemy
{
    
    SKShapeNode *midEnemy = [SKShapeNode node];
    midEnemy.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-10, -10, 25, 25)].CGPath;
    midEnemy.fillColor = [UIColor blackColor];
    midEnemy.strokeColor = [UIColor blackColor];
    midEnemy.glowWidth = 0.5;
    midEnemy.position = CGPointMake(340, 260);
    [self addChild:midEnemy];
    
    SKAction *moveObstacle = [SKAction moveToX:moveToX duration:2.0];
    
    [midEnemy runAction:moveObstacle];
    
    [midEnemy runAction:moveObstacle completion:^(void){
        [self blockEnded:midEnemy];
        delay = (arc4random()%(5-2))+2;
        [self performSelector:@selector(addMidEnemy) withObject:self afterDelay:delay];
    }];
    
}

-(void) addBottomEnemy
{
    
    SKShapeNode *bottomEnemy = [SKShapeNode node];
    bottomEnemy.path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(-10, -10, 25, 25)].CGPath;
    bottomEnemy.fillColor = [UIColor blackColor];
    bottomEnemy.strokeColor = [UIColor blackColor];
    bottomEnemy.glowWidth = 0.5;
    bottomEnemy.position = CGPointMake(340, 200);
    [self addChild:bottomEnemy];
    
    SKAction *moveObstacle = [SKAction moveToX:moveToX duration:2.0];
    
    [bottomEnemy runAction:moveObstacle];
    
    [bottomEnemy runAction:moveObstacle completion:^(void){
        [self blockEnded:bottomEnemy];
        delay = (arc4random()%(5-2))+2;
        [self performSelector:@selector(addBottomEnemy) withObject:self afterDelay:delay];
    }];
    
}

#pragma mark Make Levels

-(void) addLevels
{
    
    /* Make levels (1) */
    SKShapeNode *topLevelX = [SKShapeNode node];
    topLevelX.path = [UIBezierPath bezierPathWithRect:CGRectMake(-37, 0, 75, 8)].CGPath;
    topLevelX.fillColor = [UIColor blackColor];
    topLevelX.position = CGPointMake(50, 290);
    topLevelX.glowWidth = 1;
    [self addChild:topLevelX];
    
    /* Make levels (2) */
    SKShapeNode *midLevel = [SKShapeNode node];
    midLevel.path = [UIBezierPath bezierPathWithRect:CGRectMake(-37, 0, 75, 8)].CGPath;
    midLevel.fillColor = [UIColor blackColor];
    midLevel.position = CGPointMake(50, 230);
    midLevel.glowWidth = 1;
    [self addChild:midLevel];
    
    /* Make levels (3) */
    SKShapeNode *bottomLevel = [SKShapeNode node];
    bottomLevel.path = [UIBezierPath bezierPathWithRect:CGRectMake(-37, 0, 75, 8)].CGPath;
    bottomLevel.fillColor = [UIColor blackColor];
    bottomLevel.position = CGPointMake(50, 170);
    bottomLevel.glowWidth = 1;
    [self addChild:bottomLevel];
    
}

#pragma mark Movement

-(void) jump
{
    
    if (player.frame.origin.y < 320 && player.frame.origin.y >= 200)
    {
        
        SKAction *moveObstacle = [SKAction moveToY:320 duration:0.3];
        
        [player runAction:moveObstacle];
        
    }
    else if (player.frame.origin.y < 260)
    {
        
        SKAction *moveObstacle = [SKAction moveToY:260 duration:0.3];
        
        [player runAction:moveObstacle];
        
    }
    
}

-(void) down
{

    if (player.frame.origin.y > 260)
    {
    
        SKAction *moveObstacle = [SKAction moveToY:260 duration:0.3];

        [player runAction:moveObstacle];
        
    }
    else
    {
        
        SKAction *moveObstacle = [SKAction moveToY:200 duration:0.3];
        
        [player runAction:moveObstacle];
        
    }
    
}

#pragma mark Count Score

-(void) blockEnded:(SKShapeNode *)enemy
{
    
    [enemy removeFromParent];
    score++;
    scoreLabel.text = [NSString stringWithFormat:@"%i", score];
    
}

@end








