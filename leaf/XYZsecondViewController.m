//
//  rootViewController.m
//  leaf
//
//  Created by command.Zi on 14/12/3.
//  Copyright (c) 2014年 command.Zi. All rights reserved.
//

#import "XYZsecondViewController.h"
#import <Parse/Parse.h>
#import <ShareSDK/ShareSDK.h>

@interface XYZsecondViewController ()
- (IBAction)login:(id)sender;
- (IBAction)logout:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *idLabel;
@property (strong, nonatomic) IBOutlet UIImageView *Logimage;

@end

@implementation XYZsecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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

- (IBAction)login:(id)sender {
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace //类型为QQ空间，非QQ
                      authOptions:nil
                           result:^(BOOL result, id<ISSPlatformUser> userInfo, id<ICMErrorInfo> error) {
                               if (result)
                               {
                                   PFQuery *query = [PFQuery queryWithClassName:@"UserInfo"];
                                   [query whereKey:@"uid" equalTo:[userInfo uid]];
                                   [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
                                       if ([objects count] == 0)
                                       {
                                           //打印输出用户uid：
                                           NSLog(@"uid = %@",[userInfo uid]);
                                           //打印输出用户昵称：
                                           NSLog(@"name = %@",[userInfo nickname]);
                                           //打印输出用户头像地址：
                                           NSLog(@"icon = %@",[userInfo profileImage]);
                                           PFObject *newUser = [PFObject objectWithClassName:@"UserInfo"];
                                           [newUser setObject:[userInfo uid] forKey:@"uid"];
                                           [newUser setObject:[userInfo nickname] forKey:@"name"];
                                           [newUser setObject:[userInfo profileImage] forKey:@"icon"];
                                           [newUser saveInBackground];
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎注册" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                           [alertView show];
//                                           showLabelimage:(NSString *)name logid:(NSString *)logid logimg:(UIImage *)imgurl
                                           
                                           [self showLabelimage:[userInfo nickname] logid:[userInfo uid] logimgstr:[userInfo profileImage]];
                                       }
                                       else
                                       {
                                           //打印输出用户uid：
                                           NSLog(@"uid = %@",[userInfo uid]);
                                           //打印输出用户昵称：
                                           NSLog(@"name = %@",[userInfo nickname]);
                                           //打印输出用户头像地址：
                                           NSLog(@"icon = %@",[userInfo profileImage]);
                                           NSLog(@"AAAAA = %@",userInfo);
                                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"欢迎回来" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles: nil];
                                           [alertView show];
                                           [self showLabelimage:[userInfo nickname] logid:[userInfo uid] logimgstr:[userInfo profileImage]];
                                       }
                                   }];
//                                   MainViewController *mainVC = [[[MainViewController alloc] init] autorelease];
//                                   [self.navigationController pushViewController:mainVC animated:YES];
                               }
                           }];
}

//注销
- (IBAction)logout:(id)sender {
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    [self showLabelimage:nil logid:nil logimgstr:nil];
}

//setlabel
-(void)showLabelimage:(NSString *)name logid:(NSString *)logid logimgstr:(NSString *)imgurl {
    UIImage *img = [[UIImage alloc] initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgurl]]];
    self.nameLabel.text = name;
    self.idLabel.text = logid;
    self.Logimage.image = img;
}

@end
