//
//  LyricModel.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/24.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import "LyricModel.h"

@implementation LyricModel

//初始化方法
- (instancetype)initWithLyricTime:(NSString *)lyricTime LyricStr:(NSString *)lyricStr
{
    self = [super init];
    if (self) {
        
        _lyricStr = lyricStr;
        _lyricTime = lyricTime;
        
    }
    return self;
}

@end
