//
//  MusicListCell.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import "MusicListCell.h"
#import "MusicModel.h"
#import "UIImageView+WebCache.h"
@implementation MusicListCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//重写 Model的set方法 为了赋值

- (void)setModel:(MusicModel *)model{
    
    self.musicName.text = model.name;
    self.singer.text = model.singer;
    
    [self.musicImage sd_setImageWithURL:[NSURL URLWithString:model.picUrl] placeholderImage:[UIImage imageNamed:@"悠嘻猴3.jpg"]];
    
}

@end
