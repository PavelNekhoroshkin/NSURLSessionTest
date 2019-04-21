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
    
    searchBar.searchBarStyle = UISearchBarStyleDefault;

    self.searchBar = searchBar;
    [self.view addSubview:searchBar];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(CGRectGetWidth(self.view.frame)/2, CGRectGetWidth(self.view.frame)/2);
    layout.minimumInteritemSpacing = 0;
    layout.minimumLineSpacing = 0;
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
    NSString *idPicture = [self.dataStore.pictureIds objectAtIndex:indexPath.row];
    //загруженный рисунок
    NSData *imageData =  [self.dataStore.minPhotoNSData objectForKey:idPicture];
    
    CollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[CollectionViewCell alloc] init];
    }
    
    if(imageData){
        [cell.imageView setImage:[UIImage imageWithData:imageData]];
        NSString *title = [[self.dataStore.photoParams objectForKey:idPicture] objectForKey:@"title"];
        [cell.titleLabel setText:title];
        cell.indexPath = indexPath;
        cell.controller = self;
        
        //если не было просмотра картинок, то для уведомлений будет использована первая загруженная картинка
        if(indexPath.row == 0 && self.dataStore.searchStarted )
        {
            //установить первую найденную картинку, как рисунок для уведомлений
            self.dataStore.noitficationPicture = idPicture;
            self.dataStore.noitficationMaxPicture = nil;
            
            //новая картинка установлена, сбросить признак нового поиска
            self.dataStore.searchStarted = nil;
            
            [self createNotification:self.searchBar.text];
        }
    }
    return cell;
}

#pragma mark - UICollectionViewDelegate
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
        self.dataStore.noitficationPicture = idPicture;

    }

    //Если картинка загружена, то задать данные картинки для последующего использования в методе viewDidLoad
    if (pictureData)
    {
        pictureViewController.pictureData = pictureData;
        self.dataStore.noitficationMaxPicture = idPicture;

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
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action){}];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:^{}];
    
}


/**
 Генерирует уведомление с предложением найти кошек,
 которое будет показано в только при открытом приложении через 3 секунды после любого поиска кроме строк "Cat" или "Cats"
 
 @param searchText последняя строка поиска
 */
- (void) createNotification:(NSString *)searchText
{
    [self.notificationGenerator createCatSearchNotificationWithSearchText:searchText];
}

/**
 Установить строку поиска как для поиска котов (если в уведомлении нажали кнопку "найти котов")
 */
- (void)  setSearchBarStringForCats
{
    self.searchBar.text = @"Cat";
}


/**
 Метод для поиска кошек, вызывается, если пользователь согласился искать кошек по увеломлению в активном приложении
 */
- (void) searchFromNotificationWithString:(NSString *)searchString
{
    [self.downloadController sendSearchRequest:searchString];
    self.dataStore.noitficationMaxPicture = nil;
    self.dataStore.searchStarted = @"Search started";
}

@end
