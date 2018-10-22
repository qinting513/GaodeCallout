//
//  CustomAnnotationView.h
//  GaoDe
//
//  Created by QT on 17/2/10.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

#import "BusPointCell.h"

@interface CallOutAnnotationView : MAAnnotationView


@property(nonatomic,retain) UIView *myContentView;

//添加一个UIView
@property(nonatomic,retain) BusPointCell *busInfoView;//在创建calloutView Annotation时，把contentView add的 subview赋值给businfoView


@end
