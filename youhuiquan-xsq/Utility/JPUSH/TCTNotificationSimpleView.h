//
//  TCTNotificationSimpleView.h
//  TCTravel_IPhone
//
//  Created by Zhuyc on 15/1/7.
//
//

#import <UIKit/UIKit.h>

@interface TCTNotificationSimpleView : UIView
@property(nonatomic, weak)IBOutlet UILabel *lblMessage;

- (instancetype)initWithFrame:(CGRect)frame withMessage:(NSString *)aMessage;

@end
