//
//  ZSNScreenShareViewController.m
//  ZSNDemoScreenShare
//
//  Created by zhaosuning on 2023/5/17.
//

#import "ZSNScreenShareViewController.h"
#import <AgoraRtcKit/AgoraRtcEngineKit.h>
#import <ReplayKit/ReplayKit.h>


@interface ZSNScreenShareViewController ()<AgoraRtcEngineDelegate>

@property (nonatomic, strong) AgoraRtcEngineKit * agoraKit;
@property (nonatomic, strong) AgoraRtcChannelMediaOptions *options;

@property (nonatomic, strong) UIView * localView;
@property (nonatomic, strong) UIView * remoteView;

@property (nonatomic, strong) RPSystemBroadcastPickerView * systemBroadcastPicker;

@end

@implementation ZSNScreenShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.contentSize = CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height + 200);
    [self.view addSubview:scrollView];
    
    UIView *viewbg = [[UIView alloc] init];
    viewbg.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height + 200);
    viewbg.backgroundColor = [UIColor whiteColor];
    [scrollView addSubview:viewbg];
    
    UILabel * lblTopTitle = [[UILabel alloc] init];
    lblTopTitle.frame = CGRectMake([[UIScreen mainScreen] bounds].size.width / 2.0 - 50, 45, 100, 40);
    lblTopTitle.text = @"接口调用";
    lblTopTitle.textColor = [UIColor blueColor];
    lblTopTitle.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:lblTopTitle];
    
    //UIButton 初始化建议用buttonWithType
    UIButton *btnBack = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBack.frame = CGRectMake(0 , 45, 70, 40);
    [btnBack setTitle:@"返回" forState:UIControlStateNormal];
    [btnBack setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnBack.backgroundColor = [UIColor greenColor];
    btnBack.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btnBack.layer setCornerRadius:20];
    [btnBack.layer setMasksToBounds:YES];
    [btnBack addTarget:self action:@selector(btnBackAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btnBack];
    
    
    self.localView = [[UIView alloc] init];
    self.localView.backgroundColor = [UIColor lightGrayColor];
    //self.localView.frame = CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height);
    self.localView.frame = CGRectMake(0, 100, 200, 200);
    [viewbg addSubview:self.localView];
    
    self.remoteView = [[UIView alloc] init];
    self.remoteView.backgroundColor = [UIColor grayColor];
    //self.remoteView.frame = CGRectMake(0, [[UIScreen mainScreen] bounds].size.width + 100, 200, 200);
    self.remoteView.frame = CGRectMake(0, 320, 200, 200);
    [viewbg addSubview:self.remoteView];
    
    UIButton *btnInitRtcEngine = [UIButton buttonWithType:UIButtonTypeCustom];
    btnInitRtcEngine.frame = CGRectMake(0, 90, 140, 40);
    [btnInitRtcEngine setTitle:@"初始化RtcEngine" forState:UIControlStateNormal];
    [btnInitRtcEngine setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnInitRtcEngine.backgroundColor = [UIColor greenColor];
    btnInitRtcEngine.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btnInitRtcEngine addTarget:self action:@selector(btnInitRtcEngineAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewbg addSubview:btnInitRtcEngine];
    
    UIButton *btnJoinChannel = [UIButton buttonWithType:UIButtonTypeCustom];
    btnJoinChannel.frame = CGRectMake(0, 140, 70, 40);
    [btnJoinChannel setTitle:@"加入频道" forState:UIControlStateNormal];
    [btnJoinChannel setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnJoinChannel.backgroundColor = [UIColor greenColor];
    btnJoinChannel.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btnJoinChannel addTarget:self action:@selector(btnJoinChannelAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewbg addSubview:btnJoinChannel];
    
    UIButton *btnStartScreenShare = [UIButton buttonWithType:UIButtonTypeCustom];
    btnStartScreenShare.frame = CGRectMake(0, 190, 70, 40);
    [btnStartScreenShare setTitle:@"StartScreenShare" forState:UIControlStateNormal];
    [btnStartScreenShare setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    btnStartScreenShare.backgroundColor = [UIColor greenColor];
    btnStartScreenShare.titleLabel.font = [UIFont systemFontOfSize:17.0];
    [btnStartScreenShare addTarget:self action:@selector(btnStartScreenShareAction:) forControlEvents:UIControlEventTouchUpInside];
    [viewbg addSubview:btnStartScreenShare];
    
}

-(void) viewWillDisappear:(BOOL)animated {
    [AgoraRtcEngineKit destroy];
}

-(void)showLocalVideo {
    AgoraRtcVideoCanvas * videoCanvas = [[AgoraRtcVideoCanvas alloc] init];
    videoCanvas.uid = 0;
    videoCanvas.view = self.localView;
    //videoCanvas.renderMode = AgoraVideoRenderModeHidden;//AgoraVideoRenderModeHidden
    videoCanvas.renderMode = AgoraVideoRenderModeFit;
    [self.agoraKit setupLocalVideo:videoCanvas];
    [self.agoraKit startPreview];
}

-(void)showRemoteVideo:(NSInteger) uid {
    AgoraRtcVideoCanvas *remoteVideo = [[AgoraRtcVideoCanvas alloc] init];
    remoteVideo.uid = uid;
    remoteVideo.view = self.remoteView;
    //remoteVideo.renderMode = AgoraVideoRenderModeHidden;
    remoteVideo.renderMode = AgoraVideoRenderModeFit;
    [self.agoraKit setupRemoteVideo:remoteVideo];
    
    
}

-(void) initAgoraRtcInfo {
    AgoraRtcEngineConfig * config = [[AgoraRtcEngineConfig alloc] init];
    config.appId = AppId;
    config.channelProfile = AgoraChannelProfileLiveBroadcasting;
    self.agoraKit = [AgoraRtcEngineKit sharedEngineWithConfig:config delegate:self];
    [self.agoraKit setClientRole:AgoraClientRoleBroadcaster];
    [self.agoraKit setDefaultAudioRouteToSpeakerphone:YES];
    
    [self.agoraKit setAudioProfile:AgoraAudioProfileMusicHighQuality];
    [self.agoraKit setAudioScenario:AgoraAudioScenarioGameStreaming];
    
    [self.agoraKit enableAudio];
    [self.agoraKit enableVideo];
    
    //AgoraVideoOutputOrientationMode
    //AgoraVideoMirrorMode
    
    AgoraVideoEncoderConfiguration *videoConfig = [[AgoraVideoEncoderConfiguration alloc] initWithWidth:720 height:1280 frameRate:AgoraVideoFrameRateFps15 bitrate:AgoraVideoBitrateStandard orientationMode:AgoraVideoOutputOrientationModeAdaptative mirrorMode:AgoraVideoMirrorModeAuto];
    [self.agoraKit setVideoEncoderConfiguration:videoConfig];
    
}

-(void)prepareSystemBroadcaster {
    self.systemBroadcastPicker = [[RPSystemBroadcastPickerView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
    self.systemBroadcastPicker.showsMicrophoneButton = NO;
    self.systemBroadcastPicker.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
    //self.systemBroadcastPicker.preferredExtension = [NSString stringWithFormat:@"%@.ZSN-ScreenShare-Extension",[[NSBundle mainBundle] bundleIdentifier]];
    
    self.systemBroadcastPicker.preferredExtension = @"com.test.lianxi.ZSNDemoScreenShare.ZSNScreenShareExtension";
    
    [self.remoteView addSubview:self.systemBroadcastPicker];
}

-(void)btnBackAction:(UIButton *) button {
    NSLog(@"打印了 点击返回btnBackAction");
    
    __weak typeof(self) weakSelf = self;
    
    [self.agoraKit leaveChannel:^(AgoraChannelStats * _Nonnull stat) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];
}

-(void)btnInitRtcEngineAction :(UIButton *) button {
    NSLog(@"打印了 点击了 btnJoinChannelAction");
    
    [self initAgoraRtcInfo];
}

-(void)btnJoinChannelAction:(UIButton *) button {
    //AgoraRtcChannelMediaOptions *options = [[AgoraRtcChannelMediaOptions alloc] init];
//    options.clientRoleType = AgoraClientRoleBroadcaster;
//    options.publishCameraTrack = YES;
//    options.publishMicrophoneTrack = YES;
    self.options.clientRoleType = AgoraClientRoleBroadcaster;
    self.options.publishCameraTrack = YES;
    self.options.publishMicrophoneTrack = YES;
    NSInteger result = [self.agoraKit joinChannelByToken:Token channelId:channelname uid:0 mediaOptions:self.options joinSuccess:nil];
    
    NSLog(@"打印了 joinChannelByToken result值 %ld",(long)result);
    
}

-(void) btnStartScreenShareAction:(UIButton *)buttoon {
    NSLog(@"打印了 点击了 btnStartScreenShareAction");
    
    //AgoraScreenCaptureParameters2
    
    AgoraScreenCaptureParameters2 *parameters = [[AgoraScreenCaptureParameters2 alloc] init];
    parameters.captureVideo = YES;
    parameters.captureAudio = YES;//屏幕共享时是否采集系统音频,（默认 NO）不采集系统音频。
    
    AgoraScreenAudioParameters * audioParams = [[AgoraScreenAudioParameters alloc] init];
    audioParams.captureSignalVolume = 50;//采集的系统音量。取值范围为 [0,100]。默认值为 100。
    parameters.audioParams = audioParams;//共享屏幕流的音频配置,仅在 captureAudio 为 YES 时生效
    
    AgoraScreenVideoParameters *videoParams = [[AgoraScreenVideoParameters alloc] init];
    
    CGSize boundingSize = CGSizeMake(540, 960);
    CGFloat mW = boundingSize.width / [[UIScreen mainScreen] bounds].size.width;
    CGFloat mH = boundingSize.height / [[UIScreen mainScreen] bounds].size.height;
    if(mH < mW) {
        boundingSize.width = boundingSize.height / [[UIScreen mainScreen] bounds].size.height * [[UIScreen mainScreen] bounds].size.width;
    }
    else if (mW < mH) {
        boundingSize.height = boundingSize.width / [[UIScreen mainScreen] bounds].size.width * [[UIScreen mainScreen] bounds].size.height;
    }
    
    videoParams.dimensions = boundingSize;
    videoParams.frameRate = AgoraVideoFrameRateFps30;
    videoParams.bitrate = AgoraVideoBitrateStandard;
    parameters.videoParams = videoParams;
    
    [self.agoraKit startScreenCapture:parameters];
    [self prepareSystemBroadcaster];
    
    for (UIView *subView in self.systemBroadcastPicker.subviews) {
        if([subView isKindOfClass:[UIButton class]]) {
            [(UIButton *)subView sendActionsForControlEvents:UIControlEventAllEvents];
            break;
        }
    }
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinChannel:(NSString *)channel withUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self showLocalVideo];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine didJoinedOfUid:(NSUInteger)uid elapsed:(NSInteger)elapsed {
    [self showRemoteVideo:uid];
}

- (void)rtcEngine:(AgoraRtcEngineKit *)engine localVideoStateChangedOfState:(AgoraVideoLocalState)state error:(AgoraLocalVideoStreamError)error sourceType:(AgoraVideoSourceType)sourceType {
    NSLog(@"打印了 localVideoStateChangedOfState 本地视频状态发生改变回调");
    if(state == AgoraVideoLocalStateCapturing && sourceType == AgoraVideoSourceTypeScreen) {
        NSLog(@"打印了 AgoraVideoLocalStateCapturing AgoraVideoSourceTypeScreen");
        AgoraRtcChannelMediaOptions *option = [[AgoraRtcChannelMediaOptions alloc] init];
        option.clientRoleType = AgoraClientRoleBroadcaster;
        option.publishCameraTrack = NO;
        option.publishScreenCaptureVideo = YES;
        option.publishScreenCaptureAudio = YES;
        [self.agoraKit updateChannelWithMediaOptions:option];
    }
    
}


@end
