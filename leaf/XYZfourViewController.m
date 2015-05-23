//
//  XYZfourViewController.m
//  leaf
//
//  Created by command.Zi on 14/12/17.
//  Copyright (c) 2014年 command.Zi. All rights reserved.
//

#import "XYZfourViewController.h"

@interface XYZfourViewController () {
    AVSpeechSynthesizer *av;
    AVSpeechUtterance * aaa;
}
@property (strong, nonatomic) IBOutlet UITextField *AField;
- (IBAction)Abtn:(id)sender;
- (IBAction)guoyu:(id)sender;
- (IBAction)yueyu:(id)sender;

@end

@implementation XYZfourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    av = [[AVSpeechSynthesizer alloc]init];
    aaa = [[AVSpeechUtterance alloc]init];
    
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

- (IBAction)Abtn:(id)sender {
    NSString * astring = self.AField.text;
    aaa = [AVSpeechUtterance speechUtteranceWithString:astring];
    aaa.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"zh-CH"];  //语言
    aaa.rate = 0.2;     //语速
    [av speakUtterance:aaa];
}

-(IBAction)backgroundTap:(id)sender {
    [self.AField resignFirstResponder];
}

- (IBAction)yueyu:(id)sender {
    [self seapkstring:@"zh-HK"];
}

- (IBAction)guoyu:(id)sender {
    [self seapkstring:@"zh-CH"];
}

-(void)seapkstring:(NSString *)language {
    NSString * astring = self.AField.text;
    aaa = [AVSpeechUtterance speechUtteranceWithString:astring];
    aaa.voice = [AVSpeechSynthesisVoice voiceWithLanguage:language];  //语言
    aaa.rate = 0.2;     //语速
    [av speakUtterance:aaa];
}

@end
