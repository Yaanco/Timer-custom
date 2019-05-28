//
//  ViewController.m
//  Timer-custom
//
//  Created by Yaanco on 2019/5/13.
//  Copyright © 2019 Andy. All rights reserved.
//

#import "ViewController.h"
#import "YCTimer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"--begin--");
    [YCTimer excuteTask:^{
        NSLog(@"task - %@",[NSThread currentThread]);
    } start:2 interval:1 async:YES repeats:YES];
}


@end
