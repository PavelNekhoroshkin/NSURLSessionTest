//
//  SearchBarDelegate.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "SearchBarDelegate.h"

@implementation SearchBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    [self.downloadController sendSearchRequest:searchBar.text];
    [searchBar resignFirstResponder];

}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
//  Если передать YES, то клавиатура автоматически отображается поверх экрана, если фокус в окне поиска
    return YES;
}

@end
