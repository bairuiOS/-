//
//  PlayMusicViewController.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import "PlayMusicViewController.h"
#import "AudioPlayerManager.h"
#import "GetDataManager.h"
#import "UIImageView+WebCache.h"
#import "MusicModel.h"
#import "LyricModel.h"
#import "MyTap.h"
@interface PlayMusicViewController ()<AudioPlayManageDelegate>

@property(nonatomic,assign)NSInteger temp;

@property (weak, nonatomic) IBOutlet UIImageView *musicImageView;

@property (weak, nonatomic) IBOutlet UILabel *currentTime;

@property (weak, nonatomic) IBOutlet UISlider *progressSlider;

@property (weak, nonatomic) IBOutlet UILabel *totleTime;

@property (weak, nonatomic) IBOutlet UIImageView *bgImage;

@property (weak, nonatomic) IBOutlet UISlider *volume;

@property (weak, nonatomic) IBOutlet UITableView *playMusicTableView;

//播放状态的属性
@property(nonatomic,assign) NSInteger isPlayState;

//枚举
enum{
    
    isOrderPlay,
    isRandomPlay,
    isCyclePlay
    
};



@end

@implementation PlayMusicViewController


//单例
+(PlayMusicViewController *)sharedManager

{
    static PlayMusicViewController *audioManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        audioManager = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"playMusic"];
    });
    return audioManager;
    
}

//上一首
- (IBAction)lastSong:(id)sender {
    
    if (self.index > 0) {
        
        self.index -- ;
        
    }else{
        
        self.index = [GetDataManager sharedManager].count - 1;
    }
    
    //更新下标
    [self play];
    
    [self pushFromLeftOrRight:@"fromRight"];
    
}
//暂停
- (IBAction)pauseOrPlay:(UIButton *)sender {
    
    
    if ([AudioPlayerManager sharedManager].isPlaying) {
        
    
        [[AudioPlayerManager sharedManager]pasueMusic];
        
        [sender setBackgroundImage:[UIImage imageNamed:@"暂停.gif"] forState:(UIControlStateNormal)];

        
        //照片360度旋转
//        CABasicAnimation *rotationAnimation;
//        rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//        
//        rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
//        rotationAnimation.duration = 1000000000000;
//        rotationAnimation.cumulative = YES;
//        rotationAnimation.repeatCount = 10000;
        
//[_musicImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        
        

    }else{
        
        [[AudioPlayerManager sharedManager]playMusic];
        
        [sender setBackgroundImage:[UIImage imageNamed:@"播放.gif"] forState:(UIControlStateNormal)];
        
    }
    
}

//下一首
- (IBAction)nextSong:(id)sender {

    

    
    if (_isPlayState == isOrderPlay) {
        
        
        
    }else if (_isPlayState == isRandomPlay){
        
        _index = arc4random() % 200;
        [self play];
        
    }else if(_isPlayState == isCyclePlay){
        
        [self play];
        
    }
    
    
    if (self.index < [GetDataManager sharedManager].count - 1) {
        self.index ++;
    }else{
        self.index = 0;
    }
    //更新下标
    [self play];
    
    [self pushFromLeftOrRight:@"fromLeft"];
    
}

- (IBAction)orderPlay:(id)sender {
    
    if (_isPlayState != isOrderPlay ) {
        
        _isPlayState = isOrderPlay;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"循环.png"] forState:(UIControlStateNormal)];
        
    }else{
        
        _isPlayState = isCyclePlay;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"顺序.png"] forState:(UIControlStateNormal)];
    }

}

- (IBAction)random:(id)sender {
    
     _isPlayState = isRandomPlay;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //给一个temp 初始值 ,因为上一个下标 0 是传不过来的
    self.temp = -1;
    
    //关掉透明度
    //self.navigationController.navigationBar.translucent = NO;
    
    //设置代理
    [AudioPlayerManager sharedManager].delegate = self;
    
    //自动适应
   self.automaticallyAdjustsScrollViewInsets = NO;
    
    //切圆
    [self.musicImageView layoutIfNeeded];
    
    _musicImageView.layer.cornerRadius = _musicImageView.frame.size.height / 2.0;


}



//视图出现的时候
- (void)viewWillAppear:(BOOL)animated{
    


//    //照片360度旋转
//    CABasicAnimation *rotationAnimation;
//    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
//    
//    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
//    rotationAnimation.duration = 6;
//    rotationAnimation.cumulative = YES;
//    rotationAnimation.repeatCount = 10000;
//    [_musicImageView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    
    [super viewWillAppear:animated];
    
    if (self.temp == self.index) {
        
        return;
    }else{
        
        [self play];
        
    }
    
    [super viewWillAppear:animated];


    //音量条 旋转90度
    _volume.transform = CGAffineTransformMakeRotation(-M_PI / 2);
    
}


- (void)updataUI
{
    //图片
    [_musicImageView sd_setImageWithURL:[NSURL URLWithString:[AudioPlayerManager sharedManager].model.picUrl]];
    
    //模糊图片
    [_bgImage sd_setImageWithURL:[NSURL URLWithString:[AudioPlayerManager sharedManager].model.blurPicUrl]];
    
}

//播放 给AudioplayerManager的model赋值,并且调用准备播放方法
-(void)play{
    
    self.temp = self.index;
    
    [AudioPlayerManager sharedManager].model = [[GetDataManager sharedManager]getModelWithIndexpath:self.index];
    NSLog(@"%@",[AudioPlayerManager sharedManager].model.mp3Url);
    
    [[AudioPlayerManager sharedManager]prepareMusic];
    
    
    

    [self updataUI];
    
    [self.playMusicTableView reloadData];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AudioPlayManagerDelegate 的方法
-(void)getCurrentTime:(NSString *)currentTime TotalTime:(NSString *)totalTime Progress:(CGFloat)progress{
    
    
    //360度旋转  改变musicImageView的transForm
    self.musicImageView.transform = CGAffineTransformRotate(self.musicImageView.transform, M_PI / 180);

    self.currentTime.text = currentTime;
    self.totleTime.text = totalTime;
    self.progressSlider.value = progress;
    
    //接收对应的下标
    NSInteger index = [[AudioPlayerManager sharedManager]getIndexWithCurrentTime:currentTime];
    
    if (index == -1) {
        return;
        
    }
    
    //设置当前播放的进条
    [self.playMusicTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];

    
}

//音量
- (IBAction)volum:(UISlider *)sender {
    
     [[AudioPlayerManager sharedManager] setVoluemWithSlider:sender.value];
    
}


//UISlider 滑动方法
- (IBAction)progressSlder:(UISlider *)sender {
    
    //告诉外界时间该改变了 加一个参数 传给自己的播放器
    [[AudioPlayerManager sharedManager]seekToTime:sender.value];
    
}

//行数和 cell 是必须实现的方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [[AudioPlayerManager sharedManager] getLyricArray].count;
    
}

//设置cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"playMusicCell_id" forIndexPath:indexPath];
    
    LyricModel *lyricModel = [[AudioPlayerManager sharedManager]getLyricArray][indexPath.row];
    
    cell.textLabel.text = lyricModel.lyricStr;
    
    //居中
    cell.textLabel.textAlignment = 1;
    
    //选中的颜色
    //语法糖写法 意思就是 在selectedBackgroundView 上添加一个View
    cell.selectedBackgroundView = ({
    
        UIView *view = [UIView new];
        
        view.backgroundColor = [UIColor colorWithRed:arc4random()%256 / 255.0 green:arc4random()%256 / 255.0 blue:arc4random()%256 / 255.0 alpha:0.4];
        
        view;
    
    });
    
    //轻拍歌词跳转
    MyTap *tap = [[MyTap alloc]initWithTarget:self action:@selector(jumpToLyric:)];
    tap.index = indexPath.row;
    //轻拍次数
    tap.numberOfTapsRequired = 2;
    //添加轻拍事件
    [cell addGestureRecognizer:tap];
    
    _playMusicTableView.backgroundColor = [UIColor clearColor];
    
    return cell;
}

- (void)jumpToLyric:(MyTap *)tap{
    
    LyricModel *lyricModel = [[AudioPlayerManager sharedManager]getLyricArray][tap.index];
    
    NSInteger miniute = [[lyricModel.lyricTime substringToIndex:2]integerValue];
    
    CGFloat seconds = [[lyricModel.lyricTime substringFromIndex:3]integerValue];
    
    CGFloat targetTime = (miniute * 60 + seconds) *1000 ;
    
    [[AudioPlayerManager sharedManager]seekToTime:targetTime/[[AudioPlayerManager sharedManager].model.duration integerValue]];
    
    [self.playMusicTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:tap.index inSection:0] animated:YES scrollPosition:(UITableViewScrollPositionMiddle)];
    
 
    
}


//播放到结束的时候
- (void)audioPlayToEnd{
    
    
    if (_isPlayState == isOrderPlay) {
        
        [self nextSong:nil];
        
    }else if (_isPlayState == isRandomPlay){
        
        _index = arc4random() % 200;
        [self play];
        
    }else if(_isPlayState == isCyclePlay){
        
        [self play];
        
    }
   
    
}

#pragma mark - 切换过渡动画
- (void)pushFromLeftOrRight:(NSString *)direction
{
    CATransition *transition = [CATransition animation];
    //配置动画
    transition.type =@"reveal" ;
    transition.subtype = direction;
    transition.duration =0.8;
    transition.delegate=self;
    //添加动画
    [self.musicImageView.layer addAnimation:transition forKey:nil];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (flag) {
        [[AudioPlayerManager sharedManager] playMusic];
    }else{
        [[AudioPlayerManager sharedManager] pasueMusic];
    }
    

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
