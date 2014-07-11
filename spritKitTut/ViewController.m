//
//  ViewController.m
//  spritKitTut
//
//  Created by Ricky Brown on 6/2/14.
//  Copyright (c) 2014 15and50. All rights reserved.
//

#import "ViewController.h"

#import "MyScene.h"
#import "Twitter/Twitter.h"
#import "AppDelegate.h"
#import <iAd/iAd.h>
#import <MessageUI/MessageUI.h>


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
    scene.scaleMode = SKSceneScaleModeAspectFill;

    SKView *spriteView = (SKView *) self.view;
    spriteView.showsNodeCount = NO;
    spriteView.showsFPS = NO;
    
    // Present the scene.
    [skView presentScene:scene];
    
    //Add view controller as observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"hideAd" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"showAd" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleNotification:) name:@"shareIt" object:nil];
    
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

-(void) bannerViewDidLoadAd:(ADBannerView *)banner
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"showAd" object:nil];
    
}

-(void) bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"hideAd" object:nil];
    
}

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
    else if ([notification.name isEqualToString:@"shareIt"])
    {
        
        UIAlertView *popUp = [[UIAlertView alloc] initWithTitle:@"Share via..." message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Facebook", @"Twitter", @"iMessage", @"Email", @"Rate this app", nil];
        
        [popUp show];
        
    }
    
}

-(void) showBanner
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    if ((APP).screenIsSmall)
    {
        
        iAd.frame = CGRectMake(80, 270, iAd.frame.size.width, iAd.frame.size.height);
        
    }
    else
    {
        
        iAd.frame = CGRectMake(124, 270, iAd.frame.size.width, iAd.frame.size.height);
        
    }
    
    [UIView commitAnimations];
    
}

-(void) hideBanner
{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    
    iAd.frame = CGRectMake(571, 270, iAd.frame.size.width, iAd.frame.size.height);
    
    [UIView commitAnimations];
    
}

#pragma mark Share app

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if (buttonIndex == 1)
    {
        [self postScore];
    }
    else if (buttonIndex == 2)
    {
        [self tweetScore];
    }
    else if (buttonIndex == 3)
    {
        [self sendTheText];
    }
    else if (buttonIndex == 4)
    {
        [self sendTheEmail];
    }
    else if (buttonIndex == 5)
    {
        [self rateThisApp];
    }
    
}

-(void) postScore
{
    
    NSString *shareString = [NSString stringWithFormat:@"I just got %i on [app name]! Beat that!", shareScore];
    
    SLComposeViewController *post = [[SLComposeViewController alloc] init];
    
    post = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    [post addImage:[UIImage imageNamed:@"TheIcon"]];
    [post setInitialText:shareString];
    
    [self presentViewController:post animated:YES completion:nil];
    
}

-(void) tweetScore
{
    
    NSString *shareString = [NSString stringWithFormat:@"I just got %i on [app name]! Beat that!", shareScore];
    
    SLComposeViewController *tweet = [[SLComposeViewController alloc] init];
    
    tweet= [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    [tweet addImage:[UIImage imageNamed:@"TheIcon"]];
    [tweet setInitialText:shareString];
    
    [self presentViewController:tweet animated:YES completion:nil];
    
}

-(void) sendTheText
{
    
    NSString *shareString = [NSString stringWithFormat:@"I just got %i on [app name]! Beat that!", shareScore];
    
    MFMessageComposeViewController *textMessage = [[MFMessageComposeViewController alloc] init];
    
    [textMessage setMessageComposeDelegate:self];
    
    if ([MFMessageComposeViewController canSendText])
    {
        
        [textMessage setBody:shareString];
        
        [self presentViewController:textMessage animated:YES completion:nil];
        
    }
    
}

-(void) messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) sendTheEmail
{
    
    NSString *shareString = [NSString stringWithFormat:@"I just got %i on [app name]! Beat that!", shareScore];
    
    MFMailComposeViewController *mailComposer = [[MFMailComposeViewController alloc] init];
    
    [mailComposer setMailComposeDelegate:self];
    
    if ([MFMailComposeViewController canSendMail])
    {
        
        [mailComposer setSubject:@"App Name"];
        
        [mailComposer setMessageBody:shareString isHTML:NO];
        
        [self presentViewController:mailComposer animated:YES completion:nil];
        
    }
    
}

-(void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void) rateThisApp
{
    
    NSString *str = @"itms-apps://ax.itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=yourAppIDHere";
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.1) {
        str = @"itms-apps://itunes.apple.com/app/com.rickybrown.Popped";
    }
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}


@end




