//
//  TCTNotificationSimpleView.m
//  TCTravel_IPhone
//
//  Created by Zhuyc on 15/1/7.
//
//

#import "TCTNotificationSimpleView.h"
@interface TCTNotificationSimpleView()
@property(nonatomic, weak)IBOutlet UIView *viewBg;
@property(nonatomic, weak)IBOutlet UIImageView *imvIcon;
@end

@implementation TCTNotificationSimpleView

- (instancetype)initWithFrame:(CGRect)frame withMessage:(NSString *)aMessage
{
    self = [[[NSBundle mainBundle] loadNibNamed:@"TCTNotificationSimpleView" owner:self options:nil] objectAtIndex:0];
    [self setFrame:frame];
    
    
    self.lblMessage.preferredMaxLayoutWidth = [[UIScreen mainScreen] applicationFrame].size.width - 320 + CGRectGetWidth(self.lblMessage.frame);
    
    self.viewBg.backgroundColor = [UIColor blackColor];
    self.viewBg.alpha = 0.8;
    
    self.lblMessage.text = aMessage;
    self.lblMessage.textColor = [UIColor colorWithRed:(float)255/255.0f green:(float)255/255.0f blue:(float)255/255.0f alpha:1];
    self.lblMessage.font = [UIFont systemFontOfSize:(14.f)];
    self.lblMessage.backgroundColor = [UIColor clearColor];
    
    self.backgroundColor = [UIColor clearColor];
    return self;
}

@end