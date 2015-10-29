//
//  LyricModel.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/24.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LyricModel : NSObject


@property(nonatomic,strong) NSString *lyricTime;//歌词时间
@property(nonatomic,strong) NSString *lyricStr;//歌词


//初始化方法
- (instancetype)initWithLyricTime:(NSString *)lyricTime
                         LyricStr:(NSString *)lyricStr;




@end
