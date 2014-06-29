//
//  MyScene.m
//  spritKitTut
//
//  Created by Ricky Brown on 6/2/14.
//  Copyright (c) 2014 15and50. All rights reserved.
//

#import "MyScene.h"

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size])
    {
        
        /* Setup your scene here */
        self.backgroundColor = [SKColor colorWithRed: 100.0/255.0 green: 200.0/255.0 blue:255.0/255.0 alpha: 1.0];
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame];
        self.physicsWorld.contactDelegate = self;
        
        /* Set Varables */
        moveToX = -30;
        gameOver = YES;
        maxFuel = 40;
        fuel = maxFuel;
        done = YES;
        unlockedTwo = NO;
        
        /* Exacute */
        [self moveBackground];
        [self makeGameLabels];
        [self makePlayer];

    }
    
    return self;

}

#pragma mark Send Them Coins In

-(void) addSpritesIn {
    
    if (score > 50)
    {
        unlockedTwo = YES;
    }
    
    int randomSprite = arc4random() % 6;
    int randomSpeed = (arc4random()%(4-2))+2;
    
    [self sendInRockOrFuel:randomSprite atSpeed:randomSpeed];
    
}

-(void) sendInRockOrFuel:(int)either atSpeed:(int)speed {
    
    SKAction *moveObstacle;
    int randomPosition = (arc4random()%(340-210)) + 210;
    
    if (either == 1 || either == 2 || either == 3 || either == 4)
    {
        
        moveObstacle = [SKAction moveToX:moveToX duration:speed];
        rockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"RockSprite"];
        rockSprite.size = CGSizeMake(25, 15);
        rockSprite.position = CGPointMake(340, randomPosition);
        
        [self addChild:rockSprite];
        
        [rockSprite runAction:moveObstacle withKey:@"moveing"];
        
    }
    else if (either == 5)
    {
        
        moveObstacle = [SKAction moveToX:moveToX duration:speed];
        fuelSrite = [SKSpriteNode spriteNodeWithImageNamed:@"FuelSprite"];
        fuelSrite.size = CGSizeMake(20, 20);
        fuelSrite.position = CGPointMake(340, randomPosition);
        
        [self addChild:fuelSrite];
        
        [fuelSrite runAction:moveObstacle withKey:@"moveing"];
        
    }
    else if (either == 6 && unlockedTwo)
    {
        
        moveObstacle = [SKAction moveToX:moveToX duration:speed];
        timesTwoSprite = [SKSpriteNode spriteNodeWithImageNamed:@"timesTwoSprite"];
        timesTwoSprite.size = CGSizeMake(25, 20);
        timesTwoSprite.position = CGPointMake(340, randomPosition);
        
        [self addChild:timesTwoSprite];
        
        [timesTwoSprite runAction:moveObstacle withKey:@"moveing"];
        
    }
    
    [rockSprite runAction:moveObstacle completion:^(void){
       
        score++;
        scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        
    }];
    
    if (!gameOver)
    {
        
        [self performSelector:@selector(addSpritesIn) withObject:self afterDelay:1.5];
    
    }
    
}

#pragma mark Play Again

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!playing && done)
    {
        
        fuel = maxFuel;
        score = 0;
        scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        playing = YES;
        gameOver = NO;
        unlockedTwo = NO;
        player.physicsBody.affectedByGravity = YES;
        
        [GameOverLabel removeFromParent];
        [YourScoreWasLabel removeFromParent];
        [tapToPlayLabel removeFromParent];
        [YourHighScoreWasLabel removeFromParent];
        [tapToPlayFirstLabel removeFromParent];
        [player removeAllActions];
        
        [self addChild:scoreLabel];
        [self performSelector:@selector(addSpritesIn) withObject:self afterDelay:2];
        
    }
    else if (playing && fuel > 0)
    {
        
        [player.physicsBody applyImpulse:CGVectorMake(0.0f, 15.0f)];
        fuel--;
        
        if (fuel <= 0)
        {
            
            gameOver = YES;
            
        }
        
    }
    else if (gameOver && playing)
    {
        
        [self gameOver];
        
    }
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    
    
}

#pragma mark Game Over

-(void) gameOver {
    
    YourScoreWasLabel.text = [NSString stringWithFormat:@"Score: %i", score];
    
    if (score > highscore)
    {
        
        YourHighScoreWasLabel.text = [NSString stringWithFormat:@"Best: %i", score];
        
    }
    
    [self addChild:GameOverLabel];
    [self addChild:YourScoreWasLabel];
    [self addChild:tapToPlayLabel];
    [self addChild:YourHighScoreWasLabel];
    
    [scoreLabel removeFromParent];
    [fuelSrite removeFromParent];
    [rockSprite removeFromParent];
    
    playing = NO;
    done = NO;
    
    [self performSelector:@selector(setPlayer) withObject:self afterDelay:1];
    
}

#pragma mark Contact

-(void) didBeginContact:(SKPhysicsContact *)contact {
    
    
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
    YourHighScoreWasLabel.text = [NSString stringWithFormat:@"Best: %i", score];
    YourHighScoreWasLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
    YourHighScoreWasLabel.fontColor = [SKColor redColor];
    YourHighScoreWasLabel.fontSize = 13;
    
    /* Make Tap Play Again Label */
    tapToPlayLabel = [SKLabelNode labelNodeWithFontNamed:@"Helvetica"];
    tapToPlayLabel.text = @"Tap to play again!";
    tapToPlayLabel.position = CGPointMake(self.size.width/2, self.size.height/2-70);
    tapToPlayLabel.fontColor = [SKColor purpleColor];
    tapToPlayLabel.fontSize = 10;
    
    /* Make Tap Play First Label and Animation */
    tapToPlayFirstLabel = [SKSpriteNode spriteNodeWithImageNamed:@"TapToPlaySprite"];
    tapToPlayFirstLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
    tapToPlayFirstLabel.size = CGSizeMake(120, 20);
    [self addChild:tapToPlayFirstLabel];

    float y = tapToPlayLabel.position.y;
    SKAction *aa = [SKAction moveToY:(y+5) duration:0.5];
    SKAction *bb = [SKAction moveToY:y duration:0.5];
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
    [player runAction:[SKAction repeatActionForever:sequence] withKey:@"flouting"];
    
}

#pragma mark Moving Backround

-(void) moveBackground {
    
    SKSpriteNode *backround = [SKSpriteNode spriteNodeWithImageNamed:@"clouds"];
    backround.position = CGPointMake(340, self.size.height/2);
    backround.size = CGSizeMake(1000, 180);
    [self addChild:backround];
    
    SKAction *moveIt = [SKAction moveToX:-1000 duration:10];
    [backround runAction:moveIt];
    
}

#pragma mark other

-(void) setPlayer {
    
    player.physicsBody.affectedByGravity = NO;
    SKAction *moveEm = [SKAction moveToY:self.size.height/2 duration:1];
    [player runAction:moveEm];
    
    [player runAction:moveEm completion:^(void){
        
        done = YES;
        gameOver = NO;
        playing = NO;
        
    }];
    
}

-(void) didMoveToView:(SKView *)view {
    
}
 
-(void)update:(NSTimeInterval)currentTime {
    
    
}

@end








