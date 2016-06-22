//
//  MapViewController.h
//  Appirian
//
//  Created by Igor Old MAC on 1/20/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapViewController : UIViewController <MKMapViewDelegate>


@property (weak, nonatomic) IBOutlet MKMapView *map;

@property (nonatomic, strong) NSArray *dataRows;

@end
