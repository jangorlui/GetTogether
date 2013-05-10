//
//  ViewController.m
//  GetTogether
//
//  Created by mac on 5/9/13.
//  Copyright (c) 2013 AlvinLui. All rights reserved.
//

#import "ViewController.h"
#import "MenuViewController.h"
#import "RightViewController.h"
#import "RootViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnLoginButtonTap:(id)sender {
    MenuViewController *menuController=[[MenuViewController alloc] initWithNibName:@"MenuViewController" bundle:nil] ;
    
    RightViewController *rightController=[[RightViewController alloc] initWithNibName:@"RightViewController" bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rightController];
    navigationController.navigationBarHidden = YES;
    
    RootViewController *rootController=[[RootViewController alloc] initWithMenuController:menuController revealController:navigationController];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<5.0) {
        [menuController switchToViewController:navigationController];
    }
    [navigationController release];
    [self.navigationController pushViewController:rootController animated:YES];
    [rootController release];
    [rightController switchView:nil];
    [rightController release];
}

@end
