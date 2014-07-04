//
//  ViewController.m
//  spritKitTut
//
//  Created by Ricky Brown on 6/2/14.
//  Copyright (c) 2014 15and50. All rights reserved.
//

#import "ViewController.h"

#import "MyScene.h"
#import <iAd/iAd.h>

@implementation ViewController

-(void) viewDidLoad
{
    
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    scene.scaleMode = SKSceneScaleModeAspectFill;

    SKView *spriteView = (SKView *) self.view;
    spriteView.showsNodeCount = NO;
    spriteView.showsFPS = NO;
    
    // Present the scene.
    [skView presentScene:scene];
    
}

-(BOOL) shouldAutorotate
{
    return YES;
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    [banner setAlpha:0];
    
    [UIView commitAnimations];
    
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    [banner setAlpha:0];
    
    [UIView commitAnimations];
    
}

@end




