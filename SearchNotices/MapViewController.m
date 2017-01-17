//
//  MapViewController.m
//  SearchNotices
//
//  Created by Jackey on 2016/12/18.
//  Copyright © 2016年 com.zhouxi. All rights reserved.
//

#import "MapViewController.h"
#import <MapKit/MapKit.h>

@interface MapViewController () <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //调用创建MapView方法
    [self createMapView];
}

- (id)initWithLatitude:(double)latitude
             Longitude:(double)longitude
          LocationInfo:(NSString *)locationInfo {
    
    self = [super init];
    if (self) {
        
        self.latitude   = latitude;
        self.longitude  = longitude;
        self.locateInfo = locationInfo;
        
    }
    
    return self;
}

//创建MapView方法
- (void)createMapView {
    
    self.mapView = ({
        
        MKMapView *map = [[MKMapView alloc] initWithFrame:
                          CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        
        map.mapType           = MKMapTypeStandard;
        map.zoomEnabled       = YES;
        map.scrollEnabled     = YES;
        map.showsUserLocation = YES;
        map.delegate          = self;
        
        CLLocationCoordinate2D center;
        center.latitude  = self.latitude;
        center.longitude = self.longitude;
        
        MKCoordinateSpan span;
        span.latitudeDelta  = 0.01;
        span.longitudeDelta = 0.01;
        
        MKCoordinateRegion region = {center, span};
        [map setRegion:region animated:YES];
        
        MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
        annotation.title              = @"发布地点:";
        annotation.subtitle           = self.locateInfo;
        annotation.coordinate         = center;
        [map addAnnotation:annotation];
        
        map;
    });
    
    [self.view addSubview:self.mapView];
}


@end
