//
//  XYZthirdViewController.m
//  leaf
//
//  Created by command.Zi on 14/12/3.
//  Copyright (c) 2014年 command.Zi. All rights reserved.
//

#import "XYZthirdViewController.h"
#import "XYZVerifyViewController.h"
#import "Reachability.h"

@interface XYZthirdViewController () {
    NSTimer * countDownTimer;
    int secondsCountDown;
}

@property (strong, nonatomic) IBOutlet UIButton *getVerifyBtn;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel;
@property (strong, nonatomic) IBOutlet UITextField *yanzhengmatextField;
@property (strong, nonatomic) IBOutlet UITextField *numberstextField;
- (IBAction)nextButton:(id)sender;
- (IBAction)backgroundTap:(id)sender;
- (IBAction)getVerifyButton:(id)sender;

@end

@implementation XYZthirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.yanzhengmatextField.delegate = self;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ViewActionMethon
- (IBAction)nextButton:(id)sender {
    [self.numberstextField resignFirstResponder];
    [self.yanzhengmatextField resignFirstResponder];
    
    //待添加检测网络功能
    [SMS_SDK commitVerifyCode:self.yanzhengmatextField.text result:^(enum SMS_ResponseState state) {
        switch (state) {
            case 0: {
                NSLog(@"验证失败");
                self.warnLabel.text = @"验证失败";
                self.warnLabel.hidden = NO;
                [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(removeWarnLabel:) userInfo:nil repeats:NO];
                break;
            }
            case 1: {
                NSLog(@"验证成功");
                NSString *title = [NSString stringWithFormat:@"成功"];
                NSString  *message = [NSString stringWithFormat:@"验证成功"];
                [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
                break;
            }
            default:
                break;
        }
    }];
}

- (IBAction)backgroundTap:(id)sender {
    [self.numberstextField resignFirstResponder];
    [self.yanzhengmatextField resignFirstResponder];
}

- (IBAction)getVerifyButton:(id)sender {
    if (!(self.numberstextField.text.length == 11)) { //简单检测是否为11个数字手机号码
        NSString *title = [NSString stringWithFormat:@"警告⚠"];
        NSString  *message = [NSString stringWithFormat:@"请完整输入手机号码"];
        [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
    }else { //检测网络功能
        NetworkStatus networkStatus = [Reachability reachabilityForInternetConnection].currentReachabilityStatus;
        if (networkStatus == NotReachable) {
            NSLog(@"AAAA");
            NSString *title = [NSString stringWithFormat:@"警告⚠"];
            NSString  *message = [NSString stringWithFormat:@"请检测网络连接"];
            [[[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil]show];
        }else { //请求验证码
        [SMS_SDK getVerifyCodeByPhoneNumber:self.numberstextField.text AndZone:@"86" result:^(enum SMS_GetVerifyCodeResponseState state) { //回调，0为失败，1为成功
            switch (state) {
                case 0:{
                    NSLog(@"获取失败");
                    [self.numberstextField becomeFirstResponder];
                    self.warnLabel.text = @"获取失败";
                    self.warnLabel.hidden = NO;
                    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(removeWarnLabel:) userInfo:nil repeats:NO];
                    break;
                }
                case 1:{
                    NSLog(@"获取成功");
                    [self.yanzhengmatextField becomeFirstResponder];
                    self.warnLabel.text = @"获取成功";
                    self.warnLabel.hidden = NO;
                    [NSTimer scheduledTimerWithTimeInterval:0.8 target:self selector:@selector(removeWarnLabel:) userInfo:nil repeats:NO];
                    secondsCountDown = 30;
                    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];//1秒运行一次，若secondsCountDown==0则停止。
                    self.getVerifyBtn.enabled = false;
                    break;
                }
                default:
                    break;
            }
        }];
        }
    }
}

//button设置为30秒倒计时
-(void)timeFireMethod {
    secondsCountDown--;
    [self.getVerifyBtn setTitle:[NSString stringWithFormat:@"下次获取%d秒",secondsCountDown] forState:UIControlStateNormal];
    if(secondsCountDown==0){
        [countDownTimer invalidate];
        [self.getVerifyBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
        self.getVerifyBtn.enabled = true;
    }
}

-(void)removeWarnLabel:(NSTimer *)timer {
    //待实现动画
    self.warnLabel.hidden = YES;
}

#pragma mark UITextFieldDelegateMethod
//当输入框被激活
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}
//当输入框被激活
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
//当输入框取消激活
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}
//当输入框取消激活
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
}
//当输入框值（string）开始改变时...
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSLog(@"%@",string);
    return YES;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return YES;
}



#pragma mark SegueMethod
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    XYZVerifyViewController * verify = segue.destinationViewController;
    if ([[segue identifier] isEqualToString:@"setData"]) {
        verify.content = [NSString stringWithString:self.numberstextField.text];
    }
}

//将要跳转时判断
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([identifier isEqualToString:@"setData"]) {
        if (!self.numberstextField.text.length == 11) {
            return NO;
        }
    }
    return YES;
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
