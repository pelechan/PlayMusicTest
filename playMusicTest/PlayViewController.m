//
//  PlayViewController.m
//  playMusicTest
//
//  Created by Pele Chan on 15/2/26.
//  Copyright (c) 2015年 Pele Chan. All rights reserved.
//

#import "PlayViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface PlayViewController ()
@property(nonatomic,strong)AVAudioPlayer *audioPlayer;
@property (strong, nonatomic) IBOutlet UIButton *playButton;

@property (strong, nonatomic) IBOutlet UILabel *currentimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;
@property (strong, nonatomic) IBOutlet UISlider *playSlider;
@property (strong, nonatomic) IBOutlet UISlider *voiceVolume;

@property int  playstate;
@property NSThread *playThread;
@property NSThread *progressViewThread;
@end

@implementation PlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.playstate=0;
//    self.playSlider=0;
    NSURL *url=[[NSBundle mainBundle]URLForResource:@"1.mp3" withExtension:Nil];
    
    //2.创建播放器（注意：一个AVAudioPlayer只能播放一个url）
    self.audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:Nil];
    
    //3.缓冲
    [self.audioPlayer prepareToPlay];
    NSLog(@"%f",self.audioPlayer.duration);
    self.totalTimeLabel.text=[self tranformTime:self.audioPlayer.duration];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be /Users/apple/Desktop/WORKPLACE/XCODE/playMusicTest/1.mp3recreated.
    
}
- (IBAction)playControl:(id)sender {
    //开始播放
    if(self.playstate==0){
        [self.playButton setTitle:@"暂停" forState:UIControlStateNormal];
        [self.audioPlayer play];
        self.playstate=1;
        //播放显示线程
        self.playThread = [[NSThread alloc]initWithTarget:self selector:@selector(playPro) object:nil];
        [self.playThread start];
        
    }
    //暂停播放

    else{
        [self.playButton setTitle:@"播放" forState:UIControlStateNormal];
        [self.audioPlayer pause];
        self.playstate=0;
        [self.playThread cancel];
    }
    NSLog(@"end");
    
}
-(void)changeProgress{
    self.currentimeLabel.text=[self tranformTime:self.audioPlayer.currentTime];
    self.playSlider.value=self.audioPlayer.currentTime/self.audioPlayer.duration;
}
-(void)playPro{
    while(self.playstate==1){
        NSLog(@"start");
        //播放进度线程
        self.progressViewThread = [[NSThread alloc]initWithTarget:self selector:@selector(changeProgress) object:nil];
        [self.progressViewThread start];
        sleep(1);
        [self.progressViewThread cancel];
    }
}
//将时间转化为00：00的形式
-(NSString *)tranformTime:(double) n{
    int minite = (int)n/60;
    int second = (int)n%60;
    NSString * time=[NSString stringWithFormat:@"%02d:%02d",minite,second];
    return time;
}
//拉动进度条改变播放进度
- (IBAction)sliderChange:(id)sender {
    [self.audioPlayer pause];
    self.audioPlayer.currentTime=self.playSlider.value*100*self.audioPlayer.duration/100;
//    NSLog(@"%f",self.audioPlayer.currentTime);
}

- (IBAction)sliderStartPlay:(id)sender {
    [self.audioPlayer play];
}
//改变声音大小
- (IBAction)changeVoice:(id)sender {
    self.audioPlayer.volume=self.voiceVolume.value;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
