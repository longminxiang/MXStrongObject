//
//  ViewController.m
//  MXStrongObjectDemo
//
//  Created by longminxiang on 15/9/24.
//  Copyright © 2015年 eric. All rights reserved.
//

#import "ViewController.h"
#import "MXStrongObject.h"
#import "TestObj.h"

@interface ViewController ()

@property (nonatomic, strong) NSString *string;

@end

@implementation ViewController

static int _uid = 0;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 60)];
    button.center = self.view.center;
    [button setTitle:@"push" forState:UIControlStateNormal];
    [button setBackgroundColor:[UIColor brownColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(pushVC) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    TestObj *obj = [TestObj mx_initWithOwner:self];
    obj.text = [NSString stringWithFormat:@"obj %d", _uid++];
    
//    [self testDelayStrong:obj string:self.string block:^(TestObj *tobj) {
//        __MX_REMOVE(wobj);
//    }];
    [self testDelayStrong];
}

- (void)testStrong
{
    __MX_STRONG_ALLOC(TestObj, obj);
    obj.text = [NSString stringWithFormat:@"obj %d", _uid++];
    
    TestObj *subObj = [TestObj new];
    subObj.text = [NSString stringWithFormat:@"sub obj %d", _uid++];
    [obj mx_addStrongObject:subObj];
}

- (void)testDelayStrong
{
    TestObj *obj = [TestObj mx_initWithOwner:self];
    obj.text = [NSString stringWithFormat:@"obj %d", _uid++];
    
    __weak typeof(obj) wobj = obj;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [wobj mx_removeStrongObjectFromOwner];
    });
}

- (void)testDelayStrong:(TestObj *)obj string:(NSString *)string block:(void (^)(TestObj *tobj))block
{
    __MX_WEAK(obj, wobj);
    __block NSString *text = @"sss";
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        text = string;
        if (block) block(wobj);
    });
}

- (void)pushVC
{
    ViewController *vc = [ViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
}

@end
