//
//  FFmpegTool.m
//  XingObjc
//
//  Created by Xing on 2022/6/17.
//  Copyright © 2022 XingDemo. All rights reserved.
//

#import "FFmpegTool.h"

#import <mobileffmpeg/MobileFFmpegConfig.h>

@implementation FFmpegTool

+ (void)decode:(NSString *)fileUrl complete:(void(^)(NSString *resultFileUrl, FFFileType fileType, NSError *error))block{
        
    NSString *resultPath = fileUrl;
    FFFileType fileType = FFFileType_other;
    NSError *error;
    
    if([fileUrl.pathExtension isEqualToString:@"mov"]){
                
        NSString *fileName = [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970] * 1000];
        NSString *audioPath = [NSString stringWithFormat:@"%@/%@.aac", SANDBOX_caches, fileName];
        NSString *videoPath = [NSString stringWithFormat:@"%@/%@.h264", SANDBOX_caches, fileName];
        
                                
        int audioRc = [MobileFFmpeg execute: [NSString stringWithFormat:@"-i %@ -vn -c:a aac -q:a 5 -y %@", fileUrl, audioPath]];//分离音频流
        int videoRc = [MobileFFmpeg execute: [NSString stringWithFormat:@"-i %@ -vcodec copy -an %@", fileUrl, videoPath]];//分离视频流

        if (audioRc == RETURN_CODE_SUCCESS && videoRc == RETURN_CODE_SUCCESS) {
                          
            NSString *combinePath = [NSString stringWithFormat:@"%@/%@.mov", SANDBOX_caches, fileName];
            int madeRc = [MobileFFmpeg execute: [NSString stringWithFormat:@"-i %@ -i %@ -c:v copy -c:v copy -map 0:v:0 -map 1:a:0 -q:a 5 %@", fileUrl, audioPath, combinePath]];//替换原文件的音频流
            if(madeRc == RETURN_CODE_SUCCESS){
                resultPath = combinePath;
                fileType = FFFileType_video;
            }
        }else if(audioRc == RETURN_CODE_SUCCESS) {//只获取到音频流的转化为mp3
            
            NSString *combinePath = [NSString stringWithFormat:@"%@/%@.mp3", SANDBOX_caches, fileName];
            int madeRc = [MobileFFmpeg execute: [NSString stringWithFormat:@"-i %@ -acodec libmp3lame %@", audioPath, combinePath]];//aac转为mp3
            if (madeRc == RETURN_CODE_SUCCESS){
                resultPath = combinePath;
                fileType = FFFileType_audio;
            }
        }else{
            error = [NSError errorWithDomain:[MobileFFmpegConfig getLastCommandOutput] code:-1 userInfo:nil];
        }
    }
    if(block){
        block(resultPath, fileType, error);
    }
}

@end
