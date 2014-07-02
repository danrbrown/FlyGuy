//
//  MyScene.m
//  spritKitTut
//
//  Created by Ricky Brown on 6/2/14.
//  Copyright (c) 2014 15and50. All rights reserved.
//

#import "MyScene.h"

static const uint32_t fuelCategory       =  0x1 << 2;
static const uint32_t rockCategory       =  0x1 << 1;
static const uint32_t playerCategory     =  0x1 << 0;

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size])
    {
        
        /* Setup scene */
        self.backgroundColor = [SKColor colorWithRed: 100.0/255.0 green: 200.0/255.0 blue:255.0/255.0 alpha: 1.0];
        
        /* Collision */
        self.physicsWorld.contactDelegate = self;
        
        /* Set Varables */
        moveToX = -30;
        maxFuel = 40;
        x = self.size.width/2/2/2-15;
        fuel = maxFuel;
        halfFuel = maxFuel/2;
        almostDoneFuel = maxFuel/2/2;
        done = YES;
        gameOver = YES;
        unlockedTwo = NO;
        hit = NO;
        
        /* Exacute */
        [self makeGameLabels];
        [self makePlayer];

    }
    
    return self;

}

#pragma mark Send them coins in

-(void) addSpritesIn {
    
    
    int randomSprite = arc4random() % 6;
    int randomSpeed = (arc4random()%(4-2))+2;
    
    [self sendInRockOrFuel:randomSprite atSpeed:randomSpeed];
    
    rockSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rockSprite.size];
    rockSprite.physicsBody.dynamic = YES;
    rockSprite.physicsBody.affectedByGravity = NO;
    rockSprite.physicsBody.categoryBitMask = rockCategory;
    rockSprite.physicsBody.contactTestBitMask = playerCategory;
    rockSprite.physicsBody.collisionBitMask = 0;
    rockSprite.physicsBody.usesPreciseCollisionDetection = YES;
    
    fuelSrite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:fuelSrite.size];
    fuelSrite.physicsBody.dynamic = YES;
    fuelSrite.physicsBody.affectedByGravity = NO;
    fuelSrite.physicsBody.categoryBitMask = fuelCategory;
    fuelSrite.physicsBody.contactTestBitMask = playerCategory;
    fuelSrite.physicsBody.collisionBitMask = 0;
    fuelSrite.physicsBody.usesPreciseCollisionDetection = YES;
    
}

-(void) sendInRockOrFuel:(int)either atSpeed:(int)speed {
    
    SKAction *moveObstacle;
    int randomPosition = (arc4random()%(340-210)) + 210;
    
    if (either == 1 || either == 2 || either == 3)
    {
        
        moveObstacle = [SKAction moveToX:moveToX duration:speed];
        rockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"RockSprite"];
        rockSprite.size = CGSizeMake(25, 15);
        rockSprite.position = CGPointMake(340, randomPosition);
        
        [self addChild:rockSprite];
        
        [rockSprite runAction:moveObstacle withKey:@"moveing"];
        
    }
    else if (either == 5 || either == 4)
    {
        
        moveObstacle = [SKAction moveToX:moveToX duration:speed];
        fuelSrite = [SKSpriteNode spriteNodeWithImageNamed:@"FuelSprite"];
        fuelSrite.size = CGSizeMake(20, 20);
        fuelSrite.position = CGPointMake(340, randomPosition);
        
        [self addChild:fuelSrite];
        
        [fuelSrite runAction:moveObstacle withKey:@"moveing"];
        
    }
    
    [rockSprite runAction:moveObstacle completion:^(void){
       
        score++;
        scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        
    }];
    
    if (!gameOver && !hit)
    {
        
        [self performSelector:@selector(addSpritesIn) withObject:self afterDelay:0.8];
    
    }
    
}

#pragma mark Play, play again

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!playing && done)
    {
        
        fuel = maxFuel;
        score = 0;
        scoreLabel.text = [NSString stringWithFormat:@"%i", score];
        playing = YES;
        gameOver = NO;
        hit = NO;
        unlockedTwo = NO;
        player.physicsBody.affectedByGravity = YES;
        player.physicsBody.dynamic = YES;
        
        [fuelLevel setTexture:[SKTexture textureWithImageNamed:@"FuelFullSprite"]];
        x = self.size.width/2/2/2-15;
        
        [GameOverLabel removeFromParent];
        [YourScoreWasLabel removeFromParent];
        [tapToPlayLabel removeFromParent];
        [YourHighScoreWasLabel removeFromParent];
        [tapToPlayFirstLabel removeFromParent];
        [player removeAllActions];
        
        [self addChild:scoreLabel];
        [self performSelector:@selector(addSpritesIn) withObject:self afterDelay:1];
        
    }
    else if (playing && !hit && fuel >= 5)
    {
        
        [player.physicsBody applyImpulse:CGVectorMake(0.0f, 15.0f)];
        fuel--;
        fuelLevel.size = CGSizeMake(fuel-4, 6);
        fuelLevel.position = CGPointMake(x = x - 0.5, self.size.height/2-80);
        
        [player setTexture:[SKTexture textureWithImageNamed:@"jetPackGuyFly"]];
        
        if (fuel <= halfFuel && fuel > almostDoneFuel)
        {
            
            [fuelLevel setTexture:[SKTexture textureWithImageNamed:@"FuelMidSprite"]];
            
        }
        else if (fuel <= almostDoneFuel)
        {
            
            [fuelLevel setTexture:[SKTexture textureWithImageNamed:@"FuelEmptySprite"]];
            
        }
        
        if (fuel <= 5)
        {
            
            gameOver = YES;
            
        }
        
    }
    else if (gameOver)
    {
        
        [self gameOver];
        
    }
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [player setTexture:[SKTexture textureWithImageNamed:@"jetPackGuy"]];
    
}

#pragma mark Game over

-(void) gameOver {
    
    YourScoreWasLabel.text = [NSString stringWithFormat:@"Score: %i", score];
    
    if (score > highscore)
    {
        
        YourHighScoreWasLabel.text = [NSString stringWithFormat:@"Best: %i", score];
        
    }
    
    [scoreLabel removeFromParent];
    [fuelSrite removeFromParent];
    [rockSprite removeFromParent];
    
    [self addChild:GameOverLabel];
    [self addChild:YourScoreWasLabel];
    [self addChild:tapToPlayLabel];
    [self addChild:YourHighScoreWasLabel];
    
    gameOver = NO;
    playing = NO;
    done = NO;
    
    [self performSelector:@selector(setPlayer) withObject:self afterDelay:1];
    
}

-(void) setPlayer {
    
    player.physicsBody.affectedByGravity = NO;
    player.physicsBody.dynamic = NO;
    SKAction *moveEm = [SKAction moveToY:self.size.height/2 duration:1];
    [player runAction:moveEm];
    
    [player runAction:moveEm completion:^(void){
        
        done = YES;
        gameOver = NO;
        playing = NO;
        
    }];
    
}

#pragma mark Collision

-(void) didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *firstBody, *secondBody, *thirdBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
        thirdBody = contact.bodyB;
        
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
        thirdBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & rockCategory) != 0)
    {
        [self collision:(SKSpriteNode *) firstBody.node didCollideWithRock:(SKSpriteNode *) secondBody.node];
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (thirdBody.categoryBitMask & fuelCategory) != 0)
    {
        [self collision:(SKSpriteNode *) firstBody.node didCollideWithFuel:(SKSpriteNode *) secondBody.node];
    }
    
}

#pragma mark Collision between player and rock

-(void) collision:(SKSpriteNode *)player didCollideWithRock:(SKSpriteNode *)rock {
    
    if (!hit)
    {
        
        hit = YES;
        self.paused = YES;
        [self performSelector:@selector(hit) withObject:self afterDelay:1];
        
    }
    
}

-(void) hit
{
    
    self.paused = NO;
    gameOver = NO;
    [self gameOver];
    
}

#pragma mark Collision bteween player and fuel

-(void) collision:(SKSpriteNode *)player didCollideWithFuel:(SKSpriteNode *)fuelBox {

    if (fuel < maxFuel - 7)
    {

        fuel = fuel + 7;
        fuelLevel.size = CGSizeMake(fuel-4, 6);
        fuelLevel.position = CGPointMake(x = x + 3.5, self.size.height/2-80);
    
    }
    else
    {
        
        fuel = fuel + 2;
        fuelLevel.size = CGSizeMake(fuel-4, 6);
        fuelLevel.position = CGPointMake(x = x + 1, self.size.height/2-80);
        
    }
    
}

#pragma mark Labels

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
    tapToPlayLabel = [SKSpriteNode spriteNodeWithImageNamed:@"TapToPlaySprite"];
    tapToPlayLabel.position = CGPointMake(self.size.width/2, self.size.height/2-70);
    tapToPlayLabel.size = CGSizeMake(100, 15);
    
    /* Make Tap Play First Label and Animation */
    tapToPlayFirstLabel = [SKSpriteNode spriteNodeWithImageNamed:@"TapToPlaySprite"];
    tapToPlayFirstLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
    tapToPlayFirstLabel.size = CGSizeMake(120, 20);
    [self addChild:tapToPlayFirstLabel];
    
    /* Make Fuel Tank */
    fuelTank = [SKSpriteNode spriteNodeWithImageNamed:@"FuelTankSprite"];
    fuelTank.position = CGPointMake(self.size.width/2/2/2-15, self.size.height/2-80);
    fuelTank.size = CGSizeMake(40, 10);
    [self addChild:fuelTank];
    
    fuelLevel = [SKSpriteNode spriteNodeWithImageNamed:@"FuelFullSprite"];
    fuelLevel.position = CGPointMake(self.size.width/2/2/2-15, self.size.height/2-80);
    fuelLevel.size = CGSizeMake(fuel-4, 6);
    [self addChild:fuelLevel];
    
}

#pragma mark Make player

-(void) makePlayer {
    
    player = [SKSpriteNode spriteNodeWithImageNamed:@"jetPackGuy"];
    player.position = CGPointMake(40, self.size.height/2);

    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.affectedByGravity = NO;
    player.physicsBody.dynamic = YES;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.contactTestBitMask = rockCategory;
    player.physicsBody.collisionBitMask = 0;
    
    [self addChild:player];
    
    float y = player.position.y;
    SKAction *a = [SKAction moveToY:(y+5) duration:0.5];
    SKAction *b = [SKAction moveToY:y duration:0.5];
    SKAction *sequence = [SKAction sequence:@[a,b]];
    [player runAction:[SKAction repeatActionForever:sequence] withKey:@"flouting"];
    
}

#pragma mark Moving backround

-(void) moveBackground {
    
    
    
}

#pragma mark Other

-(void) didMoveToView:(SKView *)view {
    
}
 
-(void) update:(NSTimeInterval)currentTime {
    
    
}

@end








