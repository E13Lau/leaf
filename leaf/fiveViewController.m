//
//  fiveViewController.m
//  leaf
//
//  Created by command.Zi on 15/3/5.
//  Copyright (c) 2015年 command.Zi. All rights reserved.
//

#import "fiveViewController.h"
#import <WebKit/WebKit.h>

@interface fiveViewController ()

@property (strong, nonatomic) WKWebView * myWebView;

@end

@implementation fiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.myWebView = [[WKWebView alloc]initWithFrame:self.view.frame];
    [self.myWebView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com"]]];
    
    [self.view addSubview:self.myWebView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
