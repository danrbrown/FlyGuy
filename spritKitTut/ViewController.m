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

-(void) viewWillLayoutSubviews
{
    
    [super viewDidLoad];

    // Configure the view.
    SKView * skView = (SKView *)self.view;
    skView.showsFPS = YES;
    skView.showsNodeCount = YES;
    
    // Create and configure the scene.
    SKScene * scene = [MyScene sceneWithSize:skView.bounds.size];
    //scene.scaleMode = SKSceneScaleModeAspectFill;

    SKView *spriteView = (SKView *) self.view;
    spriteView.showsNodeCount = NO;
    spriteView.showsFPS = NO;
    
    // Present the scene.
    [skView presentScene:scene];
    
    //Add view controller as observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];

    
}

-(BOOL) shouldAutorotate
{
    return YES;
}

-(BOOL) prefersStatusBarHidden
{
    return YES;
}

#pragma mark iAds

-(void) handleNotification:(NSNotification *)notification
{
    if ([notification.name isEqualToString:@"hideAd"])
    {
        [self hideBanner];
    }
    else if ([notification.name isEqualToString:@"showAd"])
    {
        [self showBanner];
    }
}

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
    
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
    
}

-(void) showBanner
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    iAd.frame = CGRectMake(124, 270, iAd.frame.size.width, iAd.frame.size.height);
    
    [UIView commitAnimations];
    
}

-(void) hideBanner
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    
    iAd.frame = CGRectMake(124, 324, iAd.frame.size.width, iAd.frame.size.height);
    
    [UIView commitAnimations];
    
}

@end




