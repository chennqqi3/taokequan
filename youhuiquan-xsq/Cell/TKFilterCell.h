//
//  TKFilterCell.h
//wefwef017/6/1.
//  sdfffff © 2017afasdfasdfasdfeserved.
//


#import <UIKit/UIKit.h>

static NSString *const TKFilterCellIdentifier = @"TKFilterCell";

@interface TKFilterCell : UICollectionViewCell

- (void)configureUIWithString:(NSString *)title
                  hasSelected:(BOOL)seleted;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIFont *textFont;
@end
