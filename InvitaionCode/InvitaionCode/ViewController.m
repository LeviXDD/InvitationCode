//
//  ViewController.m
//  InvitaionCode
//
//  Created by 海涛 黎 on 16/4/16.
//  Copyright © 2016年 Levi. All rights reserved.
//
/*
# InvitationCode
主要目的是将用填写的邀请码自动转换为大写字母，方便用户使用。

思路：
1.创建一个textfield用于记录用户输入的数据，但是此textfield应放在一个用户看不到的地方。

2.通过拼接六个label并加上手势事件来让textfield成为第一响应者。

3.通过textfield的代理事件来自动逐个将textfield中的字母用ASC II来全部转换为大写。

整体思路很简单，但是当时做的时候在删除第一个字母的时候有点小问题，在输入第一个字母的时候会闪烁一下，当时为了赶快完成需求，也没有去追求这些细节。
今天只是突然想起来，把这个上传上来，代码稍微有些混乱，如有幸我的这段代码被人阅读，还望见谅。
 */

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate,UIAlertViewDelegate>{
    CGFloat widthHeight;
    CGFloat y;
    CGFloat padding;
    CGFloat startY;
}
@property (nonatomic,strong) UITextField *a;
@property (nonatomic,strong) UITextField *b;
@property (nonatomic,strong) UITextField *c;
@property (nonatomic,strong) UITextField *d;
@property (nonatomic,strong) UITextField *e;
@property (nonatomic,strong) UITextField *f;
@property (nonatomic,strong) UITextField *t;
@property (nonatomic,strong) UIButton *submitButton;
@end

@implementation ViewController
-(instancetype)init{
    self = [super init];
    if(self){
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self textFieldBecomFirstResponder];
    _t.text = @"";
    [self clearInvitationCode];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor redColor],
                                                                    NSFontAttributeName : [UIFont boldSystemFontOfSize:17]};
   startY = 80;
    widthHeight = self.view.frame.size.width/6;
    [self createLabel];
    [self createCheckCodeView];
    
    [self createSaveStringTextField];
    [self createCompleteButton];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFieldInEditing:) name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - UI
-(void)createLabel{
    padding = 15;
    UILabel *lab = [[UILabel alloc]init];
    lab.text = @"请输入或扫描一段邀请码";
    lab.textAlignment = NSTextAlignmentCenter;
    lab.font = [UIFont systemFontOfSize:12];
    lab.textColor = [UIColor lightGrayColor];
    [lab sizeToFit];
    lab.center = CGPointMake(self.view.frame.size.width/2,startY + padding + lab.frame.size.height/2);
    [self.view addSubview:lab];
    y = lab.frame.origin.y + lab.frame.size.height + padding;
}

-(void)createCheckCodeView{
    _a = [self textFieldWithNum:0];
    _b = [self textFieldWithNum:1];
    _c = [self textFieldWithNum:2];
    _d = [self textFieldWithNum:3];
    _e = [self textFieldWithNum:4];
    _f = [self textFieldWithNum:5];
    [_a.inputView becomeFirstResponder];
    [self.view addSubview:_a];
    [self.view addSubview:_b];
    [self.view addSubview:_c];
    [self.view addSubview:_d];
    [self.view addSubview:_e];
    [self.view addSubview:_f];
}

-(void)createSaveStringTextField{
    _t = [[UITextField alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, -1000, 0, 0)];
    _t.delegate = self;
    [self.view addSubview:_t];
    _t.keyboardType = UIKeyboardTypeASCIICapable;
}

-(void)createCompleteButton{
    _submitButton = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat btnSidePadding = 15;
    [_submitButton setFrame:CGRectMake(btnSidePadding, padding + y + widthHeight, self.view.frame.size.width - btnSidePadding*2, 45)];
    [_submitButton setTitle:@"提交" forState:UIControlStateNormal];
    [_submitButton setBackgroundColor:[UIColor lightGrayColor]];
    [_submitButton setEnabled:NO];
    [_submitButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_submitButton.titleLabel setFont:[UIFont systemFontOfSize:17]];
    _submitButton.layer.cornerRadius = 5.0;
    [self.view addSubview:_submitButton];
}

#pragma mark UITextFieldTextDidChangeNotification
- (void)textFieldInEditing:(NSNotification *)textField{
    if (_t.text == nil || [_t.text isEqualToString:@""]) {}
    else{
        NSString *str = _t.text;
        [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        str = [str stringByReplacingOccurrencesOfString:@" " withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"\n" withString:@""];
        _t.text = str;
        switch (str.length) {
            case 0:
                _a.text = @"";
                _b.text = @"";
                _c.text = @"";
                _d.text = @"";
                _e.text = @"";
                _f.text = @"";
                [_submitButton setBackgroundColor:[UIColor lightGrayColor]];
                [_submitButton setEnabled:NO];
                break;
                
            case 1:
                _a.text = [self charToAscII:[str substringWithRange:NSMakeRange(0, 1)]];
                _b.text = @"";
                _c.text = @"";
                _d.text = @"";
                _e.text = @"";
                _f.text = @"";
                [_submitButton setBackgroundColor:[UIColor lightGrayColor]];
                [_submitButton setEnabled:NO];
                break;
                
            case 2:
                _a.text = [self charToAscII:[str substringWithRange:NSMakeRange(0, 1)]];
                _b.text = [self charToAscII:[str substringWithRange:NSMakeRange(1, 1)]];
                _c.text = @"";
                _d.text = @"";
                _e.text = @"";
                _f.text = @"";
                [_submitButton setBackgroundColor:[UIColor lightGrayColor]];
                [_submitButton setEnabled:NO];
                break;
                
            case 3:
                _a.text = [self charToAscII:[str substringWithRange:NSMakeRange(0, 1)]];
                _b.text = [self charToAscII:[str substringWithRange:NSMakeRange(1, 1)]];
                _c.text = [self charToAscII:[str substringWithRange:NSMakeRange(2, 1)]];
                _d.text = @"";
                _e.text = @"";
                _f.text = @"";
                [_submitButton setBackgroundColor:[UIColor lightGrayColor]];
                [_submitButton setEnabled:NO];
                break;
                
            case 4:
                _a.text = [self charToAscII:[str substringWithRange:NSMakeRange(0, 1)]];
                _b.text = [self charToAscII:[str substringWithRange:NSMakeRange(1, 1)]];
                _c.text = [self charToAscII:[str substringWithRange:NSMakeRange(2, 1)]];
                _d.text = [self charToAscII:[str substringWithRange:NSMakeRange(3, 1)]];
                _e.text = @"";
                _f.text = @"";
                [_submitButton setBackgroundColor:[UIColor lightGrayColor]];
                [_submitButton setEnabled:NO];
                break;
                
            case 5:
                _a.text = [self charToAscII:[str substringWithRange:NSMakeRange(0, 1)]];
                _b.text = [self charToAscII:[str substringWithRange:NSMakeRange(1, 1)]];
                _c.text = [self charToAscII:[str substringWithRange:NSMakeRange(2, 1)]];
                _d.text = [self charToAscII:[str substringWithRange:NSMakeRange(3, 1)]];
                _e.text = [self charToAscII:[str substringWithRange:NSMakeRange(4, 1)]];
                _f.text = @"";
                [_submitButton setBackgroundColor:[UIColor lightGrayColor]];
                [_submitButton setEnabled:NO];
                break;
                
            case 6:
                _a.text = [self charToAscII:[str substringWithRange:NSMakeRange(0, 1)]];
                _b.text = [self charToAscII:[str substringWithRange:NSMakeRange(1, 1)]];
                _c.text = [self charToAscII:[str substringWithRange:NSMakeRange(2, 1)]];
                _d.text = [self charToAscII:[str substringWithRange:NSMakeRange(3, 1)]];
                _e.text = [self charToAscII:[str substringWithRange:NSMakeRange(4, 1)]];
                _f.text = [self charToAscII:[str substringWithRange:NSMakeRange(5, 1)]];
                [_t resignFirstResponder];
                [_submitButton setBackgroundColor:[UIColor redColor]];
                [_submitButton setEnabled:YES];
                NSLog(@"%@%@%@%@%@%@",_a.text,_b.text,_c.text,_d.text,_e.text,_f.text);
                break;
                
            default:
                break;
        }
    }
}

-(void)textFieldChangeToAscIIAtIndex:(NSInteger)index withString:(NSString*)str isEnableButton:(BOOL)isEnable{
    for (int i = 0; i<6; i++) {
        UITextField *tf = [self.view viewWithTag:i];
        if (i>index) {
            tf.text = @"";
        } else{
            tf.text = [self charToAscII:[str substringWithRange:NSMakeRange(i, 1)]];
        }
    }
    
    if (isEnable) {
        [_submitButton setBackgroundColor:[UIColor redColor]];
        [_submitButton setEnabled:YES];
    }else {
        [_submitButton setBackgroundColor:[UIColor lightGrayColor]];
        [_submitButton setEnabled:NO];
    }
}

#pragma mark UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (_t.text.length == 1) {
        _a.text = @"";
    }
    return YES;
}

#pragma mark - Util
-(NSString*)charToAscII:(NSString*)c{
    int asciiCode = [c characterAtIndex:0];
    if (asciiCode>=96) {
        asciiCode = asciiCode - 32;
    }
    NSString *string = [NSString stringWithFormat:@"%c", asciiCode];
    return string;
}

-(UITextField*)textFieldWithNum:(int)number{
    UITextField *text = [[UITextField alloc]init];
    text.frame = CGRectMake(widthHeight*number, y, widthHeight, widthHeight);
    text.layer.borderWidth = 0.5;
    text.layer.borderColor = [UIColor lightGrayColor].CGColor;
    text.font = [UIFont systemFontOfSize:23];
    text.textAlignment = NSTextAlignmentCenter;
    text.tag = number;
    text.enabled = NO;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundColor:[UIColor clearColor]];
    [btn setFrame:text.frame];
    [btn addTarget:self action:@selector(textFieldBecomFirstResponder) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    return text;
}

-(void)textFieldBecomFirstResponder{
    NSString *str = [NSString stringWithFormat:@"%@%@%@%@%@%@",_a.text,_b.text,_c.text,_d.text,_e.text,_f.text];
    _t.text = str;
    NSLog(@"str:   %@",_t.text);
    if (![_t isFirstResponder]) {
        [_t becomeFirstResponder];
    }
}

-(void)clearInvitationCode{
    _a.text = @"";
    _b.text = @"";
    _c.text = @"";
    _d.text = @"";
    _e.text = @"";
    _f.text = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end

