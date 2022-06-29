//
//  FFmpegTool.h
//  XingObjc
//
//  Created by Xing on 2022/6/17.
//  Copyright © 2022 XingDemo. All rights reserved.
//

#import <Foundation/Foundation.h>

#define SANDBOX_caches  (NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject)

typedef NS_ENUM(NSUInteger, FFFileType) {
    FFFileType_other = 0,
    FFFileType_audio,
    FFFileType_video,
};

@interface FFmpegTool : NSObject

///resultUrl: 沙盒地址fileurl
+ (void)decode:(NSString *)fileUrl complete:(void(^)(NSString *resultFileUrl, FFFileType fileType, NSError *error))block;

@end
