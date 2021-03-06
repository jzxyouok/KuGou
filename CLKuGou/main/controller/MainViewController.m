//
//  MainViewController.m
//  CLKuGou
//
//  Created by Darren on 16/7/29.
//  Copyright © 2016年 darren. All rights reserved.
//

#import "MainViewController.h"
#import "LinsenViewController.h"
#import "LookViewController.h"
#import "SingViewController.h"
#import "SKPresent.h"
#import "SettingViewController.h"
@interface MainViewController ()<UIScrollViewDelegate>
@property (nonatomic, weak) UIScrollView *contentView;

@property (nonatomic, strong) TitleScrollView *titleView;

@property (nonatomic, strong) SettingViewController *setVC;

@property (nonatomic, assign) BOOL flag;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNav];
    
    [self setupChildViews];

    [self setupContentView];
}

- (TitleScrollView *)titleView
{
    if (_titleView == nil) {
        _titleView = [[TitleScrollView alloc] initWithFrame:CGRectMake(100, 34, APPW-200, 30) TitleArray:@[@"听",@"看",@"唱"] selectedIndex:0 scrollEnable:NO lineEqualWidth:NO color:[UIColor whiteColor] selectColor:[UIColor orangeColor] SelectBlock:^(NSInteger index) {
            [self titleClick:index];
        }];
    }
    return _titleView;
}

- (void)setupNav
{
    [self.navBar addSubview:self.titleView];    
    self.leftItem.image = [UIImage imageNamed:@"placeHoder-128"];
    self.leftItem.frame = CGRectMake(20, 34, 20, 20);
    KGViewsBorder(self.leftItem, self.leftItem.width*0.5, 1, [UIColor grayColor])
    
    self.rightItem.image = [UIImage imageNamed:@"main_search"];
    self.rightItem.frame = CGRectMake(APPW-40, 34, 20, 20);
    
    self.navBar.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
}

- (void)setupChildViews
{
    LinsenViewController *linsenVc = [[LinsenViewController alloc] init];
    [self addChildViewController:linsenVc];
    
    LookViewController *lookVc = [[LookViewController alloc] init];
    [self addChildViewController:lookVc];
    
    SingViewController *singVc = [[SingViewController alloc] init];
    [self addChildViewController:singVc];
}

- (void)titleClick:(NSInteger)index
{
    [self.titleView setSelectedIndex:index];
    // 滚动
    CGPoint offset = self.contentView.contentOffset;
    offset.x = index * self.contentView.width;
    [self.contentView setContentOffset:offset animated:YES];
}

/**
 * 底部的scrollView
 */
- (void)setupContentView
{
    // 不要自动调整inset
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    UIScrollView *contentView = [[UIScrollView alloc] init];
    contentView.frame = self.view.bounds;
    contentView.delegate = self;
    contentView.bounces = NO;
    contentView.pagingEnabled = YES;
    [self.view insertSubview:contentView atIndex:0];
    contentView.contentSize = CGSizeMake(contentView.width * self.childViewControllers.count, 0);
    self.contentView = contentView;
    
    // 添加第一个控制器的view
    [self scrollViewDidEndScrollingAnimation:contentView];
}
#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    // 当前的索引
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    
    // 取出子控制器
    UIViewController *vc = self.childViewControllers[index];
    vc.view.x = scrollView.contentOffset.x;
    vc.view.y = 0; // 设置控制器view的y值为0(默认是20)
    vc.view.height = scrollView.height; // 设置控制器view的height值为整个屏幕的高度(默认是比屏幕高度少个20)
    [scrollView addSubview:vc.view];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];

    // 点击按钮
    NSInteger index = scrollView.contentOffset.x / scrollView.width;
    [self titleClick:index];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat alphe = scrollView.contentOffset.x / scrollView.width;
    
    self.navBar.backgroundColor = [UIColor colorWithRed:51/255. green:124/255. blue:200/255. alpha:alphe];
}
- (SettingViewController *)setVC
{
    if (_setVC == nil) {
        _setVC = [[SettingViewController alloc] init];
    }
    return _setVC;
}
#pragma mark - 抽屉效果
-(void)leftItemTouched:(id)sender
{
    self.flag = !self.flag;
    
    if (self.flag) {
        SKPresent *present = [SKPresent sharedSKPresent];
        self.setVC.transitioningDelegate = present;
        self.setVC.modalPresentationStyle = UIModalPresentationCustom;
        [self presentViewController:self.setVC animated:YES completion:nil];
    } else {
        [self.setVC dismissViewControllerAnimated:YES completion:nil];
    }
}
@end
