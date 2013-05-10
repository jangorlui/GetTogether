//
//  MenuAndRevealController.h
//  MenuAndRevealController
//
//  Created by Lo Robert on 12-10-26.
//  Copyright (c) 2012年 Lo Robert. All rights reserved.
//
#define REVEAL_EDGE 260.0f

#import <UIKit/UIKit.h>
#import "MenuController.h"
#import "RevealViewController.h"

typedef enum{
	FrontViewPositionLeft,
	FrontViewPositionRight
} FrontViewPosition;

@protocol MenuAndRevealControllerDelegate;

@interface MenuAndRevealController : UIViewController<MenuControllerDelegate>

@property(nonatomic,retain)MenuController *menuController;
@property(nonatomic,retain)UIViewController *revealController;
@property(assign,nonatomic)FrontViewPosition currentFrontViewPosition;


@property(nonatomic,assign)id<MenuAndRevealControllerDelegate> delegate;

- (id) initWithMenuController:(MenuController *) menuViewController revealController:(UIViewController *) revealViewController;
- (void)revealToggle:(id)sender;

@end


@protocol MenuAndRevealControllerDelegate <NSObject>

@optional

- (BOOL)revealController:(MenuAndRevealController *)revealController shouldRevealRearViewController:(UIViewController *)rearViewController;
- (BOOL)revealController:(MenuAndRevealController *)revealController shouldHideRearViewController:(UIViewController *)rearViewController;

/*
 * IMPORTANT: It is not guaranteed that 'didReveal...' will be called after 'willReveal...'. The user
 * might not have panned far enough for a reveal to be triggered! Thus 'didHide...' will be called!
 */
- (void)revealController:(MenuAndRevealController *)revealController willRevealRearViewController:(UIViewController *)rearViewController;
- (void)revealController:(MenuAndRevealController *)revealController didRevealRearViewController:(UIViewController *)rearViewController;

- (void)revealController:(MenuAndRevealController *)revealController willHideRearViewController:(UIViewController *)rearViewController;
- (void)revealController:(MenuAndRevealController *)revealController didHideRearViewController:(UIViewController *)rearViewController;

#pragma mark - New in 0.9.5

- (void)revealController:(MenuAndRevealController *)revealController willSwapToFrontViewController:(UIViewController *)frontViewController;
- (void)revealController:(MenuAndRevealController *)revealController didSwapToFrontViewController:(UIViewController *)frontViewController;

@end
