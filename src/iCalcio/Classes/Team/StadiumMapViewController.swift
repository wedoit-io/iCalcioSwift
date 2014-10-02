//
//  StadiumMapViewController.swift
//  iCalcio
//
//  Created by Andrea Calisesi on 25/09/14.
//  Copyright (c) 2014 Andrea Calisesi. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class StadiumMapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    
    @IBOutlet weak var mapView: MKMapView!
    
    var mapTitle:String = String()
    var mapLatitude:String = String()
    var mapLongitude:String = String()
    
    private var locationManager:CLLocationManager!
    private var isUpdateUserLocation:Bool = false
    private var segmentControl : UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.navigationItem.title = NSLocalizedString("Stadio", comment: "")
        
        // init
        self.initStadiumLocation()

        // init zoom management
        self.initRightNavBar()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - NavBar map zoom managment
    private func initRightNavBar()
    {
        let images: [UIImage] = [
            UIImage(named: "722-location-pin-toolbar"),
            UIImage(named: "845-location-target-toolbar")
        ]
        self.segmentControl = UISegmentedControl(items: images)
        self.segmentControl.addTarget(self, action: "selectedSegmentDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        self.segmentControl.selectedSegmentIndex = 0
        
        let segmentBarItem : UIBarButtonItem = UIBarButtonItem(customView: self.segmentControl)
        self.navigationItem.rightBarButtonItem = segmentBarItem
        
    }
    
    func selectedSegmentDidChange(sender:UISegmentedControl!)
    {
        println("selectedSegmentDidChange: method called")
        
        let segment : UISegmentedControl = sender
        
        switch (segment.selectedSegmentIndex) {
        case 0:
            // Stadium
            self.showStadiumLocation()
        case 1:
            // My position
            self.showUserLocation()
        default:
            break
        }
        
    }
    
    private func showStadiumLocation() {
        
        // Stadium
        if self.mapLatitude != String() && self.mapLongitude != String() {
            // Map zoom in Stadium position
            let stadiumLatitude = NSString(string:self.mapLatitude).doubleValue
            let stadiumLongitude = NSString(string:self.mapLongitude).doubleValue
            let region:MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: stadiumLatitude, longitude: stadiumLongitude), span: MKCoordinateSpanMake(0.005, 0.005))
            mapView.setRegion(region, animated: true)
            mapView.regionThatFits(region)
        }
        
    }
    
    private func showUserLocation() {
        
        // goto my position
        
        if isUpdateUserLocation {
            // Map zoom in my position
            let region:MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: mapView.userLocation.location.coordinate.latitude, longitude: mapView.userLocation.location.coordinate.longitude), span: MKCoordinateSpanMake(0.030, 0.030))
            mapView.setRegion(region, animated: true)
            mapView.regionThatFits(region)
        }
        
    }
    

    // MARK: - MKMapView management
    private func initStadiumLocation() {
        
        // set defaults
        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        let teamInformation = appDelegate.teamInformation
        if let stadiumName = teamInformation?.stadiumName {
            self.mapTitle = stadiumName
        }
        if let stadiumLongitude = teamInformation?.stadiumLongitude {
            self.mapLongitude = stadiumLongitude
        }
        if let stadiumLatitude = teamInformation?.stadiumLatitude {
            self.mapLatitude = stadiumLatitude
        }
        
        // set delegate mapview
        mapView.delegate = self
        
        // Ensure that you can view your own location in the map view.
        self.mapView.showsUserLocation = true
        // Instantiate a location object.
        self.locationManager = CLLocationManager()
        // Make this controller the delegate for the location manager.
        self.locationManager.delegate = self
        // Set some parameters for the location object.
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        // Authorization and updating location
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // goto intial stadium position
        self.showStadiumLocation()
        
        // add annotation
        
    }
    
     // MARK: - MKMapView delegate
    func mapView(mapView: MKMapView!, didUpdateUserLocation userLocation: MKUserLocation!){
        //println("MKMapView.didUpdateUserLocation: Ok")
        self.isUpdateUserLocation = true
    }
    
    func mapView(mapView: MKMapView!, didFailToLocateUserWithError error: NSError!){
        println("MKMapView.didFailToLocateUserWithError: " + error.localizedDescription)
    }
    
    // MARK: - CLLocationManager delegate
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!){
        //println("CLLocationManager.didUpdateLocations: Ok")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("CLLocationManager.didFailWithError: " + error.localizedDescription)
    }
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
