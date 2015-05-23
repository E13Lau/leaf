//
//  VerifyViewController.m
//  leaf
//
//  Created by command.Zi on 14/12/4.
//  Copyright (c) 2014年 command.Zi. All rights reserved.
//

#import "XYZVerifyViewController.h"

@interface XYZVerifyViewController ()
- (IBAction)dismissButton:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *numberText;

@end

@implementation XYZVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.numberText.text = self.content;
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

- (IBAction)dismissButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
