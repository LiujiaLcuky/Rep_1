//
//  MusicListTableViewController.m
//  MusicPlayer
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicListTableViewController.h"
#import "MusicManager.h"
#import "MusicListTableViewCell.h"
#import "MusicModel.h"

#import "MusicPlayerViewController.h"

@interface MusicListTableViewController ()

@property(nonatomic,strong)NSArray * musicArray;

@end

@implementation MusicListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //有xib文件的cell 注册
    [self.tableView registerNib:[UINib nibWithNibName:@"MusicListTableViewCell" bundle:nil] forCellReuseIdentifier:@"musicListCell"];
    
    
    //请求数据
    [[MusicManager shareInstance] requestAllDataDidFinish:^(NSMutableArray *dataArray) {
        
        //将请求下来的数据数组赋值给musicArray
        self.musicArray = dataArray;
       
        //实现block方法 就是更新tableView上的数据
        [self.tableView reloadData];
        
    }];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.musicArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MusicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicListCell" forIndexPath:indexPath];
    
    //获取每个cell对应的音乐模型
    MusicModel * model = [[MusicManager shareInstance] getMusicModelWithIndex:indexPath.row];
    
    //设置cell的属性
    cell.textLabel.highlighted = YES;
    cell.textLabel.highlightedTextColor = [UIColor redColor];
    
    cell.backgroundColor = [UIColor clearColor];
    
    //整体赋值给cell
    cell.musicModel = model;
    
    
    
    UIImageView * Bview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"111.jpg"]];
    [tableView setBackgroundView:Bview];
    
    
    
    return cell;
}


//懒加载
-(NSArray *)musicArray
{
    if (!_musicArray) {
        _musicArray = [NSArray array];
    }
    return _musicArray;
}

//设置行高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}


//点击选中行 推出
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //根据storyboard推出
//    MusicPlayerViewController * musicPlayerVC = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MyStoryboard"];
    
   MusicPlayerViewController * musicPlayerVC = [MusicPlayerViewController shareInstance];
    
    //模态翻转的动画效果
    musicPlayerVC.modalTransitionStyle = 1;
    
    //将所点击的行的下标也传回播放界面
    musicPlayerVC.index = indexPath.row;
    
    MusicModel * model = _musicArray[indexPath.row];
    
    musicPlayerVC.musicModel = model;
    //指定滑动方向
    self.navigationController.navigationBar.translucent = NO;
    
    [self presentViewController:musicPlayerVC animated:YES completion:nil];
    
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
