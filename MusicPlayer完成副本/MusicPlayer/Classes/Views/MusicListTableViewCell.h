//
//  MusicListTableViewCell.h
//  MusicPlayer
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MusicModel;

@interface MusicListTableViewCell : UITableViewCell

//歌手图片
@property (strong, nonatomic) IBOutlet UIImageView *singerImageView;

//歌曲名称
@property (strong, nonatomic) IBOutlet UILabel *musicNameLabel;

//歌手名称
@property (strong, nonatomic) IBOutlet UILabel *singerNameLabel;

//接收传过来的model对象
@property (nonatomic, strong)MusicModel *musicModel;


@end
