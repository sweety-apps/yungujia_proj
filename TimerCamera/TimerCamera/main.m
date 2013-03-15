//
//  main.m
//  TimerCamera
//
//  Created by lijinxin on 12-9-2.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

#if DEBUG
#define ENABLE_PRINT_STACK 1
#endif

int main(int argc, char *argv[])
{
    @autoreleasepool {
#if ENABLE_PRINT_STACK
        @try {
#endif
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
#if ENABLE_PRINT_STACK            
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
            NSLog(@"%@",[exception.callStackSymbols description]);
        }
        @finally {
            
        }
#endif
    }
    
    
        
    
}
