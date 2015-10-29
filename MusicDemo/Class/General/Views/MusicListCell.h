//
//  MusicListCell.h
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;

@interface MusicListCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *musicImage;

@property (retain, nonatomic) IBOutlet UILabel *musicName;

@property (retain, nonatomic) IBOutlet UILabel *singer;

@property(nonatomic,strong) MusicModel *model;


@end
