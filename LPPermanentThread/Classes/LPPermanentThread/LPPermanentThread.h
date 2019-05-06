//
//  LPPermanentThread.h
//  lpthread
//
//  Created by Lpkiki on 2019/4/29.
//  Copyright © 2019 kiki. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ThreadTask)(void);


NS_ASSUME_NONNULL_BEGIN

@interface LPPermanentThread : NSObject


/// 开启一个线程
-(void)run ;


/// 执行一个任务
-(void)executeTask:(ThreadTask)task;


///结束一个线程
-(void)stop;

@end

NS_ASSUME_NONNULL_END
