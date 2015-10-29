//
//  MusicListTableViewController.m
//  MusicDemo
//
//  Created by lanou3g on 15/9/22.
//  Copyright (c) 2015年 白蕊. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicListCell.h"
#import "GetDataManager.h"
#import "PlayMusicViewController.h"

#define kMusicListUrl @"http://project.lanou3g.com/teacher/UIAPI/MusicInfoList.plist"

@interface MusicListTableViewController ()



@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MusicList_id"];
    
    //如果走Block就说明已经回到主线程 要在主线程刷新数据
    //通过Block回调 刷新数据
    [[GetDataManager sharedManager] getDataWithUrl:kMusicListUrl Block:^{
        
        //222222222内部的block执行完毕 然后执行这个语句
        [self.tableView reloadData];
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
//分区数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [GetDataManager sharedManager].count;
}
//高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80;
    
}

//cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MusicList_id" forIndexPath:indexPath];
    
    //通过重写cell.model的set方法 来赋值
   cell.model = [[GetDataManager sharedManager]getModelWithIndexpath:indexPath.row];

    return cell;
    
}

//点击cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //通过桥的ID 去跳转页面  注意:::::show 默认是push 如果没有navigationControl 那么show就是模态 showDetail就是模态
    //[self performSegueWithIdentifier:@"playMusic_id" sender:nil];
    
//    PlayMusicViewController *playVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil]instantiateViewControllerWithIdentifier:@"playMusic"];
    
    
    //直接调用单例方法
    PlayMusicViewController *playVC = [PlayMusicViewController sharedManager];
    
    
    playVC.index = indexPath.row;
    
    [self showViewController:playVC sender:nil];

    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
