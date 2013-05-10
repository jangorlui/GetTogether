//
//  RootViewController.m
//  QpidNetwork
//
//  Created by Lo Robert on 12-10-29.
//
//

#import "RootViewController.h"

@interface RootViewController ()

@end

@implementation RootViewController


-(id)initWithMenuController:(MenuController *)menuViewController revealController:(UIViewController *)revealViewController{
    self=[super initWithMenuController:menuViewController revealController:revealViewController];
   
    if (self) {
        [super setDelegate:self];
    }
    
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.view.frame=self.view.bounds;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)revealController:(MenuAndRevealController *)revealController shouldRevealRearViewController:(UIViewController *)rearViewController{
    return YES;
}

- (BOOL)revealController:(MenuAndRevealController *)revealController shouldHideRearViewController:(UIViewController *)rearViewController{
    return YES;
}

/*
 * IMPORTANT: It is not guaranteed that 'didReveal...' will be called after 'willReveal...'. The user
 * might not have panned far enough for a reveal to be triggered! Thus 'didHide...' will be called!
 */
- (void)revealController:(MenuAndRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController{
    
}

- (void)revealController:(MenuAndRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController{
    
    UIView *view=[self.revealController.view viewWithTag:1000];
    [view setHidden:NO];
}


- (void)revealController:(MenuAndRevealController *)revealController willHideRearViewController:(UIViewController *)rearViewController{
    
}


- (void)revealController:(MenuAndRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController{
    UIView *view=[self.revealController.view viewWithTag:1000];
    [view setHidden:YES];
}

#pragma mark - New in 0.9.5

- (void)revealController:(MenuAndRevealController *)revealController willSwapToFrontViewController:(UIViewController *)frontViewController{
    
}

- (void)revealController:(MenuAndRevealController *)revealController didSwapToFrontViewController:(UIViewController *)frontViewController{
    
}

@end
