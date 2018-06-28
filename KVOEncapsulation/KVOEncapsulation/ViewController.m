//
//  ViewController.m
//  KVOEncapsulation
//
//  Created by Steven on 2018/6/7.
//  Copyright © 2018年 Steven. All rights reserved.
//

#import "ViewController.h"
#import "NextViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor lightGrayColor];


}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NextViewController *nextViewCtrl = [[NextViewController alloc] init];
    [self presentViewController:nextViewCtrl animated:YES completion:nil];
}


- (void)dealloc {
    
}


@end
