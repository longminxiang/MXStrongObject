//
//  TestObj.m
//  MXStrongObjectDemo
//
//  Created by longminxiang on 15/9/24.
//  Copyright © 2015年 eric. All rights reserved.
//

#import "TestObj.h"

@implementation TestObj

- (void)dealloc
{
    NSLog(@"%@: %@ dealloc", NSStringFromClass([self class]),  self.text);
}

@end
