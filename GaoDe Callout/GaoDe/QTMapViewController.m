//
//  QTMapViewController.m
//  GaoDe
//
//  Created by QT on 17/2/10.
//  Copyright © 2017年 QT. All rights reserved.
//

#import "QTMapViewController.h"

#import "CustomPointAnnotation.h"
#import "CallOutAnnotationView.h"
#import "BusPointCell.h"
#import "CalloutMapAnnotation.h"


#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapNaviKit/AMapNaviKit.h>



@interface QTMapViewController ()<MAMapViewDelegate>
{
    CalloutMapAnnotation *_calloutMapAnnotation;
}

@property (nonatomic,strong) NSMutableArray *annotations;
@property (nonatomic, strong) MAMapView *mapView;

@end

@implementation QTMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"高德地图";
    
    for (int i =0; i<5; i++) {

    //添加自定义Annotation
    CLLocationCoordinate2D center = { (39.91669 - arc4random()%5),(116.39716-arc4random()%10)};
    
    CustomPointAnnotation *pointAnnotation = [[CustomPointAnnotation alloc] init];
 
    NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:@"拍照",@"alias",@"速度",@"speed",@"方位",@"degree",@"位置",@"name",@"5",@"imageName",nil];
    pointAnnotation.pointCalloutInfo =dict;
    
    pointAnnotation.coordinate = center;
    [self.mapView addAnnotation:pointAnnotation];
     
    }
    
//    MACoordinateSpan span = {0.04,0.03};
//    MACoordinateRegion region = {center,span};
//    [self.mapView setRegion:region animated:NO];
 
    [self.mapView showAnnotations:self.mapView.annotations animated:YES];
    
}
-(MAMapView *)mapView
{
    if (!_mapView) {
        self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        self.mapView.delegate = self;
        self.mapView.rotateEnabled = NO;
        self.mapView.showsUserLocation = YES;
        self.mapView.userTrackingMode = MAUserTrackingModeFollow;
        [self.view addSubview:self.mapView];
    }
    return _mapView;
}


/** 显示多个大头针 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{

    static NSString *annotationIdentifier = @"customAnnotation";
    if ([annotation isKindOfClass:[CustomPointAnnotation class]]) {
        
        MAPinAnnotationView *annotationview = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        
        annotationview.image = [UIImage imageNamed:@"0"];
        //        [annotationview setPinColor:BMKPinAnnotationColorGreen];
        [annotationview setAnimatesDrop:YES];
        annotationview.canShowCallout = NO;
        
        return annotationview;
        
    }
    else if ([annotation isKindOfClass:[CalloutMapAnnotation class]]){
        
        //此时annotation就是我们calloutview的annotation
        CalloutMapAnnotation *ann = (CalloutMapAnnotation*)annotation;
        
        //如果可以重用
        CallOutAnnotationView *calloutannotationview = (CallOutAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"calloutview"];
        
        //否则创建新的calloutView
        if (!calloutannotationview) {
            calloutannotationview = [[CallOutAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"calloutview"];
            
            BusPointCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"BusPointCell" owner:self options:nil] objectAtIndex:0];
            
            [calloutannotationview.myContentView addSubview:cell];
            calloutannotationview.busInfoView = cell;
        }
        
        //开始设置添加marker时的赋值
        calloutannotationview.busInfoView.aliasLabel.text = [ann.locationInfo objectForKey:@"alias"];
        calloutannotationview.busInfoView.speedLabel.text = [ann.locationInfo objectForKey:@"speed"];
        calloutannotationview.busInfoView.degreeLabel.text =[ann.locationInfo objectForKey:@"degree"];
        calloutannotationview.busInfoView.nameLabel.text =  [ann.locationInfo objectForKey:@"name"];
        calloutannotationview.busInfoView.leftImageView.image = [UIImage imageNamed:ann.locationInfo[@"imageName"]];
        return calloutannotationview;
        
    }
    
    return nil;
    
}

- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    NSLog(@"didSelectAnnotationView");
 
    
    
    if ([view.annotation isKindOfClass:[CustomPointAnnotation class]]) {
        
        //CustomPointAnnotation 是自定义的marker标注点，通过这个来得到添加marker时设置的pointCalloutInfo属性
        CustomPointAnnotation *annn = (CustomPointAnnotation*)view.annotation;
        
        //如果点到了这个marker点，什么也不做
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude &&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            return;
        }
        //如果当前显示着calloutview，又触发了didSelectAnnotationView方法，删除这个calloutview annotation
        if (_calloutMapAnnotation) {
            [mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation=nil;
            
        }
        //创建搭载自定义calloutview的annotation
        _calloutMapAnnotation = [[CalloutMapAnnotation alloc] initWithLatitude:view.annotation.coordinate.latitude andLongitude:view.annotation.coordinate.longitude] ;
        
        //把通过marker(ZNBCPointAnnotation)设置的pointCalloutInfo信息赋值给CalloutMapAnnotation
        _calloutMapAnnotation.locationInfo = annn.pointCalloutInfo;
        
        // 当添加的时候会调用 viewForAnnotation 方法
        [mapView addAnnotation:_calloutMapAnnotation];
        
        [mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
        
    }

    
}


-(void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view{
    
    if (_calloutMapAnnotation&&![view isKindOfClass:[CallOutAnnotationView class]]) {
        
        if (_calloutMapAnnotation.coordinate.latitude == view.annotation.coordinate.latitude&&
            _calloutMapAnnotation.coordinate.longitude == view.annotation.coordinate.longitude) {
            [mapView removeAnnotation:_calloutMapAnnotation];
            _calloutMapAnnotation = nil;
        }

    }
    
}


@end
