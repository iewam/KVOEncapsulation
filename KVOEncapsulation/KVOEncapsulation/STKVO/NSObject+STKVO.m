//
//  NSObject+STKVO.m
//  KVOEncapsulation
//
//  Created by Steven on 2018/6/7.
//  Copyright © 2018年 Steven. All rights reserved.
//

#import "NSObject+STKVO.h"
#import <objc/runtime.h>

@interface NSObject ()

@property (nonatomic, strong) NSMutableDictionary *keyPathBlockDict;
@property (nonatomic, strong) NSMutableDictionary *keyPathObserverDict;

@end

@implementation NSObject (STKVO)

/// person 调用
- (void)addSTObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath kvoBlock:(kvoBlock)block {
    
    NSMutableArray *arr = self.keyPathObserverDict[keyPath];
    if (!arr) {
        arr = [[NSMutableArray alloc] init];
        self.keyPathObserverDict[keyPath] = arr;
    }
    [arr addObject:[NSValue valueWithNonretainedObject:observer]];
    
    
    NSString *key = [NSString stringWithFormat:@"%@%@", self, keyPath];
    [observer.keyPathBlockDict setValue:block forKey:key];
    
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(stDealloc)), class_getInstanceMethod([self class], NSSelectorFromString(@"dealloc")));
    });
    
    [self addObserver:observer forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:nil];
}

/// observer 调用
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    
    NSString *key = [NSString stringWithFormat:@"%@%@", object, keyPath];

    kvoBlock block = self.keyPathBlockDict[key];
    if (block) {
        block(change);
        block = nil;
    }
}

- (BOOL)isKVO {
    if (objc_getAssociatedObject(self, @selector(keyPathObserverDict))) {
        return YES;
    }
    return NO;
}

- (void)stDealloc {
    NSLog(@"%s", __func__);
    if ([self isKVO]) {
        for (NSString *key in self.keyPathObserverDict) {
            NSArray *observers = self.keyPathObserverDict[key];
            for (NSValue *observer in observers) {
                [self removeObserver:observer.nonretainedObjectValue forKeyPath:key];
            }
        }
    }
    [self stDealloc];
}


- (NSMutableDictionary *)keyPathBlockDict {
    NSMutableDictionary *tempDict = objc_getAssociatedObject(self, @selector(keyPathBlockDict));
    if (!tempDict) {
        tempDict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(keyPathBlockDict), tempDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tempDict;
}

- (NSMutableDictionary *)keyPathObserverDict {
    NSMutableDictionary *tempDict = objc_getAssociatedObject(self, @selector(keyPathObserverDict));
    if (!tempDict) {
        tempDict = [[NSMutableDictionary alloc] init];
        objc_setAssociatedObject(self, @selector(keyPathObserverDict), tempDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return tempDict;
}

@end
