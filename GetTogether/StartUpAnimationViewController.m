//
//  StartUpAnimationViewController.m
//  GetTogether
//
//  Created by mac on 5/9/13.
//  Copyright (c) 2013 AlvinLui. All rights reserved.
//

#define SINGLEPAGE_WIDTH 320
#define SINGLEPAGE_HEIGHT 460

#import "StartUpAnimationViewController.h"
#import "ViewController.h"

@interface StartUpAnimationViewController ()<UIScrollViewDelegate>
@end

@implementation StartUpAnimationViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)viewDidLoad
{
    Arr=[[NSArray alloc]initWithObjects:
         @"http://code4app.com/img/code4app_logo.png",
         @"http://ui4app.com/img/ui4app_logo.png",
         @"http://www.baidu.com/img/baidu_sylogo1.gif",nil];
    [self AdImg:Arr];
    [self setCurrentPage:page.currentPage];
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 下载图片
void UIImageFromURL( NSURL * URL, void (^imageBlock)(UIImage * image), void (^errorBlock)(void) )
{
    dispatch_async( dispatch_get_global_queue( DISPATCH_QUEUE_PRIORITY_DEFAULT, 0 ), ^(void)
                   {
                       NSData * data = [[NSData alloc] initWithContentsOfURL:URL] ;
                       UIImage * image = [[UIImage alloc] initWithData:data];
                       dispatch_async( dispatch_get_main_queue(), ^(void){
                           if( image != nil )
                           {
                               imageBlock( image );
                           } else {
                               errorBlock();
                           }
                       });
                   });
}

-(void)AdImg:(NSArray*)arr{
    [sv setContentSize:CGSizeMake(SINGLEPAGE_WIDTH, [arr count]*SINGLEPAGE_HEIGHT)];
    page.numberOfPages=[arr count];
    
    for ( int i=0; i<[arr count]; i++) {
        NSString *url=[arr objectAtIndex:i];
        UIButton *img=[[UIButton alloc]initWithFrame:CGRectMake(0,SINGLEPAGE_HEIGHT*i, SINGLEPAGE_WIDTH, SINGLEPAGE_HEIGHT)];
        [img addTarget:self action:@selector(Action) forControlEvents:UIControlEventTouchUpInside];
        [sv addSubview:img];
        UIImageFromURL( [NSURL URLWithString:url], ^( UIImage * image )
                       {
                           [img setImage:image forState:UIControlStateNormal];
                       }, ^(void){
                       });
    }
}

- (BOOL)isFinishStartUpAnimation
{
    if (Arr.count-1 == page.currentPage) {
        return YES;
    }else
        return NO;
}

-(void)Action{
    if ([self isFinishStartUpAnimation]) {
        ViewController *viewVC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewVC];
        nav.navigationBarHidden = YES;
        [viewVC release];
        [self presentViewController:nav animated:YES completion:nil];
        [nav release];
    }
}

#pragma mark - scrollView && page
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    page.currentPage=scrollView.contentOffset.y/SINGLEPAGE_HEIGHT;
    [self setCurrentPage:page.currentPage];
}

- (void) setCurrentPage:(NSInteger)secondPage {
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [page.subviews count]; subviewIndex++) {
        UIImageView* subview = [page.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 24/2;
        size.width = 24/2;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        if (subviewIndex == secondPage) [subview setImage:[UIImage imageNamed:@"a.png"]];
        else [subview setImage:[UIImage imageNamed:@"d.png"]];
    }
}

@end
