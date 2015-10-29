//
//  PlayMusicViewController.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayMusicViewController : UIViewController


@property(nonatomic,assign)NSInteger index;

//单例
+(PlayMusicViewController *)sharedManager;
@property(nonatomic,strong)UIImage *picImage;


- (void)pushFromLeftOrRight:(NSString *)direction;


@end
