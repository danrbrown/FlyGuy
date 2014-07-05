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
#import "ViewController.h"

static const uint32_t wallCategory       =  0x1 << 2;
static const uint32_t rockCategory       =  0x1 << 1;
static const uint32_t playerCategory     =  0x1 << 0;

@implementation MyScene

-(id)initWithSize:(CGSize)size {
    
    if (self = [super initWithSize:size])
    {
        
        /* Setup scene */
        self.backgroundColor = [SKColor colorWithRed: 100.0/255.0 green: 200.0/255.0 blue:255.0/255.0 alpha: 1.0];
        
        /* Collision */
        CGRect frame = CGRectMake(0, -30, self.size.width+30, self.size.height+100);
        self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:frame];
        self.physicsBody.categoryBitMask = wallCategory;
        self.physicsWorld.contactDelegate = self;
        self.physicsWorld.gravity = CGVectorMake(0,-5);
        self.physicsBody.restitution = 0.0f;
        
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
        [self moveBackground];
        [self makeGameLabels];
        [self makePlayer];
    
    }
    
    return self;

}

#pragma mark Send them coins in

-(void) addSpritesIn {
    
    rockSprite.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:rockSprite.size];
    rockSprite.physicsBody.dynamic = YES;
    rockSprite.physicsBody.affectedByGravity = NO;
    rockSprite.physicsBody.categoryBitMask = rockCategory;
    rockSprite.physicsBody.contactTestBitMask = playerCategory;
    rockSprite.physicsBody.collisionBitMask = 0;
    rockSprite.physicsBody.usesPreciseCollisionDetection = YES;
    
    int randomSpeed = (arc4random()%(5-2))+2;
    float waitTime = 0.5;
    int randomPosition = (arc4random()%(320-0)) + 0;
    
    [self sendInRockAtSpeed:randomSpeed waitTime:waitTime atY:randomPosition];
    
}

-(void) sendInRockAtSpeed:(int)speed waitTime:(float)wait atY:(int)y {
    
    SKAction *moveObstacle = [SKAction moveToX:moveToX duration:speed];
    rockSprite = [SKSpriteNode spriteNodeWithImageNamed:@"RockSprite"];
    
    rockSprite.size = CGSizeMake(40, 25);
    rockSprite.position = CGPointMake(568, y);
    [self addChild:rockSprite];
    [rockSprite runAction:moveObstacle withKey:@"moveing"];
    
    [rockSprite runAction:moveObstacle completion:^(void){
       
        score++;
        scoreLabel.text = [NSString stringWithFormat:@"%li", (long)score];
        
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
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
        
        fuel = maxFuel;
        score = 0;
        lives = 3;
        scoreLabel.text = [NSString stringWithFormat:@"%li", (long)score];
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
        [newHighScore removeFromParent];
        
        SKAction *blinkSequence = [SKAction sequence:@[[SKAction fadeAlphaTo:1.0 duration:0],[SKAction fadeAlphaTo:0.0 duration:0],[SKAction fadeAlphaTo:1.0 duration:0]]];
        
        [lifeONE runAction:[SKAction repeatAction:blinkSequence count:5] completion:^{}];
        [lifeTWO runAction:[SKAction repeatAction:blinkSequence count:5] completion:^{}];
        [lifeTHREE runAction:[SKAction repeatAction:blinkSequence count:5] completion:^{}];
        
        [self addChild:scoreLabel];
        [self performSelector:@selector(addSpritesIn) withObject:self afterDelay:1];
        
    }
    else if (playing && !hit)
    {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
        
        [player.physicsBody applyImpulse:CGVectorMake(0.0f, 40.0f)];
        
        [player setTexture:[SKTexture textureWithImageNamed:@"jetPackGuyFly"]];
        
    }
    
}

-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [player setTexture:[SKTexture textureWithImageNamed:@"jetPackGuy"]];
    
}

#pragma mark Game over

-(void) gameOver {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
    
    YourScoreWasLabel.text = [NSString stringWithFormat:@"SCORE: %li", (long)score];
    
    NSInteger theHighScore = [[NSUserDefaults standardUserDefaults] integerForKey:@"HighScore"];
    highscore = theHighScore;
    
    if (score > theHighScore)
    {
        
        highscore = score;
        YourHighScoreWasLabel.text = [NSString stringWithFormat:@"BEST: %li", (long)highscore];
        [[NSUserDefaults standardUserDefaults] setInteger:highscore forKey:@"HighScore"];
        
        [self addChild:newHighScore];
        
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
    
    [self performSelector:@selector(setPlayer) withObject:self afterDelay:2];
    
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
        [self collision1:(SKSpriteNode *) firstBody.node didCollideWithRock:(SKSpriteNode *) secondBody.node];
    }
    
    if ((firstBody.categoryBitMask & playerCategory) != 0 && (thirdBody.categoryBitMask & wallCategory) != 0)
    {
        [self collision2:(SKSpriteNode *) firstBody.node didCollideWithRock:(SKSpriteNode *) thirdBody.node];
    }
    
}

-(void) anyCollision
{
    
    if (lives > 0)
    {
        
        player.alpha = 0.0;
        SKAction *blinkPlayer = [SKAction sequence:@[[SKAction fadeAlphaTo:1.0 duration:0],[SKAction fadeAlphaTo:0.0 duration:0],[SKAction fadeAlphaTo:1.0 duration:0]]];
        SKAction *blinkHeart = [SKAction sequence:@[[SKAction fadeAlphaTo:0.0 duration:0],[SKAction fadeAlphaTo:1.0 duration:0],[SKAction fadeAlphaTo:0.0 duration:0]]];
        
        if (lives == 3)
        {
            [lifeTHREE runAction:[SKAction repeatAction:blinkHeart count:5] completion:^{}];
        }
        if (lives == 2)
        {
            [lifeTWO runAction:[SKAction repeatAction:blinkHeart count:5] completion:^{}];
        }
        if (lives == 1)
        {
            [lifeONE runAction:[SKAction repeatAction:blinkHeart count:5] completion:^{}];
        }
        
        lives--;
        
        [player runAction:[SKAction repeatAction:blinkPlayer count:5] completion:^{}];
        
    }
    
    if (!hit && lives < 1)
    {
        
        hit = YES;
        
        SKAction *rotation = [SKAction rotateByAngle: M_PI/2.0 duration:1];
        SKAction *moveByHit = [SKAction moveToX:player.position.x-10 duration:0.4];
        SKAction *playerWasHit = [SKAction sequence:@[rotation, moveByHit]];
        [player runAction:playerWasHit];
        
        [self performSelector:@selector(yourDone) withObject:self afterDelay:0.2];
        
    }
    
}

-(void) yourDone {
    
    gameOver = NO;
    [self gameOver];
    
}

#pragma mark Collision between player and wall

-(void) collision2:(SKSpriteNode *)playerS didCollideWithRock:(SKSpriteNode *)wallS {
    
    [self anyCollision];
    
}

#pragma mark Collision between player and rock

-(void) collision1:(SKSpriteNode *)playerS didCollideWithRock:(SKSpriteNode *)rockS {
    
    [self anyCollision];
    
}

#pragma mark Make labels

-(void) makeGameLabels {
    
    BMGlyphFont *font2 = [BMGlyphFont fontWithName:@"FontForFlyGuy2"];
    
    /* Make Score Label */
    score = 0;
    scoreLabel = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"%li", (long)score] font:font2];
    scoreLabel.position = CGPointMake(self.size.width/2-275, self.size.height/2-137);
    scoreLabel.horizontalAlignment = BMGlyphHorizontalAlignmentLeft;
    
    /* Make Game Over Label */
    GameOverLabel = [BMGlyphLabel labelWithText:@"GAME OVER!" font:font2];
    GameOverLabel.position = CGPointMake(self.size.width/2, self.size.height/2+75);
    
    /* Make After Score Label */
    YourScoreWasLabel = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"SCORE: %li", (long)score] font:font2];
    YourScoreWasLabel.position = CGPointMake(self.size.width/2-110, self.size.height/2+30);
    YourScoreWasLabel.horizontalAlignment = BMGlyphHorizontalAlignmentLeft;
    
    /* Make After Highscore Label */
    YourHighScoreWasLabel = [BMGlyphLabel labelWithText:[NSString stringWithFormat:@"BEST: %li", (long)highscore] font:font2];
    YourHighScoreWasLabel.position = CGPointMake(self.size.width/2-86, self.size.height/2-7);
    YourHighScoreWasLabel.horizontalAlignment = BMGlyphHorizontalAlignmentLeft;
    
    /* Make Tap Play Again Label */
    tapToPlayLabel = [BMGlyphLabel labelWithText:@"TAP TO PLAY!" font:font2];
    tapToPlayLabel.position = CGPointMake(self.size.width/2, self.size.height/2-60);
    
    /* Make Tap Play First Label */
    BMGlyphFont *font = [BMGlyphFont fontWithName:@"FontForFlyGuy"];
    tapToPlayFirstLabel = [BMGlyphLabel labelWithText:@"TAP TO PLAY!" font:font];
    tapToPlayFirstLabel.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:tapToPlayFirstLabel];
    
    /* Make New High Score Label */
    newHighScore = [BMGlyphLabel labelWithText:@"NEW BEST!" font:font2];
    newHighScore.position = CGPointMake(self.size.width/2+200, self.size.height/2+100);
    newHighScore.horizontalAlignment = BMGlyphHorizontalAlignmentCentered;
    
    SKAction *rotation = [SKAction rotateByAngle: M_PI/-6.0 duration:0];
    [newHighScore runAction:rotation];
    
    /* Make Game Over Board */
    gameOverBoard = [SKSpriteNode spriteNodeWithImageNamed:@"GameOverBoard"];
    gameOverBoard.position = CGPointMake(self.size.width/2, self.size.height/2+14);
    gameOverBoard.size = CGSizeMake(140*2, 120*2);

    int y = 135;
    int x = 260;
    int s = 3;
    
    /* Make Lives */
    lifeONE = [SKSpriteNode spriteNodeWithImageNamed:@"heartLifeSprite"];
    lifeONE.position = CGPointMake(self.size.width/2+x, self.size.height/2-y);
    lifeONE.size = CGSizeMake(lifeONE.size.width-s, lifeONE.size.height-s);
    lifeONE.name = @"lifeONE";
    lifeONE.alpha = 0;
    [self addChild:lifeONE];
    
    lifeTWO = [SKSpriteNode spriteNodeWithImageNamed:@"heartLifeSprite"];
    lifeTWO.size = CGSizeMake(lifeTWO.size.width-s, lifeTWO.size.height-s);
    lifeTWO.position = CGPointMake(self.size.width/2+x-40, self.size.height/2-y);
    lifeTWO.name = @"lifeFour";
    lifeTWO.alpha = 0;
    [self addChild:lifeTWO];
    
    lifeTHREE = [SKSpriteNode spriteNodeWithImageNamed:@"heartLifeSprite"];
    lifeTHREE.size = CGSizeMake(lifeTHREE.size.width-s, lifeTHREE.size.height-s);
    lifeTHREE.position = CGPointMake(self.size.width/2+x-80, self.size.height/2-y);
    lifeTHREE.name = @"lifeTHREE";
    lifeTHREE.alpha = 0;
    [self addChild:lifeTHREE];
    
}

#pragma mark Make player

-(void) makePlayer {
    
    player = [SKSpriteNode spriteNodeWithImageNamed:@"jetPackGuy"];
    player.position = CGPointMake(60, self.size.height/2);
    player.size = CGSizeMake(player.size.width*2, player.size.height*2);

    player.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:player.size];
    player.physicsBody.affectedByGravity = NO;
    player.physicsBody.dynamic = YES;
    player.physicsBody.categoryBitMask = playerCategory;
    player.physicsBody.contactTestBitMask = rockCategory | wallCategory;
    player.physicsBody.allowsRotation = NO;
    player.physicsBody.collisionBitMask = wallCategory;
    player.physicsBody.restitution = 0.0f;
    
    [self addChild:player];
    
    float y = player.position.y;
    SKAction *a = [SKAction moveToY:(y+5) duration:0.5];
    SKAction *b = [SKAction moveToY:y duration:0.5];
    SKAction *sequence = [SKAction sequence:@[a,b]];
    [player runAction:[SKAction repeatActionForever:sequence] withKey:@"flouting"];
    
}

#pragma mark Moving backround

-(void) moveBackground {
    
    SKSpriteNode *background = [SKSpriteNode spriteNodeWithImageNamed:@"Background"];
    background.position = CGPointMake(self.size.width/2, self.size.height/2);
    [self addChild:background];
    
}

-(void) update:(NSTimeInterval)currentTime {
    

    
}

#pragma mark Other

-(void) didMoveToView:(SKView *)view {
    
}

@end








