//
//  ViewController.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 11.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "ViewController.h"
#import "DataStore.h"
#import "CollectionViewCell.h"
#import "PictureViewController.h"

@interface ViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUI];
    
}


- (void) createUI
{
    self.view.backgroundColor = UIColor.whiteColor;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 30, self.view.frame.size.width, 50)];
    searchBar.delegate = self.searchBarDelegate;
    
//    searchBar.searchBarStyle = UISearchBarStyleDefault;
    
//    показывает кнопку Cancel
//    searchBar.showsCancelButton = YES;
    
//    показывает клавиатуру сразу
//    [searchBar becomeFirstResponder];
    
    self.searchBar = searchBar;
    [self.view addSubview:searchBar];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame)/2 - 5, CGRectGetWidth(self.view.frame)/2 - 5);
    layout.minimumInteritemSpacing = 5;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height) collectionViewLayout:layout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = UIColor.whiteColor;
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    

    [self.collectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    
}


#pragma mark - UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"Загружено рисунков: %d",  (int)[self.dataStore.pictureIds count]);
    return [self.dataStore.pictureIds count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //идентификатор рисунка
    NSString *pictureId = [self.dataStore.pictureIds objectAtIndex:indexPath.row];
    //загруженный рисунок
    NSData *pictureData =  [self.dataStore.minPhotoNSData objectForKey:pictureId];
    
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[CollectionViewCell alloc] init];
    }
    if(pictureData){
        [cell.imageView setImage:[UIImage imageWithData:pictureData]];
        NSString *title = [[self.dataStore.photoParams objectForKey:pictureId] objectForKey:@"title"];
        [cell.titleLabel setText:title];
//        cell.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageWithData:pictureData]];
    }
    
    return cell;

}

#pragma mark - UICollectionViewDelegate

// Methods for notification of selection/deselection and highlight/unhighlight events.
// The sequence of calls leading to selection from a user touch is:
//
// (when the touch begins)
// 4. -collectionView:didSelectItemAtIndexPath: or -collectionView:didDeselectItemAtIndexPath:
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *idPicture = [self.dataStore.pictureIds objectAtIndex:indexPath.row];
    NSData *pictureData = [self.dataStore.maxPhotoNSData objectForKey:idPicture];
    NSString *isStartedDownload = [self.dataStore.maxPhotoStartDownload objectForKey:idPicture];
    PictureViewController *pictureViewController = [[PictureViewController alloc] init];
    pictureViewController.controller = self;
    pictureViewController.idPicture = idPicture;
    pictureViewController.dataStore = self.dataStore;
    self.downloadController.pictureViewController = pictureViewController;
    
    //Если картинка не загружена и не в процессе загрузки, то инициировать загрузку
    if(!pictureData && !isStartedDownload)
    {
        NSString *maxPictureURL = [[self.dataStore.pictureURLs objectForKey:idPicture] objectForKey:@"max"];
        [self.downloadController downloadMaxPictureWithURL:(NSString *)maxPictureURL idPicture:(NSString *)idPicture];
    }
    
    //Если картинка загружена, то задать данные картинки для последующего использования в методе viewDidLoad
    if (pictureData)
    {
    
        pictureViewController.pictureData = pictureData;

    }
    
    [self presentViewController:pictureViewController animated:YES completion:^{}];
}

//обновить коллекцию  после загрузки новой картинки
- (void) reloadCollectionView
{
    [self.collectionView reloadData];
}

- (void) showErrorAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"ОШИБКА" message:@"Не удалось загрузить данные." preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){
//        [alertController dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}



@end
