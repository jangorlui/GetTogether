//
//  RevealViewController.m
//  MenuAndRevealController
//
//  Created by Lo Robert on 12-10-26.
//  Copyright (c) 2012年 Lo Robert. All rights reserved.
//

#import "RevealViewController.h"
#import <QuartzCore/QuartzCore.h>

#define REVEAL_EDGE_OVERDRAW 60.0f


#define REVEAL_VIEW_TRIGGER_LEVEL_LEFT 125.0f


#define REVEAL_VIEW_TRIGGER_LEVEL_RIGHT 200.0f


#define VELOCITY_REQUIRED_FOR_QUICK_FLICK 1300.0f


@interface RevealViewController ()

@end

@implementation RevealViewController

- (id) init{
    self=[super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)revealToggle:(id)sender{
    NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
    [notificationCenter postNotificationName:REVEAL_TOOGLE object:sender];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self) {
        self.view.frame=[[UIScreen mainScreen] bounds];
    }
    return self;
}


- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (_previousViewController) {
        if (![_previousViewController isEqual:viewController]) {
            [_previousViewController viewWillDisappear:animated];
        }
    }
    
    [viewController viewWillAppear:animated];
    
    [self setPreviousViewController:viewController];
}


- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    if (_previousViewController) {
        if (![_previousViewController isEqual:viewController]) {
            [_previousViewController viewDidDisappear:animated];
        }
    }
    
    [viewController viewDidAppear:animated];
    
    [self setPreviousViewController:viewController];
}


- (void)viewDidLoad{
    
    [super viewDidLoad];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<5.0) {
        [self setPreviousViewController:self];
        [self.navigationController setDelegate:self];
    }
    
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)dealloc{
    [_previousViewController release];
    [super dealloc];
}

@end
