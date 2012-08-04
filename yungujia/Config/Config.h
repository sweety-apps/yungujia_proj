//
//  Config.h
//  yungujia
//
//  Created by 波 徐 on 12-8-4.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface Config : NSObject

+(NSString*) getUsername;
+(void) saveUserName:(NSString*)username;
@end
