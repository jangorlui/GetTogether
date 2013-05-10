//
//  MenuViewController.h
//  MenuAndRevealController
//
//  Created by Lo Robert on 12-10-26.
//  Copyright (c) 2012年 Lo Robert. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RevealViewController.h"

@protocol MenuControllerDelegate <NSObject>
@optional
- (void)switchToViewController:(id) viewController;
- (void)popToRootViewController:(BOOL)animated;
@end

@interface MenuController : UIViewController

@property(nonatomic,assign)id<MenuControllerDelegate> delegate;
@property(assign,nonatomic) id viewController;

- (void)switchToViewController:(id) viewController;
- (void)popToRootViewController:(BOOL)animated;
@end
