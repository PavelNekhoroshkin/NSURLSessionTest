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

@property (nonatomic,strong) CIFilter *filter;
@property (nonatomic,strong) CIContext *context;
@property (nonatomic,strong) CIImage *startImage;

@end

@implementation PictureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColor.lightGrayColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UIScreen.mainScreen.bounds.size.width, UIScreen.mainScreen.bounds.size.height - 200)];
    imageView.backgroundColor = UIColor.blackColor;
//    imageView.contentMode = UIViewContentModeScaleAspectFit;
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
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
    button1.center = CGPointMake(((UIScreen.mainScreen.bounds.size.width - 40)/3 * 0.5 + 10), UIScreen.mainScreen.bounds.size.height - 175);
    [button1 setTitle:@"Bloom" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(button1pressed) forControlEvents:UIControlEventTouchUpInside];
    self.button1 = button1;
    [self.view addSubview:button1];

    
    UIButton *button2 = [[FilterButton alloc] init];
    button2.center = CGPointMake(((UIScreen.mainScreen.bounds.size.width - 40)/3 * 1.5 + 20), UIScreen.mainScreen.bounds.size.height - 175);    [button2 setTitle:@"Pixellate" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(button2pressed) forControlEvents:UIControlEventTouchUpInside];
    self.button2 = button2;
    [self.view addSubview:button2];
    
    UIButton *button3 = [[FilterButton alloc] init];
    button3.center = CGPointMake(((UIScreen.mainScreen.bounds.size.width - 40)/3 * 2.5 + 30), UIScreen.mainScreen.bounds.size.height - 175);    [button3 setTitle:@"EdgeWork" forState:UIControlStateNormal];
    [button3 addTarget:self action:@selector(button3pressed) forControlEvents:UIControlEventTouchUpInside];
    self.button3 = button3;
    [self.view addSubview:button3];
    
//    self.button1.hidden = YES;
//    self.button2.hidden = YES;
//    self.button3.hidden = YES;
    
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


-(void) closePictureView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void) showProgress:(double)progress
{
    self.progressView.progress = progress;
}


- (void) showPicture
{
//    self.button1.hidden = YES;
//    self.button2.hidden = YES;
//    self.button3.hidden = YES;
//
    NSData *pictureData = [self.dataStore.maxPhotoNSData objectForKey:self.idPicture];

    CIImage *startImage = [CIImage imageWithData:pictureData];

    self.startImage = startImage;
    self.progressView.hidden = YES;
    [self.imageView setImage:[UIImage imageWithData:pictureData]];

    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

}

//- (void) aplyFilter
//{
//
//    CIImage *endImage = [self.filter outputImage];
//}

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
    
    
}

- (void) button1pressed
{
    if(!self.startImage)
    {
        return;
    }
    
    [self setSlidersSelector:@selector(applyFilterCIBloom)];
    
    self.button1.backgroundColor = UIColor.grayColor;
   
    self.slider1.hidden = NO;
    self.slider2.hidden = NO;
    
    [self applyFilterCIBloom];
}





- (void) applyFilterCIBloom
{
    double radius = (0.01 + self.slider2.value) * 30;
    double intensity = (0.01 + self.slider1.value) * 1;
    
    CIFilter* filter = [CIFilter filterWithName:@"CIBloom"];
    [filter setValue:self.startImage forKey:kCIInputImageKey];
    [filter setValue:@(intensity) forKey:kCIInputIntensityKey];
    [filter setValue:@(radius) forKey:kCIInputRadiusKey];
    self.filter = filter;
    
    CIImage *endImage = [filter outputImage];
    
//    CGImageRef cgimg = [self.context createCGImage:endImage fromRect:[endImage extent]];
//    UIImage *newImage = [UIImage imageWithCGImage:cgimg];
//    CGImageRelease(cgimg);
    
    UIImage *newImage = [UIImage imageWithCIImage:endImage];

    self.imageView.image = newImage;

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
    
    [self applyFilterCIPixellate];
}

- (void) applyFilterCIPixellate
{
    double inputCenter = (0.01 + self.slider1.value) * 300;
    double inputScale = (0.01 + self.slider2.value) * 30;
    
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


- (void) prepareFilterCISepiaTone
{
    double intensity = (0.01 + self.slider1.value) * 2;
    
    CIFilter* filter = [CIFilter filterWithName:@"CISepiaTone"];
    [filter setValue:self.startImage forKey:kCIInputImageKey];
    [filter setValue:@(intensity) forKey:kCIInputIntensityKey];
    self.filter = filter;
    
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
