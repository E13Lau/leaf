//                            _ooOoo_
//                           o8888888o
//                           88" . "88
//                           (| -_- |)
//                            O\ = /O
//                        ____/`---'\____
//                      .   ' \\| |// `.
//                       / \\||| : |||// \
//                     / _||||| -:- |||||- \
//                       | | \\\ - /// | |
//                     | \_| ''\---/'' | |
//                      \ .-\__ `-` ___/-. /
//                   ___`. .' /--.--\ `. . __
//                ."" '< `.___\_<|>_/___.' >'"".
//               | | : `- \`.;`\ _ /`;.`/ - ` : | |
//                 \ \ `-. \_ __\ /__ _/ .-` / /
//         ======`-.____`-.___\_____/___.-`____.-'======
//                            `=---='
//
//         .............................................
//                  佛祖镇楼                  BUG辟易
//
//  ViewController.m
//  leaf
//
//  Created by command.Zi on 14/12/1.
//  Copyright (c) 2014年 command.Zi. All rights reserved.
//

#import "XYZrootViewController.h"

#import <ShareSDK/ShareSDK.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

@interface XYZrootViewController () {
    UIWebView * testwebview;
    UIActivityIndicatorView * activityIndicator;
    UIProgressView * progressView;
    UIView *backview;
}
@property (strong, nonatomic) IBOutlet UIWebView *webView;
@property (strong, nonatomic) IBOutlet UITextField *urlField;
- (IBAction)InBtn:(id)sender;
- (IBAction)ShareBtn:(id)sender;
- (IBAction)backBtn:(id)sender;
- (IBAction)No1:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *itemView;

@end

@implementation XYZrootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //单击的 Recognizer
    UITapGestureRecognizer * singleRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SingleTap:)];
    singleRecognizer.numberOfTapsRequired = 1;    //tap次数
    [self.itemView addGestureRecognizer:singleRecognizer];
    
    //移动Recognizer
//    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(selector)];
    
    self.urlField.delegate = self;
    self.webView.delegate = self;
    
    [self showActivityIndicator];
        // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIViewAction
- (IBAction)InBtn:(id)sender {
    if (!self.urlField.text.length == 0) {
        self.itemView.hidden = YES;
        //待做判断
        //获得field的text并请求该URL
        NSString * urla = self.urlField.text;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urla]];
        //webview加载请求
        [self.webView loadRequest:request];
        [self.urlField resignFirstResponder];
    }else if(self.urlField.text.length == 0) {
        self.itemView.hidden = NO;
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:nil]];
        [self.webView loadRequest:request];
        [self.urlField resignFirstResponder];
    }
}

- (IBAction)ShareBtn:(id)sender {
    
    NSString *imagePath = [[NSBundle mainBundle] pathForResource:@"no1" ofType:@"jpg"];
    [ShareSDK imageWithPath:imagePath];
    NSString *urlstring = [[NSString alloc]initWithFormat:@"%@",self.webView.request.URL.absoluteString];
    //构造分享内容
    id<ISSContent> publishContent = [ShareSDK content:urlstring
                                       defaultContent:urlstring
                                                image:[ShareSDK imageWithPath:imagePath]
                                                title:@"Share"
                                                  url:urlstring
                                          description:@"Testing"
                                            mediaType:SSPublishContentMediaTypeText];
    //创建弹出菜单容器
    id<ISSContainer> container = [ShareSDK container];
    [container setIPadContainerWithView:sender arrowDirect:UIPopoverArrowDirectionUp];
    
    //弹出分享菜单
    [ShareSDK showShareActionSheet:container
                         shareList:nil
                           content:publishContent
                     statusBarTips:YES
                       authOptions:nil
                      shareOptions:nil
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_SUC", @"分享成功"));
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(NSLocalizedString(@"TEXT_ShARE_FAI", @"分享失败,错误码:%d,错误描述:%@"), [error errorCode], [error errorDescription]);
                                }
                            }];
}

- (IBAction)backBtn:(id)sender {
    [self.webView goBack];
}

- (IBAction)No1:(id)sender {
    NSString * url = [NSString stringWithFormat:@"http://hao123.com"];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [self.webView loadRequest:request];
    [self.urlField resignFirstResponder];
    self.itemView.hidden = YES;
}

#pragma mark UIWebViewDelegateMethod
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}

- (void )webViewDidStartLoad:(UIWebView  *)webView {
    
    [self.view addSubview:backview];
    [self.view addSubview:progressView];
    [self.view addSubview:activityIndicator];
    
    [progressView setProgress:1 animated:YES];
    
    [activityIndicator startAnimating];

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [progressView setProgress:0.2 animated:YES];
    
    self.urlField.text = self.webView.request.URL.absoluteString;

    [self removeActivityIndicator];
    
    NSLog(@"%@",self.webView.request.URL.absoluteString);
}

- (void)webView:(UIWebView *)webView  didFailLoadWithError:(NSError *)error {
    [self removeActivityIndicator];
}

#pragma mark singleRecognizerDelegateMethod
- (void)SingleTap:(UITapGestureRecognizer *)recognizer
{
    if (!self.urlField.text.length == 0) {
        //当地址栏有内容
        //处理单击操作
        self.itemView.hidden = YES;
    }else if (self.webView.request.URL.absoluteString) {
        //当地址栏的地址被删除后
        self.itemView.hidden = YES;
        self.urlField.text = self.webView.request.URL.absoluteString;
    }
    //取消textField响应
    [self.urlField resignFirstResponder];
}

#pragma mark textFieldDelegateMethod
//当textfield为编辑状态，itemview为不隐藏状态
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    self.itemView.hidden = NO;
    return YES;
}

#pragma mark ActivityIndicator Method

-(void)showActivityIndicator {
    //创建UIActivityIndicatorView背底半透明View
    backview = [[UIView alloc] initWithFrame:CGRectMake(0, 58, self.view.bounds.size.width, self.view.bounds.size.height)];
    [backview setTag:108];
    [backview setBackgroundColor:[UIColor blackColor]];
    [backview setAlpha:0.5];
    progressView = [[UIProgressView alloc]initWithFrame:CGRectMake(0, 56, self.view.bounds.size.width, 5)];
    activityIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 32.0f, 32.0f)];
    [activityIndicator setCenter:self.view.center];
    [activityIndicator setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhiteLarge];

}

-(void)removeActivityIndicator {
    [backview removeFromSuperview];
    [progressView removeFromSuperview];
    [activityIndicator stopAnimating];
}

@end
