//
//  MenuViewController.m
//  MenuAndRevealController
//
//  Created by Lo Robert on 12-10-26.
//  Copyright (c) 2012年 Lo Robert. All rights reserved.
//

#import "MenuController.h"

@interface MenuController ()

@end

@implementation MenuController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchToViewController:(id) viewController{
    if ([self.delegate conformsToProtocol:@protocol(MenuControllerDelegate)]) {
        if([self.delegate respondsToSelector:@selector(switchToViewController:)]){
            [self.delegate switchToViewController:viewController];
            [self setViewController:viewController];
        }
    }
}


- (void)popToRootViewController:(BOOL)animated{
    if ([self.delegate conformsToProtocol:@protocol(MenuControllerDelegate)]) {
        if([self.delegate respondsToSelector:@selector(popToRootViewController:)]){
            [self.delegate popToRootViewController:animated];
        }
    }
}

-(void)dealloc{
    _delegate=nil;
    _viewController=nil;
    [super dealloc];
}

@end
