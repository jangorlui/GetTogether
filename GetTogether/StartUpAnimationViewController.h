//
//  StartUpAnimationViewController.h
//  GetTogether
//
//  Created by mac on 5/9/13.
//  Copyright (c) 2013 AlvinLui. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StartUpAnimationViewController : UIViewController
{
    IBOutlet UIScrollView *sv;
    IBOutlet UIPageControl *page;
    NSArray *Arr;
    int TimeNum;
    BOOL Tend;
}
@end
