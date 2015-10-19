//
//  SaleGoodServiceViewController.m
//  businessNeed
//
//  Created by 黄剛 on 2015/08/21.
//  Copyright (c) 2015年 黄剛. All rights reserved.
//

#import "SaleGoodServiceViewController.h"
#import "Masonry.h"
#import <ShareSDK/ShareSDK.h>
#import "ASIHTTPRequest.h"
#import "JSONKit.h"

@interface SaleGoodServiceViewController ()


@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UITextView *buyText;
@end

@implementation SaleGoodServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [[UIColor alloc] initWithRed:128 green:138 blue:135 alpha:0.8];
    [self initView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void) initView{
    // 提交按钮
    UIBarButtonItem *submitItem=[[UIBarButtonItem alloc] initWithTitle: @"发送"style:UIBarButtonItemStylePlain target:self action:@selector(submitContent)];
    self.navigationItem.rightBarButtonItem = submitItem;
    // 设置距离父view的左右距离
    CGFloat leftOffet = 0;
    CGFloat rightOffet = 0;
    // 字体设置
    UIFont *systemFont = [UIFont systemFontOfSize:16];
    // 字体颜色设置
    UIColor *fontColor = [UIColor grayColor];
    // 标题
    UILabel *title = [[UILabel alloc] init];
    title.text = @"请正确填写您需要的商品或服务，不要夹带联系方式。（限80字内）";
    title.font = systemFont;
    title.textColor = fontColor;
    title.translatesAutoresizingMaskIntoConstraints = NO;
    // 让标签自动换行
    title.numberOfLines = 0;
    [title setLineBreakMode:NSLineBreakByWordWrapping];
    [self.view addSubview:title];
    // 添加约束
    //为title添加左，右，上和高约束
    [title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(leftOffet);
        make.right.equalTo(self.view.mas_right).with.offset(rightOffet);
        make.top.equalTo(self.view.mas_top).offset(65);
        make.height.mas_equalTo(@60);
    }];
    
    // 文本框
    self.buyText = [[UITextView alloc] init];
    self.buyText.font = [UIFont systemFontOfSize:16];
    self.buyText.textAlignment = NSTextAlignmentLeft;
    self.buyText.backgroundColor = [UIColor whiteColor];
    self.buyText.returnKeyType = UIReturnKeyDone;
    self.buyText.translatesAutoresizingMaskIntoConstraints = NO;
    self.buyText.delegate = self;
    [self.view addSubview:self.buyText];
    // 添加约束
    [self.buyText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(leftOffet);
        make.right.equalTo(self.view.mas_right).with.offset(rightOffet);
        make.top.equalTo(title.mas_bottom).offset(20);
        make.height.mas_equalTo(@200);
    }];
    
    // 商品或者服务输入框
    self.label = [[UILabel alloc] init];
    self.label.enabled = false;
    self.label.text = @"请输入您出售的商品或者服务";
    self.label.textColor = fontColor;
    self.label.font = systemFont;
    self.label.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.buyText.mas_left);
        make.top.equalTo(self.buyText.mas_top).with.offset(5);
        make.height.equalTo(@20);
    }];
    
    // 轻击键盘之外的空白区域关闭虚拟键盘
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]   initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    // 出售标题
    UILabel *saleLabel = [[UILabel alloc] init];
    saleLabel.text = @"我要出售的是";
    saleLabel.textColor = fontColor;
    saleLabel.font = systemFont;
    [self.view addSubview:saleLabel];
    [saleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).with.offset(leftOffet);
        make.top.equalTo(self.buyText.mas_bottom).with.offset(15);
        make.height.equalTo(@20);
    }];
    // segment
    NSArray *itemArry = [[NSArray alloc] initWithObjects:@"商品",@"服务",nil];
    UISegmentedControl *segment = [[UISegmentedControl alloc] initWithItems:itemArry];
    [self.view addSubview:segment];
    [segment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right).with.offset(rightOffet);
        make.top.equalTo(self.buyText.mas_bottom).with.offset(15);
        make.height.equalTo(@20);
    }];

    // 分享按钮
    UIButton *shareButton = [[UIButton alloc] init];
    [shareButton setTitle:@"QQ" forState:UIControlStateNormal];
    [shareButton sizeToFit];
    shareButton.backgroundColor = [UIColor blueColor];
    [shareButton addTarget:self action:@selector(shareContext) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:shareButton];
    [shareButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.view.mas_right);
        make.top.equalTo(self.buyText.mas_bottom).with.offset(45);
        make.height.equalTo(@20);
    }];
}
// 提交处理
-(void)submitContent {
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
// 分享处理
-(void)shareContext {
    //创建分享参数
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    [shareParams SSDKSetupShareParamsByText:@"分享内容 @value(url)"
                                     images:@[[UIImage imageNamed:@"shareImg"]]
                                        url:[NSURL URLWithString:@"http://mob.com"]
                                      title:@"分享标题"
                                       type:SSDKContentTypeImage];
    
    //进行分享
    [ShareSDK share:SSDKPlatformTypeSinaWeibo
         parameters:shareParams
     onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
         switch (state) {
             case SSDKResponseStateSuccess:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateFail:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                     message:[NSString stringWithFormat:@"%@", error]
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             case SSDKResponseStateCancel:
             {
                 UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                     message:nil
                                                                    delegate:nil
                                                           cancelButtonTitle:@"确定"
                                                           otherButtonTitles:nil];
                 [alertView show];
                 break;
             }
             default:
                 break;
         }
         
     }];
    
}
// 文本框开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView {
    self.label.text = @"";
    
}

// 文本框结束编辑
-(void)textViewDidEndEditing:(UITextView *)textView {
    if (textView.text.length == 0) {
        self.label.text = @"请输入您出售的商品或者服务";
    }
    
}
// 控制只能输入80字符
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if (range.location>=80)
    {
        //控制输入文本的长度
        return  NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    else {
        return YES;
    }
}

-(void)dismissKeyboard {
    [self.buyText resignFirstResponder];
}


@end
