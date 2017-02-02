//
//  EditHoBShareViewController.swift
//  HoBShare Assignment 054
//
//  Created by Sahil Dhawan on 15/01/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import UIKit

class EditHoBShareViewController: HoBShareViewController {

    @IBOutlet weak var allHobbies: UICollectionView!
    
   override func viewDidLoad()
        {
            super.viewDidLoad()
            self.allHobbies.delegate = self
        }
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView
        {
         let resuableView = collectionView.dequeueReusableSupplementaryViewOfKind(kind, withReuseIdentifier: "HobbyCategoryHeader", forIndexPath: indexPath)
            
            (resuableView as! HobbiesCollectionViewHeader).categoryLabel.text = Array(availableHobbies.keys)[indexPath.section]
            
            return resuableView
        }
    func saveHobbies()
    {
       let requestUser = User()
        requestUser.userId = NSUserDefaults.standardUserDefaults().valueForKey("CurrentUserId") as? String
        if let myHobbies = self.myHobbies
        {
            requestUser.hobbies = myHobbies
        }
            HobbyDP().saveHobbiesForUser(requestUser){(returnedUser)->() in
            if returnedUser.status.code == 0
            {
                self.saveHobbiesToUserDefaults()
                self.collectionView.reloadData()
            }
            else
            {
                self.showError(returnedUser.status.statusDescription!)
            }
            }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        if collectionView == self.allHobbies
        {
            let key = Array(availableHobbies.keys)[indexPath.section]
            let hobbies = availableHobbies[key]
            let hobby = hobbies![indexPath.item]
            if myHobbies?.contains({$0.hobbyName == hobby.hobbyName}) == false
            {
                if myHobbies?.count<kMaxHobbies
                {
                    myHobbies! += [hobby]
                    self.saveHobbies()
                }
                else
                {
                    let alert = UIAlertController.init(title: kAppTitle, message: "You may only select \(kMaxHobbies) hobbies . Please delete a hobby, then try again", preferredStyle: .Alert)
                    let action = UIAlertAction.init(title: "Dismiss", style: .Default, handler: nil)
                    alert.addAction(action)
                    self.presentViewController(alert,animated:true,completion:nil)
                }
            }
        }
        else
        {
            let alert = UIAlertController.init(title: kAppTitle, message: "Would you like to delete this hobby?", preferredStyle: .ActionSheet)
            let deleteAction = UIAlertAction.init(title: "Dismiss", style: .Destructive, handler: {(action) in
                self.myHobbies!.removeAtIndex(indexPath.item)
                self.saveHobbies()
                })
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .Default, handler: {(action) in
                self.dismissViewControllerAnimated(true, completion: nil)})
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert,animated:true,completion:nil)
        }
    }
}
