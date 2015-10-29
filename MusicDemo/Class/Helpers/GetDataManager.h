//
//  GetDataManager.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import <Foundation/Foundation.h>


@class MusicModel;

typedef void(^myBlock)();

@interface GetDataManager : NSObject

//记录数组个数 给外界返回row的时候使用
@property(nonatomic,assign)NSInteger count;

//单例
+ (GetDataManager *)sharedManager;

//请求数据的方法
- (void)getDataWithUrl:(NSString *)url Block:(myBlock)block;

//通过下标返回 model
- (MusicModel *)getModelWithIndexpath:(NSInteger)index;

@end
