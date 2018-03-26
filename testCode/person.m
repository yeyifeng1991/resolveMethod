//
//  person.m
//  testCode
//
//  Created by YeYiFeng on 2018/3/26.
//  Copyright © 2018年 叶子. All rights reserved.
//

#import "person.h"
#import <objc/message.h> // 提供一些runtime方法
#import "newPerson.h"
@implementation person
/*
 系统提供方法
 + (BOOL)resolveClassMethod:(SEL)sel OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0); 类方法
 + (BOOL)resolveInstanceMethod:(SEL)sel; //对象方法
 */
#pragma mark -  方案1    动态解析，添加方法
//  Objective C 提供了一种名为动态方法决议的手段，使得我们可以在运行时动态地为一个 selector 提供实现
// 添加此方法，会运行到这里 1
/*
 + (BOOL)resolveInstanceMethod:(SEL)sel{
 NSLog(@"resolveInstanceMethod方法 sel = %@",NSStringFromSelector(sel));
 //判断没有实现方法, 那么我们就是动态添加一个方法
 //     if (sel == @selector(run)) {
 //     class_addMethod(self, sel, (IMP)newRun, "你好");
 //     return YES;
 //     }
 return [super resolveInstanceMethod:sel];
 }
 
 //动态添加的方法 添加时候会运行到这里，程序不会crash 2
 void newRun(id self,SEL sel,NSString *str) {
 NSLog(@"动态添加的方法---runok---%@",str);
 }

 */


/*
 系统提供方法
 // 消息转发
 - (id)forwardingTargetForSelector:(SEL)aSelector OBJC_AVAILABLE(10.5, 2.0, 9.0, 1.0, 2.0);
 // 标准的消息转发
 - (void)forwardInvocation:(NSInvocation *)anInvocation OBJC_SWIFT_UNAVAILABLE("");
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE("");
 */

#pragma mark - 方案2    消息转发重定向
// 需要在转发的类中，实现同样的方法
/*
 - (id)forwardingTargetForSelector:(SEL)aSelector
 {
 NSLog(@"aSelector -- %@",NSStringFromSelector(aSelector));
 //    return [super forwardingTargetForSelector:aSelector];
 return [[newPerson alloc]init];
 }
 */

#pragma mark - 方案3    生成方法签名转发消息

 // 3.1 生成方法签名
 - (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector OBJC_SWIFT_UNAVAILABLE("");
 {
 // 转换字符
 NSString * sel = NSStringFromSelector(aSelector);
 // 判断，手动生成签名
 if([sel isEqualToString:@"run"])
 {
 return  [NSMethodSignature signatureWithObjCTypes:"v@:"];
 }
 else
 {
 return [super methodSignatureForSelector:aSelector];
 }
 
 }
 
 // 3.2 拿到消息转发签名
 -(void)forwardInvocation:(NSInvocation *)anInvocation
 {
 
 // 取到消息
 SEL seletor = [anInvocation selector];
 // 转发
 newPerson * newP = [[newPerson alloc]init];
 if ([newP respondsToSelector:seletor]) //判断是否实现
 {
 // 调用消息 进行转发
 return [anInvocation invokeWithTarget:newP];
 }
 else
 {
 // 拿到签名
 return [super forwardInvocation:anInvocation];
 }
 
 }


// 3.3 抛出异常 假如我们转发的类中没有run方法，可以在这里进行一些抛出异常的操作  生成崩溃日志 或者 进行弹框提示
 // 实现此方法，系统会直接crash到调用方法的崩溃位置
-(void)doesNotRecognizeSelector:(SEL)aSelector
{
    NSString * seletor = NSStringFromSelector(aSelector);
    NSLog(@"您调用的方法不存在%@",seletor);
}


@end
