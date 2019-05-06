//
//  LPPermanentThread.m
//  lpthread
//
//  Created by Lpkiki on 2019/4/29.
//  Copyright © 2019 kiki. All rights reserved.
//

#import "LPPermanentThread.h"


#pragma mark -------------- LPThread
@interface LPThread : NSThread
@end

@implementation LPThread
-(void)dealloc{
    NSLog(@"%s",__func__);
}
@end





@interface LPPermanentThread ()

@property (nonatomic,strong) LPThread *lpThread;

@property (nonatomic,assign,getter=isStopped) BOOL  stopped;

@end

@implementation LPPermanentThread

#pragma mark ---- public methods


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.stopped = NO ;
        __weak typeof(self) weakSelf = self ;
        
        self.lpThread = [[LPThread alloc]initWithBlock:^{
            
            [[NSRunLoop currentRunLoop]addPort:[[NSPort alloc]init] forMode:NSDefaultRunLoopMode];
            while (weakSelf && !weakSelf.stopped) {
                [[NSRunLoop currentRunLoop]runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]];
            }
            
        }];
//         [self.lpThread  start];
    }
    return self;
}


/// 开启一个线程
-(void)run {
    if (!self.lpThread)return;
    [self.lpThread start];
}


/// 执行一个任务
-(void)executeTask:(ThreadTask)task{
    
     if (!self.lpThread || !task )return;
    
    [self performSelector:@selector(__executeTask:) onThread:self.lpThread withObject:task waitUntilDone:NO];
    
}


///结束一个线程
-(void)stop{
    if (!self.lpThread)return;
    [self performSelector:@selector(__stop) onThread:self.lpThread withObject:nil waitUntilDone:YES];
}

#pragma mark ---- private methods

- (void)__stop {
    
    self.stopped = YES ;
    CFRunLoopStop(CFRunLoopGetCurrent());
    self.lpThread = nil ;
}


-(void)__executeTask:(ThreadTask)task {
    task();
}

-(void)dealloc{
    
    NSLog(@"%s",__func__);
    
    [self stop];
    
}
@end
