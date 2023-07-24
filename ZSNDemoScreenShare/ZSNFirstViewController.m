//
//  ZSNFirstViewController.m
//  ZSNDemoScreenShare
//
//  Created by zhaosuning on 2023/5/17.
//

#import "ZSNFirstViewController.h"
#import "ZSNScreenShareViewController.h"
#import "ZSNMultiChannelScreenShareVC.h"

@interface ZSNFirstViewController ()

@end

@implementation ZSNFirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    
    UILabel * lblTopTitle = [[UILabel alloc] init];
    lblTopTitle.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width / 2.0 - 50, 100, 100, 40);
    lblTopTitle.text = @"首页";
    lblTopTitle.textColor = [UIColor blueColor];
    lblTopTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblTopTitle];
    
    //UIButton 初始化建议用buttonWithType
    UIButton *btnNextPage = [UIButton buttonWithType:UIButtonTypeCustom];
    btnNextPage.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width / 2.0 - 100, 160, 200, 40);
    [btnNextPage setTitle:@"下一页" forState:UIControlStateNormal];
    [btnNextPage.layer setCornerRadius:20];
    [btnNextPage.layer setMasksToBounds:YES];
    [btnNextPage setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnNextPage.backgroundColor = [UIColor greenColor];
    btnNextPage.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btnNextPage addTarget:self action:@selector(btnNextPageAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnNextPage];
    
}

-(void) btnNextPageAction : (UIButton *) button {
    NSLog(@"打印了 点击进入下一页btnNextPageAction");
    
    //ZSNScreenShareViewController *vc = [[ZSNScreenShareViewController alloc] init];
    
    ZSNMultiChannelScreenShareVC *vc = [[ZSNMultiChannelScreenShareVC alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


@end
