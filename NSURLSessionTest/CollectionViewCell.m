//
//  CollectionViewCell.m
//  NSURLSessionTest
//
//  Created by Павел Нехорошкин on 14.04.2019.
//  Copyright © 2019 Павел Нехорошкин. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        Ячейка
//        self.backgroundColor = UIColor.cyanColor;
        
//        Подложка (в полный размер ячейки)
//        self.contentView.backgroundColor = UIColor.lightGrayColor;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(8,8,CGRectGetWidth(frame)-16,CGRectGetHeight(frame)-20)];
        imageView.backgroundColor = UIColor.greenColor;
        self.imageView = imageView;
//        Элементы размещаем на подложке
        [self.contentView addSubview:imageView];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8,CGRectGetHeight(frame)-12,CGRectGetWidth(frame)-16,12)];
        [titleLabel setFont:[UIFont systemFontOfSize:12]];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel = titleLabel;
//        Элементы размещаем на подложке
        [self.contentView addSubview:titleLabel];
    
    }
    return self;
}



// Специальный метод, в который передается размер ячейки (для случая когда размер разный, когда его определяет layout для каждой)
// метод вызывается сразу после задания значений для ячейки (перед отображением), позволяет сделать последние настройки,
// вызывается только при измении атрибутов
//- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
//{
//    self.frame = layoutAttributes.frame;
//    CGRect imageFrame = CGRectMake(layoutAttributes.frame.origin.x, layoutAttributes.frame.origin.y, layoutAttributes.frame.size.width, layoutAttributes.frame.size.height - 20);
//    self.imageView.frame = imageFrame;
//     CGRect titleFrame = CGRectMake(layoutAttributes.frame.origin.x, layoutAttributes.frame.origin.y + layoutAttributes.frame.size.height - 5, layoutAttributes.frame.size.width, 15);
//    self.imageTitle.frame = titleFrame;
//    self.imageTitle.backgroundColor = UIColor.blueColor;
//    self.backgroundColor = UIColor.redColor;
//    self.imageView.backgroundColor = UIColor.greenColor;
//
//}


//override func layoutSubviews() {
//    super.layoutSubviews()
//    
//    let coverImageViewX = (frame.width - 50) / 2
//    coverImageView.frame = CGRect(x: coverImageViewX, y: 10, width: 50, height: 50)
//    
//    let titleLabelY = coverImageView.frame.maxY + 5
//    let titleLabelWidth = frame.width - 20
//    titleLabel.frame = CGRect(x: 10, y: titleLabelY, width: titleLabelWidth, height: 10)
//    
//    let subtitleLabelY = titleLabel.frame.maxY + 5
//    button.frame = CGRect(x: 10, y: subtitleLabelY, width: titleLabelWidth, height: 10)
//}

@end
