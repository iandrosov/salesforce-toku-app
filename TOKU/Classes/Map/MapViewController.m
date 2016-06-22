//
//  MapViewController.m
//  Appirian
//
//  Created by Igor Old MAC on 1/20/15.
//  Copyright (c) 2015 Appirio. All rights reserved.
//

#import "MapViewController.h"
#import "SFRestAPI.h"
#import "SFRestRequest.h"

#import "MemberLocation.h"
#import "ContactModel.h"
#import "ContactDetailViewController.h"

#import "LocalStoreManager.h"
#import "AttributesFacade.h"

@interface MapViewController ()

@end

@implementation MapViewController

@synthesize dataRows;
@synthesize map;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"MSG.TITLE.Locations", @"Locations");
    self.map.delegate = self;
    self.view.backgroundColor = [AttributesFacade contanerBackgroundColor];
    
    self.dataRows = [LocalStoreManager getCantactsModel];
    [self plotLocationPositions:nil];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillAppear:(BOOL)animated {
    // 1
    CLLocationCoordinate2D zoomLocation;
    zoomLocation.latitude = 47.640071; //39.281516;
    zoomLocation.longitude= -122.129598; //-76.580806;
    
    // 2
    //MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 0.5*METERS_PER_MILE, 0.5*METERS_PER_MILE);
    
    // 3
    //[self.map setRegion:viewRegion animated:YES];
}


- (void)plotLocationPositions:(NSData *)responseData {
    for (id<MKAnnotation> annotation in self.map.annotations) {
        [self.map removeAnnotation:annotation];
    }
    
    //NSDictionary *root = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    //NSArray *data = [root objectForKey:@"data"];
    
    //NSDictionary *obj = [dataRows objectAtIndex:indexPath.row];
    //cell.textLabel.text =  [obj objectForKey:@"Name"];
    int i = 0;
    for (ContactModel *contact in dataRows) {
        i++;
        if (contact.city && contact.state && contact.postalcode && contact.country && i < 40)
        {
            
            //ContactModel *contact = [[ContactModel alloc] init];
            //[contact initWithDictionary:obj];
        
            NSString * resource = @"NO";
            if(contact.isActive){
                resource = @"YES";
            }

            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder geocodeAddressString:contact.address
                     completionHandler:^(NSArray* placemarks, NSError* error){
                         for (CLPlacemark* aPlacemark in placemarks)
                         {
                             // Process the placemark.
                             
                             //CLLocationCoordinate2D coordinate;
                             //coordinate.latitude = atitude; //latitude.doubleValue;
                             //coordinate.longitude = longitude; //longitude.doubleValue;
                             MemberLocation *annotation = [[MemberLocation alloc] initWithName:contact.name address:contact.address resource:resource coordinate:aPlacemark.location.coordinate] ;
                             annotation.contact = contact;
                             [self.map addAnnotation:annotation];

                         }
                         
                     }];
        
       // double latitude = 47.640071;
       // double longitude = -122.129598;
        
        //NSNumber * latitude = [[row objectAtIndex:22]objectAtIndex:1];
        //NSNumber * longitude = [[row objectAtIndex:22]objectAtIndex:2];
        //NSString * crimeDescription = [row objectAtIndex:18];
        //NSString * address = [row objectAtIndex:14];
        /*
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = latitude; //latitude.doubleValue;
        coordinate.longitude = longitude; //longitude.doubleValue;
        MemberLocation *annotation = [[MemberLocation alloc] initWithName:crimeDescription address:address coordinate:coordinate] ;
        [self.map addAnnotation:annotation];
         */
        }
    }
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MemberLocation";
    if ([annotation isKindOfClass:[MemberLocation class]]) {
        MemberLocation *ml = annotation;
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.map dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.enabled = YES;
            annotationView.canShowCallout = YES;
            if ([ml.isresource isEqualToString:@"YES"]) {
                annotationView.image = [UIImage imageNamed:@"active-marker"];
            }else{
                annotationView.image = [UIImage imageNamed:@"not-active-marker"];
            }
            annotationView.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        } else {
            annotationView.annotation = annotation;
        }
        
        return annotationView;
    }
    
    return nil;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control {
    MemberLocation *location = (MemberLocation*)view.annotation;
    
    //NSDictionary *launchOptions = @{MKLaunchOptionsDirectionsModeKey : MKLaunchOptionsDirectionsModeDriving};
    //[location.mapItem openInMapsWithLaunchOptions:launchOptions];
    
    ContactDetailViewController *VC = [[ContactDetailViewController alloc] initWithNibName:@"ContactDetailViewController" bundle:nil];
    VC.contact = location.contact;
    [self.navigationController pushViewController:VC animated:YES];
}


@end
