//
//  MenuViewController.m
//  GetTogether
//
//  Created by mac on 5/9/13.
//  Copyright (c) 2013 AlvinLui. All rights reserved.
//

#import "MenuViewController.h"
#import "LoginViewController.h"

@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSArray *menuItems;
@end

@implementation MenuViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _menuItems = [[NSArray alloc] initWithObjects:@"首页",@"我的专辑",@"我的圈子",@"我的相册",@"我的钱包",@"个人信息",@"帐户设定",@"站内消息", nil];
        NSLog(@"%d",_menuItems.count);
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

- (void)action:(id)sender {
    LoginViewController *myProfileVC=[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil];
    UINavigationController *nav=[[UINavigationController alloc] initWithRootViewController:myProfileVC];
    nav.navigationBarHidden = YES;
    [self switchToViewController:nav];
    [nav release];
    [myProfileVC release];
}

#pragma mark Table view data source and delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _menuItems.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = (UITableViewCell*)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = [_menuItems objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    [self action:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
