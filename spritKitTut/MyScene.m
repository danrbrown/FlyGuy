//
//  MyScene.m
//  spritKitTut
//
//  Created by Ricky Brown on 6/2/14.
//  Copyright (c) 2014 15and50. All rights reserved.
//

#import "MyScene.h"

#import "BMGlyphFont.h"
#import "BMGlyphLabel.h"

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
        self.physicsWorld.gravity = CGVectorMake(0,-5);
        
        /* Set Varables */
        moveToX = -30;
        maxFuel = 40;
        lives = 3;
        fuel = maxFuel;
        halfFuel = maxFuel/2;
        almostDoneFuel = maxFuel/2/2;
        done = YES;
        gameOver = YES;
        unlockedTwo = NO;
        hit = NO;
        
        NSInteger theHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
        highscore = theHighScore;
  
        /* Exacute */
        //[self moveBackground];
        [self makeGameLabels];
        [self makePlayer];

    }
    
    return self;

}

#pragma mark Send them coins in

-(void) addSpritesIn {
    
    int randomSprite = arc4random() % 6;
    int randomSpeed = (arc4random()%(5-2))+2;
    float waitTime = 0.8;
    
    [self sendInRockOrFuel:randomSprite atSpeed:randomSpeed waitTime:waitTime];
    
    rockSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rockSprite.size];
    rockSprite.physicsBody.dynamic = YES;
    rockSprite.physicsBody.affectedByGravity = NO;
    rockSprite.physicsBody.categoryBitMask = rockCategory;
    rockSprite.physicsBody.contactTestBitMask = playerCategory;
    rockSprite.physicsBody.collisionBitMask = 0;
    rockSprite.physicsBody.usesPreciseCollisionDetection = YES;
    
}

-(void) sendInRockOrFuel:(int)either atSpeed:(int)speed waitTime:(float)wait {
    
    SKAction *moveObstacle = [SKAction moveToX:moveToX duration:speed];
    int randomPosition = (arc4random()%(340-210)) + 210;
    rockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"RockSprite"];
    
    if (either == 1 || either == 2 || either == 3)
    {
        
        rockSprite.size = CGSizeMake(25, 15);
        rockSprite.position = CGPointMake(340, randomPosition);
        [self addChild:rockSprite];
        [rockSprite runAction:moveObstacle withKey:@"moveing"];
        
    }
    else if (either == 4 || either == 5)
    {
        
        rockSprite.size = CGSizeMake(35, 22);
        rockSprite.position = CGPointMake(340, randomPosition);
        [self addChild:rockSprite];
        [rockSprite runAction:moveObstacle withKey:@"moveing"];

    }
    
    [rockSprite runAction:moveObstacle completion:^(void){
       
        score++;
        scoreLabel.text = [NSString stringWithFormat:@"%li", score];
        
    }];
    
    if (!gameOver && !hit)
    {
        
        [self performSelector:@selector(addSpritesIn) withObject:self afterDelay:wait];
    
    }
    
}

#pragma mark Play, play again

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    if (!playing && done)
    {
        
        fuel = maxFuel;
        score = 0;
        lives = 3;
        scoreLabel.text = [NSString stringWithFormat:@"%li", score];
        playing = YES;
        gameOver = NO;
        hit = NO;
        unlockedTwo = NO;
        player.physicsBody.affectedByGravity = YES;
        player.physicsBody.dynamic = YES;
        
        [GameOverLabel removeFromParent];
        [YourScoreWasLabel removeFromParent];
        [tapToPlayLabel removeFromParent];
        [YourHighScoreWasLabel removeFromParent];
        [gameOverBoard removeFromParent];
        [tapToPlayFirstLabel removeFromParent];
        [player removeAllActions];
        
        [self addChild:lifeONE];
        [self addChild:lifeTWO];
        [self addChild:lifeTHREE];
        [self addChild:scoreLabel];
        [self performSelector:@selector(addSpritesIn) withObject:self afterDelay:1];
        
    }
    else if (playing && !hit)
    {
        
        [player.physicsBody applyImpulse:CGVectorMake(0.0f, 10.0f)];
        
        [player setTexture:[SKTexture textureWithImageNamed:@"jetPackGuyFly"]];
        
    }
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [player setTexture:[SKTexture textureWithImageNamed:@"jetPackGuy"]];
    
}

#pragma mark Game over

-(void) gameOver {

    YourScoreWasLabel.text = [NSString stringWithFormat:@"SCORE: %li", score];
    
    NSInteger theHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
    highscore = theHighScore;
    
    if (score > theHighScore)
    {
        
        highscore = score;
        YourHighScoreWasLabel.text = [NSString stringWithFormat:@"BEST: %li", highscore];
        [[NSUserDefaults standardUserDefaults] setInteger:highscore forKey:@"HighScore"];
        
    }
    
    [scoreLabel removeFromParent];
    [rockSprite removeFromParent];
    
    [self addChild:gameOverBoard];
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
        
        SKAction *rotation = [SKAction rotateByAngle: M_PI/-4.0 duration:0.7];
        SKAction *moveFix = [SKAction moveToX:player.position.x+10 duration:0.7];
        SKAction *playerWasFixed = [SKAction sequence:@[rotation, moveFix]];
        [player runAction:playerWasFixed];
        
        [player runAction:playerWasFixed completion:^(void){
            
            done = YES;
            gameOver = NO;
            playing = NO;
            
            float y = player.position.y;
            SKAction *a = [SKAction moveToY:(y+5) duration:0.5];
            SKAction *b = [SKAction moveToY:y duration:0.5];
            SKAction *sequence = [SKAction sequence:@[a,b]];
            [player runAction:[SKAction repeatActionForever:sequence] withKey:@"flouting"];
            
        }];
        
        
        
    }];
    
}

#pragma mark Collision

-(void) didBeginContact:(SKPhysicsContact *)contact {
    
    SKPhysicsBody *firstBody, *secondBody;
    
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (secondBody.categoryBitMask & rockCategory) != 0)
    {
        [self collision:(SKSpriteNode *) firstBody.node didCollideWithRock:(SKSpriteNode *) secondBody.node];
    }
    
}

#pragma mark Collision between player and rock

-(void) collision:(SKSpriteNode *)playerS didCollideWithRock:(SKSpriteNode *)rockS {
    
    player.alpha = 0.0;
    
    SKAction *blinkSequence = [SKAction sequence:@[[SKAction fadeAlphaTo:1.0 duration:0],
                                                   [SKAction fadeAlphaTo:0.0 duration:0],
                                                   [SKAction fadeAlphaTo:1.0 duration:0]]];
    
    if (lives == 3)
    {
        [lifeTHREE removeFromParent];
    }
    if (lives == 2)
    {
        [lifeTWO removeFromParent];
    }
    if (lives == 1)
    {
        [lifeONE removeFromParent];
    }

    [player runAction:[SKAction repeatAction:blinkSequence count:5] completion:^{}];
    
    lives--;

    if (!hit && lives < 1)
    {
        
        hit = YES;
        
        SKAction *rotation = [SKAction rotateByAngle: M_PI/2.0 duration:0.4];
        SKAction *moveByHit = [SKAction moveToX:player.position.x-10 duration:0.4];
        SKAction *playerWasHit = [SKAction sequence:@[rotation, moveByHit]];
        [player runAction:playerWasHit];
        
        [self performSelector:@selector(yourDone) withObject:self afterDelay:0.2];
        
    }
    
}

-(void) yourDone
{
    
    gameOver = NO;
    [self gameOver];
    
}

#pragma mark Labels

-(void) makeGameLabels {
    
    BMGlyphFont *font2 = [BMGlyphFont fontWithName:@"FontForFlyGuy2"];
    
    /* Make Score Label */
    score = 0;
    scoreLabel = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"%li", score] font:font2];
    scoreLabel.position = CGPointMake(self.size.width/2-157, self.size.height/2-77);
    scoreLabel.horizontalAlignment = BMGlyphHorizontalAlignmentLeft;
    
    /* Make Game Over Label */
    GameOverLabel = [BMGlyphLabel labelWithText:@"GAME OVER!" font:font2];
    GameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2+43);
    
    /* Make After Score Label */
    YourScoreWasLabel = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"SCORE: %li", score] font:font2];
    YourScoreWasLabel.position = CGPointMake(self.size.width/2-60, self.size.height/2+13);
    YourScoreWasLabel.horizontalAlignment = BMGlyphHorizontalAlignmentLeft;
    
    /* Make After Highscore Label */
    YourHighScoreWasLabel = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"BEST: %li", highscore] font:font2];
    YourHighScoreWasLabel.position = CGPointMake(self.size.width/2-44.5, self.size.height/2-7);
    YourHighScoreWasLabel.horizontalAlignment = BMGlyphHorizontalAlignmentLeft;
    
    /* Make Tap Play Again Label */
    tapToPlayLabel = [BMGlyphLabel labelWithText:@"TAP TO PLAY!" font:font2];
    tapToPlayLabel.position = CGPointMake(self.size.width/2, self.size.height/2-65);
    
    /* Make Tap Play First Label */
    BMGlyphFont *font = [BMGlyphFont fontWithName:@"FontForFlyGuy"];
    tapToPlayFirstLabel = [BMGlyphLabel labelWithText:@"TAP TO PLAY!" font:font];
    tapToPlayFirstLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:tapToPlayFirstLabel];
    
    /* Make Game Over Board */
    gameOverBoard = [SKSpriteNode spriteNodeWithImageNamed:@"GameOverBoard"];
    gameOverBoard.position = CGPointMake(self.size.width/2, self.size.height/2+14);
    gameOverBoard.size = CGSizeMake(140, 120);
    
    /* Make New High Score Label */
    newHighScore = [BMGlyphLabel labelWithText:@"NEW\nHIGH\nSCORE!" font:font2];
    newHighScore.position = CGPointMake(self.size.width/2+110, self.size.height/2+30);
    newHighScore.horizontalAlignment = BMGlyphHorizontalAlignmentCentered;
    //[self addChild:newHighScore];

    /* Make Lives */
    lifeONE = [SKSpriteNode spriteNodeWithImageNamed:@"heartLifeSprite"];
    lifeONE.position = CGPointMake(self.size.width/2+145, self.size.height/2-77);
    lifeONE.size = CGSizeMake(lifeONE.size.width/2-3, lifeONE.size.height/2-3);
    lifeONE.name = @"lifeONE";
    
    lifeTWO = [SKSpriteNode spriteNodeWithImageNamed:@"heartLifeSprite"];
    lifeTWO.size = CGSizeMake(lifeTWO.size.width/2-3, lifeTWO.size.height/2-3);
    lifeTWO.position = CGPointMake(self.size.width/2+125, self.size.height/2-77);
    lifeTWO.name = @"lifeFour";
    
    lifeTHREE = [SKSpriteNode spriteNodeWithImageNamed:@"heartLifeSprite"];
    lifeTHREE.size = CGSizeMake(lifeTHREE.size.width/2-3, lifeTHREE.size.height/2-3);
    lifeTHREE.position = CGPointMake(self.size.width/2+105, self.size.height/2-77);
    lifeTHREE.name = @"lifeTHREE";
    
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
    
    NSArray *parallaxBackgroundNames = @[@"cloudOne", @"cloudTwo", @"cloudThree", @"cloudOne", @"cloudTwo", @"cloudThree"];
    CGSize planetSizes = CGSizeMake(50, 50);

    _parallaxNodeBackgrounds = [[FMMParallaxNode alloc] initWithBackgrounds:parallaxBackgroundNames
                                                                       size:planetSizes
                                                       pointsPerSecondSpeed:25.0];

    _parallaxNodeBackgrounds.position = CGPointMake(self.size.width/2.0+220, self.size.height/2.0-150);

    [_parallaxNodeBackgrounds randomizeNodesPositions];

    [self addChild:_parallaxNodeBackgrounds];
    
}

-(void) update:(NSTimeInterval)currentTime {
    
    [_parallaxNodeBackgrounds update:currentTime];
    
}

#pragma mark Other

-(void) didMoveToView:(SKView *)view {
    
}



@end








