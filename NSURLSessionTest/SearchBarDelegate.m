//
//  SearchBarDelegate.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "SearchBarDelegate.h"
#import "AppDelegate.h"

@implementation SearchBarDelegate

/**
 Метод делегата строки поиска, выполяет поиск при нажатии Enter или Search

 @param searchBar параметр вызова метода делегата - объект searchBar
 */
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    
    //выставить признак нового поиска, чтобы рисунок для уведомлений обновился на первый найденный в данном поиске
    self.dataStore.searchStarted = @"Search started";
    //выполнить поиск по строке
    [self.downloadController sendSearchRequest:searchBar.text];
    [searchBar resignFirstResponder];
    
}

/**
 Метод делегата строки поиска, открывает клавиатуру
 
 @param searchBar параметр вызова метода делегата - объект searchBar
 */
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}


@end
