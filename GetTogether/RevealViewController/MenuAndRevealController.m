//
//  MenuAndRevealController.m
//  MenuAndRevealController
//
//  Created by Lo Robert on 12-10-26.
//  Copyright (c) 2012年 Lo Robert. All rights reserved.
//

#import "MenuAndRevealController.h"
#import <QuartzCore/QuartzCore.h>

#define REVEAL_EDGE_OVERDRAW 60.0f


#define REVEAL_VIEW_TRIGGER_LEVEL_LEFT 125.0f


#define REVEAL_VIEW_TRIGGER_LEVEL_RIGHT 200.0f


#define VELOCITY_REQUIRED_FOR_QUICK_FLICK 1300.0f

@interface MenuAndRevealController ()

@end

@implementation MenuAndRevealController


- (id) initWithMenuController:(MenuController *) menuViewController revealController:(UIViewController *) revealViewController{
    self=[super init];
    
    if (self) {
        [self setMenuController:menuViewController];
        [_menuController setDelegate:self];
        
        [self.view setFrame:self.view.bounds];
        
        CGRect frame=self.view.frame;
        frame.origin.x=REVEAL_EDGE;
        
        
        [self setRevealController:revealViewController];
        [_revealController.view setFrame:frame];
        
        [self.view addSubview:_menuController.view];
        [self.view addSubview:_revealController.view];
        
        
        [self initRevealViewController];
        
        NSNotificationCenter *notificationCenter=[NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self selector:@selector(revealToggle:) name:REVEAL_TOOGLE object:nil];
        [self revealToggle:nil];
    }
    
    return self;
}


- (void)initRevealViewController {
    UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:self.view.bounds];
    _revealController.view.layer.masksToBounds = NO;
    _revealController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    _revealController.view.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
    _revealController.view.layer.shadowOpacity = 1.0f;
    _revealController.view.layer.shadowRadius = 12.5f;
    _revealController.view.layer.shadowPath = shadowPath.CGPath;
    
    CGRect frame=self.view.frame;
    
    frame.origin.y=frame.origin.y+44;
    frame.size.height=frame.size.height-44;
    
    UIView *fview=[[UIView alloc] initWithFrame:frame];
    [fview setTag:1000];
    [fview setBackgroundColor:[UIColor clearColor]];
    
    UIView *v=[_revealController.view viewWithTag:1000];
    if (v!=nil) {
        [v removeFromSuperview];
    }
    
    [_revealController.view addSubview:fview];
    
    [fview release];
    
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(revealGesture:)];
    [_revealController.view addGestureRecognizer:panGestureRecognizer];
    [panGestureRecognizer release];
    
    [self setCurrentFrontViewPosition:FrontViewPositionRight];
}


- (void)revealGesture:(UIPanGestureRecognizer *) recognizer{
	// 3. ...or maybe the interaction already _ENDED_?
    int count=[[(UINavigationController *)_revealController  viewControllers] count];
    
    
    if (count<=1) {
        
        if (UIGestureRecognizerStateEnded == [recognizer state]){
            // Case a): Quick finger flick fast enough to cause instant change:
            
            if (fabs([recognizer velocityInView:_revealController.view].x) > VELOCITY_REQUIRED_FOR_QUICK_FLICK){
                if ([recognizer velocityInView:_revealController.view].x > 0.0f){
                    [self _revealAnimation];
                }else{
                    [self _concealAnimation];
                }
            }else{
                float dynamicTriggerLevel = (FrontViewPositionLeft == self.currentFrontViewPosition) ? REVEAL_VIEW_TRIGGER_LEVEL_LEFT : REVEAL_VIEW_TRIGGER_LEVEL_RIGHT;
                
                if (_revealController.view.frame.origin.x >= dynamicTriggerLevel && _revealController.view.frame.origin.x != REVEAL_EDGE){
                    [self _revealAnimation];
                }else if (_revealController.view.frame.origin.x < dynamicTriggerLevel && _revealController.view.frame.origin.x != 0.0f){
                    [self _concealAnimation];
                }
                
            }
            
            // Now adjust the current state enum.
            if (_revealController.view.frame.origin.x == 0.0f){
                [[_revealController.view viewWithTag:1000] setHidden:YES];
                self.currentFrontViewPosition = FrontViewPositionLeft;
            }else{
                [[_revealController.view viewWithTag:1000] setHidden:NO];
                self.currentFrontViewPosition = FrontViewPositionRight;
            }
            
            return;
        }
        
        // 4. None of the above? That means it's _IN PROGRESS_!
        if (FrontViewPositionLeft == self.currentFrontViewPosition){
            if ([recognizer translationInView:self.view].x < 0.0f){
                _revealController.view.frame = CGRectMake(0.0f, 0.0f, _revealController.view.frame.size.width, _revealController.view.frame.size.height);
            }else{
                float offset = [self _calculateOffsetForTranslationInView:[recognizer translationInView:_revealController.view].x];
                _revealController.view.frame = CGRectMake(offset, 0.0f, _revealController.view.frame.size.width, _revealController.view.frame.size.height);
            }
        }else{
            if ([recognizer translationInView:self.view].x > 0.0f){
                float offset = [self _calculateOffsetForTranslationInView:([recognizer translationInView:self.view].x+REVEAL_EDGE)];
                _revealController.view.frame = CGRectMake(offset, 0.0f, _revealController.view.frame.size.width, _revealController.view.frame.size.height);
            }else if ([recognizer translationInView:self.view].x > -REVEAL_EDGE){
                _revealController.view.frame = CGRectMake([recognizer translationInView:self.view].x+REVEAL_EDGE, 0.0f, _revealController.view.frame.size.width, _revealController.view.frame.size.height);
            }else{
                _revealController.view.frame = CGRectMake(0.0f, 0.0f, _revealController.view.frame.size.width, _revealController.view.frame.size.height);
            }
        }
        
    }
}


- (void)revealToggle:(id)sender
{
    
	if (FrontViewPositionLeft == self.currentFrontViewPosition)
	{
        [_menuController viewWillAppear:YES];
        
        // Check if a delegate exists and if so, whether it is fine for us to revealing the rear view.
		if ([self.delegate respondsToSelector:@selector(revealController:shouldRevealRearViewController:)])
		{
			if (![self.delegate revealController:self shouldRevealRearViewController:self.revealController])
			{
				return;
			}
		}
        
        
		// Dispatch message to delegate, telling it the 'rearView' _WILL_ reveal, if appropriate:
		if ([self.delegate respondsToSelector:@selector(revealController:willRevealRearViewController:)])
		{
			[self.delegate revealController:self willRevealRearViewController:self.revealController];
		}
		
		[self _revealAnimation];
        
		self.currentFrontViewPosition = FrontViewPositionRight;
	}
	else
	{
		// Check if a delegate exists and if so, whether it is fine for us to hiding the rear view.
		if ([self.delegate respondsToSelector:@selector(revealController:shouldHideRearViewController:)])
		{
			if (![self.delegate revealController:self shouldHideRearViewController:self.revealController])
			{
				return;
			}
		}
        
		// Dispatch message to delegate, telling it the 'rearView' _WILL_ hide, if appropriate:
		if ([self.delegate respondsToSelector:@selector(revealController:willHideRearViewController:)])
		{
			[self.delegate revealController:self willHideRearViewController:self.revealController];
		}
        //
		[self _concealAnimation];
        
        //        [self _swapCurrentFrontViewControllerWith:_revealController animated:YES];
		
		self.currentFrontViewPosition = FrontViewPositionLeft;
	}
}


- (void)_swapCurrentFrontViewControllerWith:(UIViewController *)newFrontViewController animated:(BOOL)animated
{
	if ([self.delegate respondsToSelector:@selector(revealController:willSwapToFrontViewController:)])
	{
		[self.delegate revealController:self willSwapToFrontViewController:newFrontViewController];
	}
	
	CGFloat xSwapOffsetExpanded;
	CGFloat xSwapOffsetNormal;
	
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
		xSwapOffsetExpanded = [[UIScreen mainScreen] bounds].size.width;
		xSwapOffsetNormal = 0.0f;
	}
	else
	{
		xSwapOffsetExpanded = _revealController.view.frame.origin.x;
		xSwapOffsetNormal = _revealController.view.frame.origin.x;
	}
	
	if (animated)
	{
		[UIView animateWithDuration:0.15f delay:0.0f options:UIViewAnimationCurveEaseOut animations:^{
			_revealController.view.frame = CGRectMake(xSwapOffsetExpanded, 0.0f, _revealController.view.frame.size.width, _revealController.view.frame.size.height);
		}
                         completion:^(BOOL finished)
         {
			 
             [UIView animateWithDuration:0.225f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
                 _revealController.view.frame = CGRectMake(xSwapOffsetNormal, 0.0f, _revealController.view.frame.size.width, _revealController.view.frame.size.height);
             }
                              completion:^(BOOL finished)
              {
                  [self revealToggle:self];
				  
                  if ([self.delegate respondsToSelector:@selector(revealController:didSwapToFrontViewController:)])
                  {
                      [self.delegate revealController:self didSwapToFrontViewController:newFrontViewController];
                  }
              }];
         }];
	}
	else
	{
		
		if ([self.delegate respondsToSelector:@selector(revealController:didSwapToFrontViewController:)])
		{
			[self.delegate revealController:self didSwapToFrontViewController:newFrontViewController];
		}
		
		[self revealToggle:nil];
	}
}


#pragma mark - Helper

- (void)_revealAnimation{
	[UIView animateWithDuration:0.25f animations:^
     {
         _revealController.view.frame = CGRectMake(REVEAL_EDGE, 0.0f, _revealController.view.frame.size.width, _revealController.view.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         // Dispatch message to delegate, telling it the 'rearView' _DID_ reveal, if appropriate:
         if ([self.delegate respondsToSelector:@selector(revealController:didRevealRearViewController:)])
         {
             [self.delegate revealController:self didRevealRearViewController:self.revealController];
         }
     }];
}

- (void)_concealAnimation{
    
	[UIView animateWithDuration:0.25f animations:^
     {
         _revealController.view.frame = CGRectMake(0.0f, 0.0f, _revealController.view.frame.size.width, _revealController.view.frame.size.height);
     }
                     completion:^(BOOL finished)
     {
         // Dispatch message to delegate, telling it the 'rearView' _DID_ hide, if appropriate:
         if ([self.delegate respondsToSelector:@selector(revealController:didHideRearViewController:)])
         {
             [self.delegate revealController:self didHideRearViewController:self.revealController];
         }
     }];
}

/*
 * Note: If someone wants to bother to implement a better (smoother) function. Go for it and share!
 */
- (CGFloat)_calculateOffsetForTranslationInView:(CGFloat)x{
	CGFloat result;
	
	if (x <= REVEAL_EDGE){
		// Translate linearly.
		result = x;
	}else if (x <= REVEAL_EDGE+(M_PI*REVEAL_EDGE_OVERDRAW/2.0f)){
		// and eventually slow translation slowly.
		result = REVEAL_EDGE_OVERDRAW*sin((x-REVEAL_EDGE)/REVEAL_EDGE_OVERDRAW)+REVEAL_EDGE;
	}else{
		// ...until we hit the limit.
		result = REVEAL_EDGE+REVEAL_EDGE_OVERDRAW;
	}
	
	return result;
}



- (void)switchToViewController:(id) viewController{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<5.0) {
        [_revealController viewWillDisappear:YES];
    }
    
    [_revealController.view removeFromSuperview];
    
    [self setRevealController:viewController];
    
    CGRect frame=self.view.frame;
    frame.origin.x=REVEAL_EDGE;
    [_revealController.view setFrame:frame];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue]<5.0) {
        [viewController viewWillAppear:YES];
    }
    
    [self.view addSubview:_revealController.view];
    [self initRevealViewController];
    
    [self _swapCurrentFrontViewControllerWith:_revealController animated:YES];

}

-(void)popToRootViewController:(BOOL)animated{
    [self.navigationController popToRootViewControllerAnimated:animated];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


- (void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return NO;
}

-(void)dealloc{
    NSNotificationCenter *center=[NSNotificationCenter defaultCenter];
    [center removeObserver:self name:REVEAL_TOOGLE object:nil];
    _delegate=nil;
    [_menuController release];
    [_revealController release];
    [super dealloc];
}

@end
