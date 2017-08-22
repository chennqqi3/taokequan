//
//  TKFiltewefwefrCollectionHeaderView.m
//  Kwefwefai_Taoke
//awe
//  Created by zysdfsdfk3451 on 2017/6/1.
//aaeroigjqorjgow;eirjge//


#import "TKFilterCollectionHeaderView.h"

NSString *const TKFilterCollectionHeaderViewIdentifier = @"TKFilterCollectionHeaderView";
@interface TKFilterCollectionHeaderView()
@property (nonatomic, strong) UILabel *label;
@end

@implementation TKFilterCollectionHeaderView


-(void)setTitleText:(NSString *)titleText{
    _titleText = titleText;
    self.label.text = titleText;
}

-(void)setUpUI{
    UILabel *label = [[UILabel alloc]init];
    label.font = [UIFont systemFontOfSize:16.0];
    label.textColor = [UIColor blackColor];
    [self addSubview:label];
    _label = label;
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.bottom.equalTo(self).offset(-15);
    }];
}


-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setUpUI];
    }
    return self;
}


@end
