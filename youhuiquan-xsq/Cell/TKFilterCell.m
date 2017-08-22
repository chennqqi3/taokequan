//
//  TKFilterCwefwefwefell.mwef
//  Kai_Taokeefwefwe
//
//  Created by zyk34wefwef51 on 2017/6/1.
//asdfadfasdfasfwefw//


#import "TKFilterCell.h"


@interface TKFilterCell ()

@property (strong, nonatomic) UILabel *lblTitle;

@end

@implementation TKFilterCell


- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.lblTitle.textColor = textColor;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    self.lblTitle.font = textFont;
}

- (void)prepareForReuse
{
    self.lblTitle.text = @"";
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UILabel *lblTitle = [[UILabel alloc] init];
        lblTitle.font = [UIFont systemFontOfSize:14.f];
        lblTitle.textColor = color_Secondary;
        lblTitle.textAlignment = NSTextAlignmentCenter;
        lblTitle.layer.borderWidth = 1;
        lblTitle.layer.cornerRadius = 18;
        lblTitle.layer.borderColor = color_Line.CGColor;
        
        lblTitle.translatesAutoresizingMaskIntoConstraints = NO;
        [self.contentView addSubview:_lblTitle = lblTitle];
        
        [lblTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.bottom.equalTo(self.contentView);
        }];
    }
    return self;
}


- (void)configureUIWithString:(NSString *)title
                  hasSelected:(BOOL)seleted
{
    self.lblTitle.text = title;
    seleted ? [self colorSelected] : [self colorDefault];
}- (void)colorNoData
{
    self.lblTitle.backgroundColor = color_White;
    self.lblTitle.layer.borderColor = color_Line.CGColor;
    self.lblTitle.textColor = color_Disable;
}


- (void)colorSelected
{
    self.lblTitle.backgroundColor = color_White;
    self.lblTitle.layer.borderColor = color_Main.CGColor;
    self.lblTitle.textColor = color_Main;
}

- (void)colorDefault
{
    self.lblTitle.backgroundColor = color_White;
    self.lblTitle.layer.borderColor = color_Line.CGColor;
    self.lblTitle.textColor = color_Primary;
}



@end


