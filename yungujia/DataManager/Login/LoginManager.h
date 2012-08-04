//
//  LoginManager.h
//  yungujia
//
//  Created by 波 徐 on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHttpRequest.h"
@interface LoginManager : NSObject
<ASIHTTPRequestDelegate>
+ (id)shareInstance;
-(BOOL)login:(NSString*)username password:(NSString*)password;
@end
