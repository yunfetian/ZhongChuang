//
//  LoginViewController.m
//  ZhongChuang
//
//  Created by 黄剛 on 2015/11/01.
//  Copyright © 2015年 黄剛. All rights reserved.
//

#import "LoginViewController.h"
#import "Masonry.h"
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@interface LoginViewController ()
@property (nonatomic,strong) UITextField *userName;
@property (nonatomic,strong) UITextField *password;
@property (nonatomic,strong) UIButton *submitBtn;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        self.view.backgroundColor = [[UIColor alloc] initWithRed:128 green:138 blue:135 alpha:0.8];
    [self initView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void) initView{//布局控件
    // タイトル
    UILabel *logonTitle = [[UILabel alloc] init];
    logonTitle.text = @"登録";
    [logonTitle sizeToFit];
    [self.view addSubview:logonTitle];
    [logonTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(120);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
    }];
    
    // ユーザー名
    UILabel *userNameLabel = [[UILabel alloc] init];
    userNameLabel.text = @"ユーザー名:";
    [userNameLabel sizeToFit];
    [self.view addSubview:userNameLabel];
    [userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(logonTitle.mas_bottom).with.offset(60);
        make.left.equalTo(self.view.mas_left).with.offset(10);
    }];
    UITextField *userName = [[UITextField alloc] init];
    userName.borderStyle = UITextBorderStyleRoundedRect;
    userName.placeholder = @"ユーザー名";
    userName.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:userName];
    [userName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userNameLabel.mas_right).with.offset(10);
        make.top.equalTo(userNameLabel.mas_top).with.offset(0);
        make.width.equalTo(@220);
    }];
    userName.returnKeyType = UIReturnKeyNext;
    userName.delegate = self;
    self.userName = userName;
    
    // パスワード
    UILabel *passwordLabel = [[UILabel alloc] init];
    passwordLabel.text = @"パスワード:";
    [passwordLabel sizeToFit];
    [self.view addSubview:passwordLabel];
    [passwordLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userNameLabel.mas_bottom).with.offset(20);
        make.left.equalTo(self.view.mas_left).with.offset(10);
    }];
    UITextField *password = [[UITextField alloc] init];
    password.borderStyle = UITextBorderStyleRoundedRect;
    password.secureTextEntry = TRUE;
    password.placeholder = @"パスワード";
    password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:password];
    [password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(userName.mas_left).with.offset(0);
        make.top.equalTo(passwordLabel.mas_top).with.offset(0);
        make.width.equalTo(@220);
    }];
    password.returnKeyType = UIReturnKeyDone;
    password.delegate = self;
    self.password = password;
    
    // 提交按钮
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"登陆" forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"logon_01" ] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submitLogon) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn sizeToFit];
    [self.view addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(password.mas_bottom).with.offset(40);
        make.centerX.equalTo(self.view.mas_centerX).with.offset(0);
        make.width.equalTo(@300);
        make.height.equalTo(@40);
    }];
    submitBtn.enabled = NO;
    self.submitBtn = submitBtn;


    // 轻击键盘之外的空白区域关闭虚拟键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];

}

// 提交处理
-(void)submitLogon {
    // 构造了一个最简单的字典类型的数据，因为自iOS 5后提供把NSDictionary转换成JSON格式的API
    NSDictionary *user = [[NSDictionary alloc] initWithObjectsAndKeys:@"userId", @"userId", nil];
    // 第二行if判断该字典数据是否可以被JSON化
    if ([NSJSONSerialization isValidJSONObject:user])
    {
        NSError *error;
        // 这一句就是把NSDictionary转换成JSON格式的方法，JSON格式的数据存储在NSData类型的变量中
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:user options:NSJSONWritingPrettyPrinted error: &error];
        // 这一句是把NSData转换成NSMutableData，原因是下面我们要利用ASIHTTPRequest发送JSON数据时，其消息体一定要以NSMutableData的格式存储
        NSMutableData *tempJsonData = [NSMutableData dataWithData:jsonData];
        NSLog(@"Register JSON:%@",[[NSString alloc] initWithData:tempJsonData encoding:NSUTF8StringEncoding]);
        // 这两句的主要功能是设置要与客户端交互的服务器端地址
        NSURL *url = [NSURL URLWithString:@"http://localhost:8080/zc/card/login.action"];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        // 是设置HTTP请求信息的头部信息，从中可以看到内容类型是JSON
        [request addRequestHeader:@"Content-Type" value:@"application/json; encoding=utf-8"];
        [request addRequestHeader:@"Accept" value:@"application/json"];
        // 接下来是设置请求方式（默认为GET）和消息体
        [request setRequestMethod:@"POST"];
        [request setPostBody:tempJsonData];
        // 一切设置完毕后开启同步请求
        [request startSynchronous];
        NSError *error1 = [request error];
        // 是打印服务器返回的响应信息
        if (!error1) {
            NSString *response = [request responseString];
            NSArray *arrlist=[response objectFromJSONString];
            NSLog(@"%lu",(unsigned long)[arrlist count]);
            for (int i=0; i<[arrlist count]; i++) {
                NSDictionary *item=[arrlist objectAtIndex:i];
                NSString *BrandName=[item objectForKey:@""];
                NSLog(@"%@",BrandName);
            }
        }
        
        
    }
}
-(void)dismissKeyboard {
    [self.userName resignFirstResponder];
    [self.password resignFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
{  //string就是此时输入的那个字符 textField就是此时正在输入的那个输入框 返回YES就是可以改变输入框的值 NO相反
    
    if ([string isEqualToString:@"\n"])  //按会车可以改变
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string]; //得到输入框的内容
    
    if (self.userName == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20不能继续输入
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
        if ([toBeString length] == 0) {// 活性非活性设定
            self.submitBtn.enabled = NO;
        } else if ([toBeString length] != 0 && [self.password.text length] != 0) {
            self.submitBtn.enabled = YES;
        } else {
            self.submitBtn.enabled = NO;
        }
    }
    if (self.password == textField)  //判断是否时我们想要限定的那个输入框
    {
        if ([toBeString length] > 20) { //如果输入框内容大于20不能继续输入
            textField.text = [toBeString substringToIndex:20];
            return NO;
        }
        if ([toBeString length] == 0) { // 活性非活性设定
            self.submitBtn.enabled = NO;
        } else if ([self.userName.text length] != 0  && [toBeString length] != 0) {
            self.submitBtn.enabled = YES;
        } else {
            self.submitBtn.enabled = NO;
        }
    }

    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField//点击下一项响应
{
    if(textField == self.userName) // 判断是不是需要的输入框
    {
        [self.password becomeFirstResponder];//下个输入框变成第一响应
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField {


}
@end
