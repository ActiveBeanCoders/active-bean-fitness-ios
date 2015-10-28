//
//  MyActiveBeanFitness.swift
//  ActiveBeanFitnessIos
//
//  Created by Brian Rhodes on 10/19/15.
//  Copyright © 2015 activebeancoders. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class MyActiveBeanFitnessController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {
    @IBOutlet var myMapView: MKMapView!
    @IBOutlet var timeElapsedLabel: UILabel!
    @IBOutlet var startButton: UIButton!
    
    private var locationManager = CLLocationManager()
    
    private var startTime = NSTimeInterval()
    private var pauseTime = NSTimeInterval()
    private var totalPauseTime = NSTimeInterval()
    private var timer = NSTimer()
    private var timerInitialized = false;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        //Gets initial location without starting the location updates
        locationManager.requestLocation()
        
        myMapView.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        myMapView.showsUserLocation = true
        
        timeElapsedLabel.text = "00:00:00"
        startButton.setTitle("Start", forState: UIControlState.Normal);
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func zoomIn(sender: AnyObject) {
        //let userLocation = myMapView.userLocation
        
        let region = MKCoordinateRegionMakeWithDistance((locationManager.location?.coordinate)!, 2000, 2000)
        
        myMapView.setRegion(region, animated: true)
    }
    
    // MARK: CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        zoomIn(self)
        print(locations)
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error)
    }
    
    @IBAction func startButtonTouchUpInside(sender: UIButton) {
        if(startButton.titleLabel?.text == "Start") {
            print("*Starting Location Updates*")
            startTimer()
            locationManager.startUpdatingLocation()
            startButton.setTitle("End", forState: UIControlState.Normal)
        } else {
            print("*Stopping Location Updates*")
            pauseTimer()
            locationManager.stopUpdatingLocation()
            startButton.setTitle("Start", forState: UIControlState.Normal)
        }
    }
    
    func startTimer() {
        let aSelector : Selector = "updateTime"
        timer = NSTimer.scheduledTimerWithTimeInterval(0.01, target: self, selector: aSelector, userInfo: nil, repeats: true)
        timerInitialized = true
        if (timeElapsedLabel.text == "00:00:00") {
            startTime = NSDate.timeIntervalSinceReferenceDate()
        } else {
            totalPauseTime += NSDate.timeIntervalSinceReferenceDate() - pauseTime
        }
    }
    
    func pauseTimer() {
        pauseTime = NSDate.timeIntervalSinceReferenceDate()
        timer.invalidate()
    }
    
    func updateTime() {
        
        let currentTime = NSDate.timeIntervalSinceReferenceDate()
        
        //Find the difference between current time and start time.
        
        var elapsedTime: NSTimeInterval = (currentTime - startTime) - totalPauseTime
        
        //calculate the minutes in elapsed time.
        
        let minutes = UInt8(elapsedTime / 60.0)
        
        elapsedTime -= (NSTimeInterval(minutes) * 60)
        
        //calculate the seconds in elapsed time.
        
        let seconds = UInt8(elapsedTime)
        
        elapsedTime -= NSTimeInterval(seconds)
        
        //find out the fraction of milliseconds to be displayed.
        
        let fraction = UInt8(elapsedTime * 100)
        
        //add the leading zero for minutes, seconds and millseconds and store them as string constants
        
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        let strFraction = String(format: "%02d", fraction)
        
        //concatenate minutes, seconds and milliseconds as assign it to the UILabel
        
        timeElapsedLabel.text = "\(strMinutes):\(strSeconds):\(strFraction)"
        
    }
    
}

