//
//  BuyGoodServiceViewController.m
//  businessNeed
//
//  Created by 黄剛 on 2015/08/22.
//  Copyright (c) 2015年 黄剛. All rights reserved.
//

#import "BuyGoodServiceViewController.h"
#import "Masonry.h"


@interface BuyGoodServiceViewController ()
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) UITextView *buyText;
@end

@implementation BuyGoodServiceViewController

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
