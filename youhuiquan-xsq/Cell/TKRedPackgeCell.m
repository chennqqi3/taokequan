//
//  TKRedPawefwefckgeCell.m
//  Kai_Tsfsafasfdasdaoke
//
//  Created by efwef on 2017/6/1.
//  Copyright © 20wefwe17年 zykfweokfpwoekfw All rights reserved.
//

#import "TKRedPackgeCell.h"

@implementation TKRedPackgeCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.layer.cornerRadius = 24;
    self.clipsToBounds = YES;
         //
        [self.btnSumitb.layer setMasksToBounds:YES];
        [self.btnSumitb.layer setCornerRadius:10]; //设置矩圆角半径
//        [self.btnSumitb.layer setBorderWidth:0.5];   //边框宽度
        //边框颜色
//        [self.btnSumitb.layer setBorderColor:[RGBA(237, 116, 44, 1) CGColor]];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
