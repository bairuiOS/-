//
//  MusicModel.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
    if ([key isEqualToString:@"id"]) {
        
        self.ID = value;
    }
    if ([key isEqualToString:@"lyric"]) {
        
        self.timeLyric = [value componentsSeparatedByString:@"\n"];
    }
   
}


@end
