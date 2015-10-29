//
//  GetDataManager.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import "GetDataManager.h"
#import "MusicModel.h"

//延展
@interface GetDataManager()

@property(nonatomic,retain) NSMutableArray *musicListArray;//用来存放model的数组

@end

@implementation GetDataManager

//static GetDataManager *getDataManager = nil;
//+ (GetDataManager *)shareManager{
//    
//    @synchronized(self){
//    if (getDataManager == nil) {
//        
//        getDataManager = [[GetDataManager alloc] init];
//        
//    }
//    
//    return getDataManager;
// }
//}


+(GetDataManager *)sharedManager
{
    static GetDataManager *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        audioManager = [[GetDataManager alloc]init];
    });
    return audioManager;
}


//请求数据的方法
- (void)getDataWithUrl:(NSString *)url Block:(myBlock)block{
  
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *array = [NSArray arrayWithContentsOfURL:[NSURL URLWithString:url]];
        
        
        for (NSDictionary *dic in array) {
            
            MusicModel *musicModel = [MusicModel new];
            
            [musicModel setValuesForKeysWithDictionary:dic];
            
            [self.musicListArray addObject:musicModel];
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            
            block();
            
        });
        
        
    });
    
}

//通过下标返回model
- (MusicModel *)getModelWithIndexpath:(NSInteger)index{
    
    return self.musicListArray[index];
    
}


//懒加载
//懒加载——也称为延迟加载，即在需要的时候才加载（效率低，占用内存小）。所谓懒加载，写的是其get方法.
//注意：如果是懒加载的话则一定要注意先判断是否已经有了，如果没有那么再去进行实例化
//2.使用懒加载的好处：
//（1）不必将创建对象的代码全部写在viewDidLoad方法中，代码的可读性更强
//（2）每个控件的getter方法中分别负责各自的实例化处理，代码彼此之间的独立性强，松耦合


//数组的懒加载(当你用到数组的时候才去初始化)
- (NSMutableArray *)musicListArray{
    
    if (!_musicListArray) {
        
        _musicListArray = [NSMutableArray array];
    }
    
    return _musicListArray;
}

//get方法
- (NSInteger)count{
    
    return self.musicListArray.count;
    
}

@end
