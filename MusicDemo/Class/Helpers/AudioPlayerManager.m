//
//  AudioPlayerManager.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/23.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import "AudioPlayerManager.h"
#import "LyricModel.h"

//@import 只能引入系统的库 也就是带<>
@import AVFoundation;

//延展
@interface AudioPlayerManager ()
//为了写属性
@property(nonatomic,strong)AVPlayer *player;
@property (nonatomic, strong) NSTimer *timer;

@property(nonatomic,strong)NSMutableArray *lyricArray;//存储歌词的数组

@end

@implementation AudioPlayerManager


+(AudioPlayerManager *)sharedManager
{
    static AudioPlayerManager *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        audioManager = [[AudioPlayerManager alloc]init];
    });
    return audioManager;
}


- (instancetype)init{
    
    self = [super init];
    
    if (self) {
        
        self.player = [AVPlayer new];
        
        //通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(playMusicEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
        
        
    }
    
    return self;
}

//播放音乐结束
- (void)playMusicEnd{
    
    if (_delegate && [_delegate respondsToSelector:@selector(audioPlayToEnd)]) {
        
        [_delegate audioPlayToEnd];
    }
    
}


//准备播放
- (void)prepareMusic{
    
    //如果已经有了观察者 需要移除观察者
    if (self.player.currentItem) {
        
        [self.player.currentItem removeObserver:self forKeyPath:@"status"];
    }
    
    //初始化item
    AVPlayerItem *item = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:self.model.mp3Url]];
    
    //item添加观察者
    [item addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    //把当前的item替换成 我们自定义的item
    [self.player replaceCurrentItemWithPlayerItem:item];
    
    
}

//观察者的方法
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"status"]) {
        
        //通过key拿到对象 然后用status接收
        AVPlayerItemStatus status = [[change valueForKey:@"new"] integerValue];
        
        switch (status) {
            case 0:{
                NSLog(@"未知");
                break;
            }
                
            case 1:{
                
                [self playMusic];
                break;
            }
            case 2:{
                
                NSLog(@"失败");
                break;
            }
                
            default:
                break;
        }
    }
}


//播放
-(void)playMusic{
    
    self.isPlaying = YES;
    
    if (self.timer == nil) {
        
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        

        
//        return;
    }
    
    [self.player play];
    
    
}
//NSTimer 的方法
-(void)timerAction{
    
    //判断
    if (_delegate && [_delegate respondsToSelector:@selector(getCurrentTime:TotalTime:Progress:)]) {
        
        [_delegate getCurrentTime:[self transformWith:[self currentTimeValue]] TotalTime:[self transformWith:[self totalTimeValue]]Progress:[self progress]]; 
        
    }
    
}

//当前时间
- (NSInteger)currentTimeValue{
    
    return self.player.currentTime.value / self.player.currentTime.timescale;
}

//总时间
- (NSInteger)totalTimeValue{
    
    CMTime time = [self.player.currentItem duration];
    
    if (time.timescale == 0) {
        return 0;
    }else{
        
        return time.value / time.timescale;
        
    }
    
}

//进度
-(CGFloat)progress{
    
    return (CGFloat)[self currentTimeValue] / (CGFloat)[self totalTimeValue];
    
}

//转换字符串
- (NSString *)transformWith:(NSInteger)time{
    
    return [NSString stringWithFormat:@"%.2ld:%.2ld",time/60,time%60];

}

//暂停
-(void)pasueMusic{
    
    [self.timer invalidate];
    self.timer = nil;
    
    self.isPlaying = NO;
    
    [self.player pause];
    
}

- (void)seekToTime:(CGFloat)time{
    
    [self pasueMusic];
    
    [self.player seekToTime:CMTimeMake(time * [self totalTimeValue], 1) completionHandler:^(BOOL finished) {
        
        if (finished) {
            
            [self playMusic];
        }
        
    }];
    
}

//音量
-(void)setVoluemWithSlider:(CGFloat)sliderVolume{
    
    self.player.volume = sliderVolume;
 
}

//写一个获取歌词数组的方法
- (NSArray *)getLyricArray{
    
    self.lyricArray = [NSMutableArray array];
    
    for (NSString *str in self.model.timeLyric) {
        
        //分离开
        NSArray *lyricArray = [str componentsSeparatedByString:@"]"];
        
        //加一个判断
        if ([[lyricArray firstObject]length] < 1 ) {
            
            continue;
        }
        
        NSString *timeStr = [[lyricArray firstObject]substringWithRange:NSMakeRange(1, 5)];
        
        LyricModel *lyricModel = [[LyricModel alloc] initWithLyricTime:timeStr LyricStr:lyricArray.lastObject];
        
        [_lyricArray addObject:lyricModel];
        
    }
    
    return self.lyricArray;
    
}

//通过当前播放时间 返回对应数组的下标
- (NSInteger)getIndexWithCurrentTime:(NSString *)time{
    
    //起始不能是可以显示出来的下标
    NSInteger index = -1;
    
    for (int i = 0; i < self.lyricArray.count; i++) {
        
        //获取model self.lyricArray[i]
        if ([[self.lyricArray[i] lyricTime] isEqualToString:time]) {
            
            index = i;
        }
        
    }
    
    return index;
}



@end
