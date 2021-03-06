//
//  MXStrongObject.h
//  MXStrongObject
//
//  Created by longminxiang on 15/9/24.
//  Copyright © 2015年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>

#define __MX_STRONG(__obj) [self mx_addStrongObject:__obj]

#define __MX_REMOVE(__obj) [__obj mx_removeStrongObjectFromOwner]

#define __MX_STRONG_ALLOC(__cls, __obj) \
__cls *__obj = [__cls new]; \
__MX_STRONG(__obj)

#define __MX_WEAK(__obj, __weakObj) __weak typeof(__obj) __weakObj = __obj

#define __MX_STRONG_ALLOC_AND_WEAK(__cls, __obj, __weakObj) \
__MX_STRONG_ALLOC(__cls, __obj); \
__MX_WEAK(__obj, __weakObj);


@interface NSObject (MXStrongObjectOwner)

/**
 *  make an object strong;
 *  the object will not release unless his owner did release once call this function.
 *
 *  @param obj could be global or local value
 */
- (void)mx_addStrongObject:(id)obj;

/**
 *  remove an object from strong manager
 *
 *  @param obj object
 */
- (void)mx_removeStrongObject:(id)obj;

@end

@interface NSObject (MXStrongObject)

/**
 *  init with the owner
 */
+ (instancetype)mx_initWithOwner:(__weak id)owner;

/**
 *  remove self from owner's strong manager
 */
- (void)mx_removeStrongObjectFromOwner;

@end
