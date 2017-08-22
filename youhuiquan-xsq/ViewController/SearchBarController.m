//
//  SearchBarController.m
//  Kai_Taoke
//
//  Created by zyk3451 on 2017/5/31.
//  Copyright © 2017年 zyk. All rights reserved.
//

#import "SearchBarController.h"

@interface SearchBarController (){
    UIView *superView;
}

@end

@implementation SearchBarController

//  Created by sadmllvaaw on 2017/5/31.

- (void)setStrSearchCriteria:(NSString*)strSearchCriteria{
    _strSearchCriteria = strSearchCriteria;
    self.searchBar.text = strSearchCriteria;
    
    [self searchBar:self.searchBar textDidChange:strSearchCriteria];
}

- (UISearchBar*)initializeSearchBar:(UIView*)view{
    superView = view;
    
    self.searchBar = [GlobarSearchBar new];
    
    self.searchBar.placeholder = @"请输入宝贝名称";
    
    self.searchBar.delegate = self;
    
//    [[UILabel appearanceWhenContainedIn:[UISearchBar class], nil] setTextColor:color_Secondary];
    
    self.searchBar.returnKeyType = UIReturnKeySearch;

    
    //iOS7
    if ([self.searchBar respondsToSelector:@selector(barTintColor)]) {
        [self.searchBar setBarTintColor:[UIColor clearColor]];
    }
    
    return self.searchBar;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar*)searchBar{
    return YES;
}
- (void)searchBarTextDidEndEditing:(UISearchBar*)searchBar{
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar*)searchBar{
    [searchBar resignFirstResponder];
    
    if([self.delegate respondsToSelector:@selector(searchBarControllerDelegate:searchButtonClicked:)]){
        [self.delegate searchBarControllerDelegate:self searchButtonClicked:searchBar.text];
    }
}

//- (void)searchBar:(UISearchBar*)searchBar textDidChange:(NSString*)searchText{
//    if ([self.delegate respondsToSelector:@selector(searchBarControllerDelegate:searchText:)]) {
//        [self.delegate searchBarControllerDelegate:self searchText:searchText];
//    }
//}

- (BOOL)searchBar:(UISearchBar*)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString*)text{
    
    
    if ([text isEqualToString:@" "]) { //禁输空格
        return NO;
    }
    return YES;
}
@end
