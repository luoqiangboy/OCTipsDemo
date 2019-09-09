//
//  ViewController.m
//  OCTipsDemo
//
//  Created by Mini-LuoQiang on 2018/12/28.
//  Copyright © 2018年 Sniper. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewWillAppear:(BOOL)animated {
    NSLog(@"2");
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    
    UIButton *btn1 = [[UIButton alloc] init];
    btn1.backgroundColor = [UIColor redColor];
    [btn1 addTarget:self action:@selector(test1) forControlEvents:UIControlEventTouchUpInside];
    btn1.frame = CGRectMake(30, 100, 100, 30);
    [self.view addSubview:btn1];
    
    UIButton *btn2 = [[UIButton alloc] init];
    btn2.backgroundColor = [UIColor redColor];
    [btn2 addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
    btn2.frame = CGRectMake(30, 200, 100, 30);
    [self.view addSubview:btn2];
    
}

- (void)test1 {
    dispatch_queue_t queue = dispatch_queue_create("com.octips", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务1 开始");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"任务1 结束");
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务2 开始");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"任务2 结束");
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务1，任务2 都完成了");
    });
}


- (void)test2 {
    dispatch_queue_t queue = dispatch_queue_create("com.octips", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_t group = dispatch_group_create();
    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务1 开始");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"任务1 结束");
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
        
        NSLog(@"任务2 开始");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"任务2 结束");
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_async(group, queue, ^{
        NSLog(@"任务3 开始");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"任务3 结束");
            dispatch_semaphore_signal(sem);
        });
        dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
    });
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        NSLog(@"任务1，任务2，任务3 都完成了");
    });
}



@end
