//
//  MXStrongObject.m
//  MXStrongObject
//
//  Created by longminxiang on 15/9/24.
//  Copyright © 2015年 eric. All rights reserved.
//

#import "MXStrongObject.h"
#import <objc/runtime.h>

void mx_strong_object_class_swizzleMethodAndStore(Class class, SEL originalSelector, SEL swizzledSelector)
{
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    BOOL success = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (success) {
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}

#pragma mark
#pragma mark === MXStrongObject ===

@interface NSObject (MXStrong)

@property (nonatomic, strong) NSMutableArray *mx_strongObjects;
@property (nonatomic, weak) NSObject *mx_owner;

@end

@implementation NSObject (MXStrong)

- (NSMutableArray *)mx_strongObjects
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMx_strongObjects:(NSMutableArray *)mx_strongObjects
{
    objc_setAssociatedObject(self, @selector(mx_strongObjects), mx_strongObjects, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSObject *)mx_owner
{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setMx_owner:(NSObject *)mx_owner
{
    objc_setAssociatedObject(self, @selector(mx_owner), mx_owner, OBJC_ASSOCIATION_ASSIGN);
}

@end

@implementation NSObject (MXStrongObjectOwner)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        mx_strong_object_class_swizzleMethodAndStore(self, NSSelectorFromString(@"dealloc"), @selector(mx_strong_object_dealloc));
    });
}


- (void)mx_addStrongObject:(id)obj
{
    if (!obj) return;
    if (!self.mx_strongObjects) {
        self.mx_strongObjects = [NSMutableArray new];
    }
    else if ([self.mx_strongObjects containsObject:obj]) {
        return;
    }
    [obj setMx_owner:self];
    [self.mx_strongObjects addObject:obj];
}

- (void)mx_removeStrongObject:(id)obj
{
    if (!obj) return;
    if (![self.mx_strongObjects containsObject:obj]) return;
    [self.mx_strongObjects removeObject:obj];
}

- (void)mx_strong_object_dealloc
{
    for (NSObject *obj in self.mx_strongObjects) {
        obj.mx_owner = nil;
    }
    [self mx_strong_object_dealloc];
}

@end

@implementation NSObject (MXStrongObject)

+ (instancetype)mx_initWithOwner:(__weak id)owner
{
    id obj = [self new];
    [owner mx_addStrongObject:obj];
    return obj;
}

- (void)mx_removeStrongObjectFromOwner
{
    [self.mx_owner mx_removeStrongObject:self];
}

@end
