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
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate = self;
        
        SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"clouds"];
        background.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:background];
        
        /* Set Varables */
        moveToX = -30;
        gameOver = YES;
        
        /* Exacute */
        [self makeGameLabels];
        [self makePlayer];

    }
    
    return self;

}

#pragma mark Send Them Coins In

-(void) addCoinsIn
{
    
    int randomSprite = arc4random() % 3;
    int randomSpeed = (arc4random()%(4-2))+2;
    
    [self sendInRockOrFuel:randomSprite atSpeed:randomSpeed];
    
}

-(void) sendInRockOrFuel:(int)either atSpeed:(int)speed
{
    
    if (either == 1 || either == 2)
    {
        
        fuelOrRock = [SKSpriteNode spriteNodeWithImageNamed:@"RockSprite"];
        
    }
    else
    {
        
        fuelOrRock = [SKSpriteNode spriteNodeWithImageNamed:@"FuelSprite"];
        
    }
    
    int randomPosition = (arc4random()%(340-210)) + 210;
    fuelOrRock.position = CGPointMake(340, randomPosition);
    [self addChild:fuelOrRock];
    
    SKAction *moveObstacle = [SKAction moveToX:moveToX duration:speed];
    [fuelOrRock runAction:moveObstacle];
    
    [self performSelector:@selector(addCoinsIn) withObject:self afterDelay:1.5];
    
#pragma mark Game over code
    /*
        
    gameOver = YES;
    
    [self addChild:GameOverLabel];
    [self addChild:YourScoreWasLabel];
    [self addChild:tapToPlayLabel];
    [self addChild:YourHighScoreWasLabel];
                                                 
    [scoreLabel removeFromParent];
    
    player.physicsBody.affectedByGravity = YES;
    
    [self performSelector:@selector(removeFromParent) withObject:self afterDelay:1];
        
     */
    
}

#pragma mark Play Again

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
#pragma mark When you want to play again code
    /*
    [GameOverLabel removeFromParent];
    [YourScoreWasLabel removeFromParent];
    [tapToPlayLabel removeFromParent];
    [YourHighScoreWasLabel removeFromParent];
    */
    
    if (!playing)
    {
        
        playing = YES;
        
        [tapToPlayFirstLabel removeFromParent];
        
        [self addChild:scoreLabel];
        
        [self startPlayerPosition];
        
        [self performSelector:@selector(addCoinsIn) withObject:self afterDelay:2];
        
    }
    
}

-(void) startPlayerPosition {
    
    player.physicsBody.affectedByGravity = NO;
    
    SKAction *moveObstacleY = [SKAction moveToY:self.size.height/2 duration:1];
    SKAction *moveObstacleX = [SKAction moveToX:40 duration:1];
    
    [player runAction:moveObstacleY];
    [player runAction:moveObstacleX];
    
}

#pragma mark Contact

-(void)didBeginContact:(SKPhysicsContact *)contact {
    
    
    
}

#pragma mark Labels and Players

-(void) makeGameLabels {
    
    /* Make Score Label */
    score = 0;
    scoreLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    scoreLabel.text = [NSString stringWithFormat:@"%i", score];
    scoreLabel.fontSize = 17;
    scoreLabel.fontColor = [SKColor blackColor];
    scoreLabel.position = CGPointMake(self.size.width/2*2-10, self.size.height/2-83);
    
    /* Make Game Over Label */
    GameOverLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    GameOverLabel.text = @"Game Over!";
    GameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2+40);
    GameOverLabel.fontColor = [SKColor blueColor];
    GameOverLabel.fontSize = 20;
    
    /* Make After Score Label */
    YourScoreWasLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    YourScoreWasLabel.text = [NSString stringWithFormat:@"Score: %i", score];
    YourScoreWasLabel.position = CGPointMake(self.size.width/2, self.size.height/2+20);
    YourScoreWasLabel.fontColor = [SKColor redColor];
    YourScoreWasLabel.fontSize = 13;
    
    /* Make After Highscore Label */
    YourHighScoreWasLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    YourHighScoreWasLabel.text = [NSString stringWithFormat:@"Highscore: %i", score];
    YourHighScoreWasLabel.position = CGPointMake(self.size.width/2-12, self.size.height/2);
    YourHighScoreWasLabel.fontColor = [SKColor redColor];
    YourHighScoreWasLabel.fontSize = 13;
    
    /* Make Tap Play Again Label */
    tapToPlayLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tapToPlayLabel.text = @"Tap to play again!";
    tapToPlayLabel.position = CGPointMake(self.size.width/2, self.size.height/2-70);
    tapToPlayLabel.fontColor = [SKColor purpleColor];
    tapToPlayLabel.fontSize = 10;
    
    /* Make Tap Play First Label and Animation */
    tapToPlayFirstLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tapToPlayFirstLabel.text = @"Tap to play again!";
    tapToPlayFirstLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
    tapToPlayFirstLabel.fontColor = [SKColor blueColor];
    tapToPlayFirstLabel.fontSize = 17;
    [self addChild:tapToPlayFirstLabel];

    float x = tapToPlayLabel.position.y;
    
    SKAction *aa = [SKAction moveToY:(x+5) duration:0.5];
    SKAction *bb = [SKAction moveToY:x duration:0.5];
    SKAction *sequence2 = [SKAction sequence:@[aa,bb]];

    [tapToPlayLabel runAction:[SKAction repeatActionForever:sequence2]];
    
}

-(void) makePlayer {
    
    /* Make Player (for now) */
    player = [SKSpriteNode spriteNodeWithImageNamed:@"jetPackGuyFly"];
    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.affectedByGravity = NO;
    player.position = CGPointMake(40, self.size.height/2);
    [self addChild:player];
    
    float y = player.position.y;
    SKAction *a = [SKAction moveToY:(y+5) duration:0.5];
    SKAction *b = [SKAction moveToY:y duration:0.5];
    SKAction *sequence = [SKAction sequence:@[a,b]];
    [player runAction:[SKAction repeatActionForever:sequence]];
    
}

#pragma mark Moving Backround

#pragma mark other

-(void) removePlayer {
    
    [player removeFromParent];
    
}

-(void) didMoveToView:(SKView *)view {
    
}

@end








