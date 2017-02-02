//
//  MeViewController.swift
//  HoBShare Assignment 054
//
//  Created by Sahil Dhawan on 15/01/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit
import MapKit

class MeViewController: HoBShareViewController,UITextFieldDelegate {

    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var latituteLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    
    @IBAction func saveButtonPressed(sender: AnyObject) {
        if validate() == true
        {
            submit()
        }
        else
        {
            self.showError("Did you enter a username?")
        }
    }
    
    
    override func viewDidLoad() {
        textField.delegate = self
    }
    override func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        super.locationManager(manager, didUpdateLocations: locations)
        latituteLabel.text = "Latitude" + " " + "\(currentLocation.coordinate.latitude)"
        longitudeLabel.text = "Longitude" + " " + "\(currentLocation.coordinate.longitude)"
    }
    
    func validate()->Bool
    {
        var valid:Bool = false
        if self.textField.text != nil && (self.textField.text?.characters.count)!>0
        {
            valid = true
        }
        return valid
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if validate() == true
        {
            submit()
        }
        else
        {
            self.showError("Did you enter a username?")
        }
        return true
    }
    func submit()
    {
        textField.resignFirstResponder()
        let requestUser = User(userName:textField.text!)
        requestUser.latitude = currentLocation.coordinate.latitude
        requestUser.longitude = currentLocation.coordinate.longitude
        
        UserDP().getAccountForUser(requestUser){(returnedUser) in
            
            if returnedUser.status.code == 0
            {
                self.myHobbies = returnedUser.hobbies
                NSUserDefaults.standardUserDefaults().setValue(returnedUser.userId, forKey: "CurrentUserId")
                NSUserDefaults().synchronize()
            }
            else
            {

                self.showError(returnedUser.status.statusDescription!)
            }
        }

        
    }
}
