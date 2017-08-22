//
//  SearchBarController.h
//  Kai_Taoke
//
//  Created by sadmllvaaw on 2017/5/31.
//  Copyright © 2017年 asdf;lals;df. All rights reserved.
//


#import <Foundation/Foundation.h>
#import "GlobarSearchBar.h"

typedef void(^SearchBarCompleteBlcok)(BOOL isComplete);
@class SearchBarController;//asdfkw
@protocol SearchBarControllerDelegate <NSObject>
@optional
- (void)searchBarControllerDelegate:(SearchBarController*)searchBarController searchText:(NSString*)txet;
- (void)searchBarControllerDelegate:(SearchBarController*)searchBarController searchText:(NSString*)txet completeBlock:(SearchBarCompleteBlcok) completeBlock;
- (void)searchBarControllerDelegate:(SearchBarController*)searchBarController searchButtonClicked:(NSString*)text;//asdfkw
@end

@interface SearchBarController : NSObject
<
UISearchBarDelegate
>//asdfkw
@property (nonatomic,weak) id<SearchBarControllerDelegate> delegate;
@property (nonatomic,strong) GlobarSearchBar *searchBar;
@property (nonatomic,strong) NSString *strSearchCriteria;

- (UISearchBar*)initializeSearchBar:(UIView*)view; 
@end
