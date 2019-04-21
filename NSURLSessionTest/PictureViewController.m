//
//  PictureViewController.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 15.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "PictureViewController.h"
#import "FilterButton.h"

@interface PictureViewController ()
@property (nonatomic,strong) UIProgressView *progressView;
@property (nonatomic,strong) UIImageView *imageView;
@property (nonatomic,strong) UISlider *slider1;
@property (nonatomic,strong) UISlider *slider2;
@property (nonatomic,strong) UISlider *slider3;
@property (nonatomic,strong) UIButton *button1;
@property (nonatomic,strong) UIButton *button2;
@property (nonatomic,strong) UIButton *button3;
@property (nonatomic,strong) UIButton *button4;

@property (nonatomic,strong) CIFilter *filter;
@property (nonatomic,strong) CIContext *context;
@property (nonatomic,strong) CIImage *startImage;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    [self createUI];
}

- (void) createUI
{
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - 200)];
    imageView.backgroundColor = UIColor.blackColor;
    imageView.contentMode = UIViewContentModeScaleToFill;
    
    self.imageView = imageView;
    [self.view addSubview:imageView];
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    closeButton.frame = CGRectMake(5,UIScreen.mainScreen.bounds.size.height - 45,UIScreen.mainScreen.bounds.size.width - 10,40);
    closeButton.backgroundColor = [UIColor darkGrayColor] ;
    [closeButton setTitle:@"Назад к поиску" forState:UIControlStateNormal];
    closeButton.layer.borderWidth = 5;
    closeButton.layer.borderColor = [UIColor grayColor].CGColor;
    closeButton.layer.cornerRadius = 5;
    
    
    UIButton *button1 = [[FilterButton alloc] init];
    button1.center = CGPointMake(((UIScreen.mainScreen.bounds.size.width - 40)/4 * 0.5 + 8), UIScreen.mainScreen.bounds.size.height - 175);
    [button1 setTitle:@"Sepia" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1pressed) forControlEvents:UIControlEventTouchUpInside];
    self.button1 = button1;
    [self.view addSubview:button1];
    
    
    UIButton *button2 = [[FilterButton alloc] init];
    button2.center = CGPointMake(((UIScreen.mainScreen.bounds.size.width - 40)/4 * 1.5 + 8 * 2), UIScreen.mainScreen.bounds.size.height - 175);
    [button2 setTitle:@"Pixellate" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2pressed) forControlEvents:UIControlEventTouchUpInside];
    self.button2 = button2;
    [self.view addSubview:button2];
    
    UIButton *button3 = [[FilterButton alloc] init];
    button3.center = CGPointMake(((UIScreen.mainScreen.bounds.size.width - 40)/4 * 2.5 + 8 * 3), UIScreen.mainScreen.bounds.size.height - 175);
    [button3 setTitle:@"EdgeWork" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3pressed) forControlEvents:UIControlEventTouchUpInside];
    self.button3 = button3;
    [self.view addSubview:button3];
    
    UIButton *button4 = [[FilterButton alloc] init];
    button4.center = CGPointMake(((UIScreen.mainScreen.bounds.size.width - 40)/4 * 3.5 + 8 * 4), UIScreen.mainScreen.bounds.size.height - 175);
    [button4 setTitle:@"Bump" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(button4pressed) forControlEvents:UIControlEventTouchUpInside];
    self.button4 = button4;
    [self.view addSubview:button4];
    
    
    UISlider *slider1 = [[UISlider alloc]initWithFrame:CGRectMake(10, UIScreen.mainScreen.bounds.size.height - 160,  UIScreen.mainScreen.bounds.size.width - 20, 40)];
    UISlider *slider2 = [[UISlider alloc]initWithFrame:CGRectMake(10, UIScreen.mainScreen.bounds.size.height - 120,  UIScreen.mainScreen.bounds.size.width - 20, 40)];
    UISlider *slider3 = [[UISlider alloc]initWithFrame:CGRectMake(10, UIScreen.mainScreen.bounds.size.height - 80,  UIScreen.mainScreen.bounds.size.width - 20, 40)];
    
    slider1.value = 0.5;
    slider2.value = 0.5;
    slider3.value = 0.5;
    
    self.slider1 = slider1;
    self.slider2 = slider2;
    self.slider3 = slider3;
    
    [self.view addSubview:slider1];
    [self.view addSubview:slider2];
    [self.view addSubview:slider3];
    
    //отображаем результат фильтра только при остановке слайдера, чтобы избежать задержки интерфейса
    [self.slider1 setContinuous:NO];
    [self.slider2 setContinuous:NO];
    [self.slider3 setContinuous:NO];
    
    self.slider1.hidden = YES;
    self.slider2.hidden = YES;
    self.slider3.hidden = YES;
    
    
    [closeButton addTarget:self action:@selector(closePictureView) forControlEvents:UIControlEventTouchUpInside ];
    [self.view addSubview:closeButton];
    
    UIProgressView *progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, UIScreen.mainScreen.bounds.size.height - 200,  UIScreen.mainScreen.bounds.size.width, 10)];
    self.progressView = progressView;
    [self.view addSubview:progressView];
    
    
    //картинка загружена
    if(self.pictureData)
    {
        progressView.hidden = YES;
        //        [self.imageView setImage:[UIImage imageWithData:self.pictureData]];
        CIImage *startImage = [CIImage imageWithData:self.pictureData];
        self.startImage = startImage;
        [self.imageView setImage:[UIImage imageWithCIImage:startImage]];
        
    }
    
    
    CIContext *context = [CIContext contextWithOptions:nil];
    self.context = context;
}

- (void) closePictureView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) showProgress:(double)progress
{
    self.progressView.progress = progress;
}


/**
 Отображает рисунок, когда он загружен, удаляет прогресс-бар
 */
- (void) showPicture
{
    NSData *pictureData = [self.dataStore.maxPhotoNSData objectForKey:self.idPicture];
    
    if(pictureData)
    {
        self.dataStore.noitficationMaxPicture = self.idPicture;
    }
//    [self.controller storeFile:pictureData idPicture:self.idPicture notification:2];

    CIImage *startImage = [CIImage imageWithData:pictureData];

    self.startImage = startImage;
    self.progressView.hidden = YES;
    [self.imageView setImage:[UIImage imageWithData:pictureData]];

    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

}


/**
 Настройка слайдеров и кнопок при выборе фильтра

 @param selector метод фильтра, чтобы обнолять изображение при изменении праметров
 */
- (void) setSlidersSelector:(SEL)selector
{
    
    [self.slider1 addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    [self.slider2 addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    [self.slider3 addTarget:self action:selector forControlEvents:UIControlEventValueChanged];
    
    self.slider1.value = 0.5;
    self.slider2.value = 0.5;
    self.slider3.value = 0.5;
    
    self.button1.backgroundColor = UIColor.lightGrayColor;
    self.button2.backgroundColor = UIColor.lightGrayColor;
    self.button3.backgroundColor = UIColor.lightGrayColor;
    self.button4.backgroundColor = UIColor.lightGrayColor;
    
    
}

- (void) button1pressed
{
    if(!self.startImage)
    {
        return;
    }
    
    [self setSlidersSelector:@selector(applyFilterCISepiaTone)];
    
    self.button1.backgroundColor = UIColor.grayColor;
   
    self.slider1.hidden = NO;
    self.slider2.hidden = YES;
    self.slider3.hidden = YES;
    
    [self applyFilterCISepiaTone];
}


- (void) applyFilterCISepiaTone
{
    double intensity = (0.01 + self.slider1.value ) * 3 - 1 ;
    
    CIFilter* filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:self.startImage forKey:kCIInputImageKey];
    [filter setValue:@(intensity) forKey:kCIInputIntensityKey];
    self.filter = filter;
    
    CIImage *endImage = [filter outputImage];
    
    CGImageRef cgimg = [self.context createCGImage:endImage fromRect:[endImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
}


- (void) button2pressed
{
    if(!self.startImage)
    {
        return;
    }
    
    [self setSlidersSelector:@selector(applyFilterCIPixellate)];
    
    self.button2.backgroundColor = UIColor.grayColor;
    
    self.slider1.hidden = NO;
    self.slider2.hidden = NO;
    self.slider3.hidden = YES;
    
    [self applyFilterCIPixellate];
}


- (void) applyFilterCIPixellate
{
    double inputScale = (0.01 + self.slider1.value) * 30;
    double inputCenter = (0.01 + self.slider2.value) * 300;
    
    CIFilter* filter = [CIFilter filterWithName:@"CIPixellate"];
    [filter setValue:self.startImage forKey:kCIInputImageKey];
    [filter setValue:[[CIVector alloc] initWithX:inputCenter Y:inputCenter] forKey:kCIInputCenterKey];
    [filter setValue:@(inputScale) forKey:kCIInputScaleKey];
    self.filter = filter;
    
    CIImage *endImage = [filter outputImage];
    
    CGImageRef cgimg = [self.context createCGImage:endImage fromRect:[endImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
    
}

- (void) button3pressed
{
    if(!self.startImage)
    {
        return;
    }
    
    [self setSlidersSelector:@selector(applyFilterCIEdgeWork)];
    
    self.button3.backgroundColor = UIColor.grayColor;
    
    self.slider1.hidden = NO;
    self.slider2.hidden = YES;
    self.slider3.hidden = YES;
    
    [self applyFilterCIEdgeWork];
}


- (void) applyFilterCIEdgeWork
{
    double inputRadius = (0.01 + self.slider1.value) * 6;
    
    CIFilter* filter = [CIFilter filterWithName:@"CIEdgeWork"];
    [filter setValue:self.startImage forKey:kCIInputImageKey];
    [filter setValue:@(inputRadius) forKey:kCIInputRadiusKey];
    self.filter = filter;
    
    CIImage *endImage = [filter outputImage];
    
    CGImageRef cgimg = [self.context createCGImage:endImage fromRect:[endImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
    
}


- (void) button4pressed
{
    if(!self.startImage)
    {
        return;
    }
    
    [self setSlidersSelector:@selector(applyFilterCIBumpDistortion)];
    
    self.button4.backgroundColor = UIColor.grayColor;
    
    self.slider1.hidden = NO;
    self.slider2.hidden = NO;
    self.slider3.hidden = NO;
    
    [self applyFilterCIBumpDistortion];
}



- (void) applyFilterCIBumpDistortion
{
    double inputCenter = (0.01 + self.slider1.value) * 150;
    double inputRadius = (0.01 + self.slider2.value) * 180;
    double inputScale = (0.01 + self.slider3.value) * 8 - 3;
    
//    NSLog(@"%f --- %f --- %f", inputCenter, inputRadius, inputScale );

    CIFilter* filter = [CIFilter filterWithName:@"CIBumpDistortion"];
    [filter setValue:self.startImage forKey:kCIInputImageKey];
    [filter setValue:[[CIVector alloc] initWithX:inputCenter Y:inputCenter]forKey:kCIInputCenterKey];
    [filter setValue:@(inputRadius) forKey:kCIInputRadiusKey];
    [filter setValue:@(inputScale) forKey:kCIInputScaleKey];
    self.filter = filter;
    
    CIImage *endImage = [filter outputImage];
    
    CGImageRef cgimg = [self.context createCGImage:endImage fromRect:[endImage extent]];
    
    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
    
    self.imageView.image = newImage;
    
    CGImageRelease(cgimg);
    
}


@end
