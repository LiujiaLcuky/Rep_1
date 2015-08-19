//
//  MusicListTableViewCell.m
//  MusicPlayer
//
//  Created by lanou3g on 15/8/9.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MusicListTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "MusicModel.h"
@implementation MusicListTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//重写set方法
-(void)setMusicModel:(MusicModel *)musicModel
{
    [self.singerImageView sd_setImageWithURL:[NSURL URLWithString:musicModel.picUrl]];
    
    self.singerImageView.layer.borderColor = [UIColor greenColor].CGColor;
    self.singerImageView.layer.borderWidth = 1;
    
    self.musicNameLabel.text = musicModel.name;
    
    self.singerNameLabel.text = musicModel.singer;
}




@end
