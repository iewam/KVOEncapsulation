//
//  NSObject+STKVO.h
//  KVOEncapsulation
//
//  Created by Steven on 2018/6/7.
//  Copyright © 2018年 Steven. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^kvoBlock)(NSDictionary<NSKeyValueChangeKey,id> * change);

@interface NSObject (STKVO)

- (void)addSTObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath kvoBlock:(kvoBlock)block;

@end
