//
//  ViewController.m
//  MobileFFmpeg
//
//  Created by Xing on 2022/6/23.
//

#import "ViewController.h"

#import <AFNetworking/AFNetworking.h>
#import <SVProgressHUD/SVProgressHUD.h>

#import <AVKit/AVKit.h>
//#import <MobileVLCKit/MobileVLCKit.h>

#import "FFmpegTool.h"

@interface ViewController ()

@property(nonatomic, strong) AVPlayer *avPlayer;

//@property(nonatomic, strong) VLCMediaPlayer *player;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UIButton *audio = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [audio setTitle:@"▶️ 播放音频" forState:(UIControlStateNormal)];
    [audio setBackgroundColor:[UIColor lightGrayColor]];
    [audio setFrame:(CGRectMake(20, 50, 150, 50))];
    [audio addTarget:self action:@selector(clickAudio) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:audio];
    
    
    UIButton *video = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [video setTitle:@"▶️ 播放视频" forState:(UIControlStateNormal)];
    [video setBackgroundColor:[UIColor lightGrayColor]];
    [video setFrame:(CGRectMake(200, 50, 150, 50))];
    [video addTarget:self action:@selector(clickVideo) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:video];
}

- (void)clickAudio{
    
    NSString *movUrlA = @"https://www.deskpro.cn/cinccmedia/media/500508/ccrecord/20220523/3013A13676939490C20220523190538AC1303E101137953S20220523190538208057AC1303E101137909CCE.mov";
    
    [self downloadFileByUrl:movUrlA];
}

- (void)clickVideo{
    
    NSString *movUrlV = @"https://www.deskpro.cn/cinccmedia/media/500508/ccrecord/20220523/8926A18703970603C20220523182903AC1303E100126386S20220523182903059418AC1303E100126320CCE.mov";
    
    [self downloadFileByUrl:movUrlV];
}

- (void)downloadFileByUrl:(NSString *)url{
    
    NSString *saveFilePath = [SANDBOX_caches stringByAppendingPathComponent:url.lastPathComponent];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [SVProgressHUD showProgress:0 status:@"开始下载..."];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        [SVProgressHUD showProgress:downloadProgress.fractionCompleted status:@"下载中..."];
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL fileURLWithPath:saveFilePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [SVProgressHUD dismiss];
        if(!error){
                        
            
            [FFmpegTool decode:saveFilePath complete:^(NSString *resultFileUrl, FFFileType fileType, NSError *error) {
                NSLog(@"=======>   %@", resultFileUrl);
                
                if(fileType == FFFileType_audio){
                    //音频
                }else if(fileType == FFFileType_video){
                    //视频
                }else{
                    //非mov格式
                }
                
                
                
//                [self playVLCPlayByUrl:resultFileUrl];//VLC播放器
                
                [self playAVPlayByUrl:resultFileUrl];//原生框架播放
                
            }];
        }
    }];
     [downloadTask resume];
}


//- (void)playVLCPlayByUrl:(NSString *)filePath{
//    VLCMedia *media = [VLCMedia mediaWithPath:filePath];
//    self.player.media = media;
//    if(self.player.playing){
//        [self.player pause];
//    }
//    [self.player play];
//}
//
//- (VLCMediaPlayer *)player{
//    if(!_player){
//
//        UIView *playView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.frame.size.width, 200)];
//        playView.backgroundColor = [UIColor blackColor];
//        [self.view addSubview:playView];
//
//        VLCMediaPlayer  * player = [[VLCMediaPlayer alloc] init];
//        player.drawable = playView;
//        _player = player;
//    }
//    return _player;
//}

- (void)playAVPlayByUrl:(NSString *)filePath{
    NSURL *sourceMovieURL = [NSURL fileURLWithPath:filePath];
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceMovieURL options:nil];
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:movieAsset];
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.view.layer.bounds;
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    [self.view.layer addSublayer:playerLayer];
    [player play];
}


@end
