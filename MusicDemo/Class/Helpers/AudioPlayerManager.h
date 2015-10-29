//
//  AudioPlayerManager.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/23.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MusicModel.h"
#import <UIKit/UIKit.h>
//1.代理
@protocol AudioPlayManageDelegate <NSObject>
//2.当前的时间,总时间,进度条
-(void)getCurrentTime:(NSString *)currentTime TotalTime:(NSString *)totalTime Progress:(CGFloat)progress;

//播放到结束的时候

- (void)audioPlayToEnd;



@end

@interface AudioPlayerManager : NSObject



+(AudioPlayerManager *)sharedManager;

@property(nonatomic,assign)BOOL isPlaying;//是否播放
@property(nonatomic,strong)MusicModel *model;
//@property(nonatomic,strong)NSTimer *timer;
//准备播放
- (void)prepareMusic;

//播放
-(void)playMusic;

//暂停
-(void)pasueMusic;

//自定义播放
- (void)seekToTime:(CGFloat)time;



//3.设置代理
@property(nonatomic,weak)id<AudioPlayManageDelegate>delegate;

-(void)setVoluemWithSlider:(CGFloat)sliderVolume;

//返回歌词是数组
- (NSArray *)getLyricArray;

//通过当前播放时间 返回对应数组的下标
- (NSInteger)getIndexWithCurrentTime:(NSString *)time;


@end
