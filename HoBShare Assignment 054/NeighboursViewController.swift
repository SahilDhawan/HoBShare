//
//  NeighboursViewController.swift
//  HoBShare Assignment 054
//
//  Created by Sahil Dhawan on 15/01/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import MapKit

class NeighboursViewController: HoBShareViewController,MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var users : [User]?
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        mapView.delegate = self
    }
    
    override func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        locationManager.stopUpdatingLocation()
        self.centerMapCurrentLocation()
    }
    
    func centerMapCurrentLocation()
    {
        guard currentLocation != nil else
        {
            print("Current Location not available")
            return
        }
       mapView.setCenterCoordinate(currentLocation!.coordinate, animated: true)
        let currentRegion = mapView.regionThatFits(MKCoordinateRegionMake(CLLocationCoordinate2DMake(currentLocation!.coordinate.latitude,currentLocation!.coordinate.longitude),MKCoordinateSpanMake(0.5, 0.5)))
            mapView.setRegion(currentRegion, animated:true)
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let users = self.users
        {
            mapView.removeAnnotations(users)
        }
        self.fetchUsersWithHobby(myHobbies![indexPath.row])
        let cell = collectionView.dataSource?.collectionView(collectionView, cellForItemAtIndexPath: indexPath)  as! HobbyCollectionViewCell
        cell.backgroundColor = UIColor.redColor()
    }
    
    func fetchUsersWithHobby(hobby:Hobby)
    {
        guard
            (NSUserDefaults.standardUserDefaults().valueForKey("CurrentUserId") as? String)!.characters.count > 0 else
        {
            let alert = UIAlertController.init(title: kAppTitle, message: "Please login before selecting a Hobby", preferredStyle: .Alert)
            let okAction = UIAlertAction.init(title: "Dismiss", style: .Default, handler: {(action) in
                alert.dismissViewControllerAnimated(true,completion:nil)})
            alert.addAction(okAction)
            self.presentViewController(alert,animated: true,completion: nil)
            return
        }
        //make REST Call
        let requestUser = User()
        requestUser.userId = NSUserDefaults.standardUserDefaults().valueForKey("CurrentUserId") as? String
        requestUser.latitude = currentLocation?.coordinate.latitude
        requestUser.longitude = currentLocation?.coordinate.longitude
        UserDP().fetchUsersForHobby(requestUser ,hobby : hobby)
        {(returnedListOfUsers) in
                if returnedListOfUsers.status.code == 0
                {
                    self.users = returnedListOfUsers.users
                    
                    if let users = self.users
                    {
                        self.mapView.removeAnnotations(users)
                    }
                    
                    if let users = self.users
                    {
                        for user in users
                        {
                            self.mapView.addAnnotation(user)
                        }
                        
                        if self.currentLocation != nil
                        {
                            let me = User(userName: "Me",hobbies:self.myHobbies!,lat:self.currentLocation!.coordinate.latitude,long:self.currentLocation!.coordinate.longitude)
                            self.mapView.addAnnotation(me)
                            let neighborsAndMe = users + [me]
                            self.mapView.showAnnotations(neighborsAndMe, animated: true)
                        }
                        else
                        {
                            self.mapView.showAnnotations(users, animated: true)
                        }
                    }
            }
            else
            {
                    self.showError(returnedListOfUsers.status.statusDescription!)
            }
        }
    }
   }
