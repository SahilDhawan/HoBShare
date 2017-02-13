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
            self.displayColor()
        }
    override func viewWillLayoutSubviews() {
        self.displayColor()
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
                    self.displayColor()

                }
                else
                {
                    let alert = UIAlertController.init(title: kAppTitle, message: "Tap to Replace", preferredStyle: .Alert)
                    let action = UIAlertAction.init(title: "Cancel", style: .Destructive, handler: nil)
                    let hobby1 = UIAlertAction.init(title: myHobbies![0].hobbyName, style: .Default, handler: {(action) in
                        self.myHobbies?.removeAtIndex(0)
                        self.myHobbies? += [hobbies![indexPath.item]]
                        self.saveHobbies()
                        self.displayColor()
                        
                    })
                    let hobby2 = UIAlertAction.init(title: myHobbies![1].hobbyName, style: .Default, handler: {(action) in
                        self.myHobbies?.removeAtIndex(1)
                        self.myHobbies? += [hobbies![indexPath.item]]
                        self.saveHobbies()
                        self.displayColor()
                    })
                    let hobby3 = UIAlertAction.init(title: myHobbies![2].hobbyName, style: .Default, handler: {(action) in
                        self.myHobbies?.removeAtIndex(2)
                        self.myHobbies? += [hobbies![indexPath.item]]
                        self.saveHobbies()
                        self.displayColor()
                    })
                    
                    alert.addAction(hobby1)
                    alert.addAction(hobby2)
                    alert.addAction(hobby3)
                    alert.addAction(action)

                    self.presentViewController(alert,animated:true,completion:nil)
                }
            }
            else
            {
                self.showError("Cant have duplicate entries")
            }
        }
        else
        {
            let alert = UIAlertController.init(title: kAppTitle, message: "Would you like to delete this hobby?", preferredStyle: .ActionSheet)
                let deleteAction = UIAlertAction.init(title: "Delete", style: .Destructive, handler: {(action) in
                self.myHobbies!.removeAtIndex(indexPath.item)
                self.saveHobbies()
                    
                self.displayColor()
                })
            let cancelAction = UIAlertAction.init(title: "Cancel", style: .Default, handler: {(action) in
                self.dismissViewControllerAnimated(true, completion: nil)})
            alert.addAction(deleteAction)
            alert.addAction(cancelAction)
            self.presentViewController(alert,animated:true,completion:nil)
        }
    }
    func displayColor()
    {
        for cell in self.allHobbies.visibleCells() as! [HobbyCollectionViewCell]
        {
            cell.backgroundColor = UIColor.darkGrayColor()
            for hobby in myHobbies!
            {
                if cell.HobbyLabel.text == hobby.hobbyName
                {
                    cell.backgroundColor = UIColor.redColor()
                }
            }
        }//all hobbies collection view is affected only!
    }

}
