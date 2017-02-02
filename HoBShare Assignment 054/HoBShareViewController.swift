//
//  HoBShareViewController.swift
//  HoBShare Assignment 054
//
//  Created by Sahil Dhawan on 15/01/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import MapKit

class HoBShareViewController: UIViewController,CLLocationManagerDelegate,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource {

    
    @IBOutlet weak var collectionView: UICollectionView!
    let availableHobbies : [String:[Hobby]] = HobbyDP().fetchHobbies();
    var myHobbies:[Hobby]?
        {
        didSet{
            self.collectionView.reloadData()
            self.saveHobbiesToUserDefaults()
        }
    }
    
    let locationManager = CLLocationManager()
    var currentLocation = CLLocation.init()
    
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        locationManager.delegate = self
        
        if CLLocationManager.authorizationStatus() == .NotDetermined
        {
            locationManager.requestWhenInUseAuthorization()
        }
        else if CLLocationManager.authorizationStatus() == .AuthorizedAlways || CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse
        {
            locationManager.stopUpdatingLocation()
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .AuthorizedWhenInUse || status == .AuthorizedAlways
        {
            manager.stopUpdatingLocation()
            manager.startUpdatingLocation()
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last!
        manager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error: NSError) {
        print(error.localizedDescription)
    }
    
    func locationManager(manager: CLLocationManager, didFinishDeferredUpdatesWithError error: NSError?) {
        print(error.debugDescription)
    }
    
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if collectionView == self.collectionView
        {
            return 1
        }
        else
        {
            return availableHobbies.keys.count
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.collectionView
        {
            guard myHobbies != nil else
            {
                return 0
            }
            return myHobbies!.count
        }
        else
        {
            let keys = Array(availableHobbies.keys)[section]
            return availableHobbies[keys]!.count
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let cell:HobbyCollectionViewCell =
            collectionView.dequeueReusableCellWithReuseIdentifier("HobbyCollectionViewCell",
                                                                  forIndexPath: indexPath)as! HobbyCollectionViewCell

        if collectionView == self.collectionView
        {
            let hobby = myHobbies![indexPath.item]
            cell.HobbyLabel.text = hobby.hobbyName
        }
        else
        {
            let key = Array(availableHobbies.keys)[indexPath.section]
            let hobbies = availableHobbies[key]
            let hobby = hobbies![indexPath.item]
            cell.HobbyLabel.text = hobby.hobbyName
        }
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize
    {
            var availableWidth:CGFloat!
                let height:CGFloat! = 54
                let numberOfCells:Int!
              if collectionView == self.collectionView
              {
                numberOfCells = (collectionView.dataSource?.collectionView(collectionView, numberOfItemsInSection: indexPath.section))!
                let padding = 10
                availableWidth = collectionView.frame.size.width-CGFloat(padding*(numberOfCells!-1))
              }
                else
              {
                numberOfCells = 2
                let padding = 10
                availableWidth = collectionView.frame.size.width-CGFloat(padding*(numberOfCells!-1))
              }
                let dynamicCellWidth = availableWidth/CGFloat(numberOfCells)
                let dynamicCellSize = CGSize.init(width: dynamicCellWidth, height: height)
                return dynamicCellSize
    }
    
    func saveHobbiesToUserDefaults()
    {
        let HobbyData = NSKeyedArchiver.archivedDataWithRootObject(myHobbies!)
        NSUserDefaults.standardUserDefaults().setValue(HobbyData,forKey:"myHobbies")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func showError(message:String)
    {
        let alert = UIAlertController(title: kAppTitle, message: message, preferredStyle: .Alert)
        
        let okAction = UIAlertAction(title:"Dismiss",style:.Default,handler:{(action) in
            alert.dismissViewControllerAnimated(true, completion: nil)
        })
        alert.addAction(okAction)
        self.presentViewController(alert,animated: true,completion: nil)
    }
}
