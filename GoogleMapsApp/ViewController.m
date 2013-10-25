//
//  ViewController.m
//  GoogleMapsApp
//
//  Created by Vivek Madkaikar on 25/10/13.
//  Copyright (c) 2013 Vivek Madkaikar. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController ()

@end

@implementation ViewController
{
    GMSMapView *mapView_;
    GMSMarker *flightMarker;
    CGFloat planeLatitude;
    CGFloat planeLongitude;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView {
    planeLatitude = -33.86;
    planeLongitude = 151.20;
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.86
                                                            longitude:151.20
                                                                 zoom:15
                                                              bearing:30
                                                         viewingAngle:40];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.mapType = kGMSTypeTerrain;
    mapView_.myLocationEnabled = YES;
    self.view = mapView_;
    
    // Creates a marker in the center of the map.
    GMSMarker *formMarker = [[GMSMarker alloc] init];
    formMarker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    formMarker.title = @"Point one";
    formMarker.map = mapView_;

    GMSMarker *toMarker = [[GMSMarker alloc] init];
    toMarker.position = CLLocationCoordinate2DMake(-30.86, 151.20);
    toMarker.title = @"Point two";
    toMarker.map = mapView_;
    
    flightMarker = [[GMSMarker alloc] init];
    flightMarker.position = CLLocationCoordinate2DMake(planeLatitude, planeLongitude);
    //flightMarker.icon = [UIImage imageNamed:@"flag_icon"];
    flightMarker.title = @"Plane";
    flightMarker.map = mapView_;
    
    NSTimer* myTimer = [NSTimer scheduledTimerWithTimeInterval: 1.0 target: self
                                                      selector: @selector(movePlane:) userInfo: nil repeats: YES];
    [[NSRunLoop currentRunLoop] addTimer:myTimer forMode:NSRunLoopCommonModes];
    
}

-(void) movePlane:(NSTimer*) t
{
    float startingLatitude = planeLatitude;
    float endingLatitude = -30.86;
    
    float startingLongitude = planeLongitude;
    float endingLongitude = 151.20;
    
    float latitudeDistance = (endingLatitude < startingLatitude) ? (endingLatitude - startingLatitude) : (startingLatitude - endingLatitude);
    float longitudeDistance = (endingLongitude < startingLongitude) ? (endingLongitude - startingLongitude) : (startingLongitude - endingLongitude);
    
    CGFloat latitudeMovement = (endingLatitude > startingLatitude) ? (startingLatitude - (latitudeDistance * 0.01f)) : (startingLatitude + (latitudeDistance * 0.01f));
    CGFloat longitudeMovement = (endingLongitude > startingLongitude) ? (startingLongitude - (longitudeDistance * 0.01f)) : (startingLongitude + (longitudeDistance * 0.01f));
    
    planeLatitude = latitudeMovement;
    planeLongitude = longitudeMovement;
    
    NSLog(@"Moving Plane %f %f", latitudeMovement, longitudeMovement);
    flightMarker = [[GMSMarker alloc] init];
    flightMarker.position = CLLocationCoordinate2DMake(latitudeMovement, longitudeMovement);
    //flightMarker.icon = [UIImage imageNamed:@"flag_icon.png"];
    flightMarker.title = @"Plane";
    flightMarker.map = mapView_;
    
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitudeMovement
                                                            longitude:longitudeMovement
                                                                 zoom:15
                                                              bearing:30
                                                         viewingAngle:40];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];

}

@end
