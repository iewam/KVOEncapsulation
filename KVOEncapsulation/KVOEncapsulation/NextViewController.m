//
//  NextViewController.m
//  KVOEncapsulation
//
//  Created by Steven on 2018/6/7.
//  Copyright © 2018年 Steven. All rights reserved.
//

#import "NextViewController.h"
#import "Person.h"
#import "NSObject+STKVO.h"

@interface NextViewController ()

@end

@implementation NextViewController {
    Person *p;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor yellowColor];

    p = [Person new];
//    [p addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:nil];
    
    __weak typeof(self) wself = self;
    [p addSTObserver:self forKeyPath:@"name" kvoBlock:^(NSDictionary<NSKeyValueChangeKey,id> *change) {
        NSLog(@"block --- %@--%@", change, self);
    }];
    p.name = @"hhah";
}



//- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
//    if ([keyPath isEqualToString:@"name"]) {
//        NSLog(@"%@", change);
//    }
//}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    NSLog(@"%s", __func__);
}

@end
