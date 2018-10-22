//
//  QTAnnotation.h
//  GaoDe
//
//  Created by QT on 17/2/10.
//  Copyright © 2017年 QT. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomPointAnnotation : MAPointAnnotation

@property(retain,nonatomic) NSDictionary *pointCalloutInfo;//标注点传递的callout吹出框显示的信息

@end
