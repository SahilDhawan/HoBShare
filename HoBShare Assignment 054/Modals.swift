//
//  Modals.swift
//  HoBShare Assignment 054
//
//  Created by Sahil Dhawan on 24/01/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation

class User: SFLBaseModel,JSONSerializable {
    
    var userId : String?
    var userName : String?
    var latitude : Double?
    var longitude : Double?
    var hobbies = [Hobby]()
    var searchHobby : Hobby?
    override init()
    {
        super.init()
        self.delegate = self
    }
    init(userName : String)
    {
        super.init()
        self.delegate = self
        self.userName = userName
    }
    override func getJSONDictionary() -> NSDictionary
    {
        let dict = super.getJSONDictionary()
        
        if self.userName != nil
        {
            dict.setValue(self.userName, forKey: "Username")
        }
        if self.userId != nil
        {
            dict.setValue(self.userId, forKey: "UserId")
        }
        if self.latitude != nil
        {
            dict.setValue(self.latitude, forKey: "Latitude")
        }
        if self.longitude != nil
        {
            dict.setValue(self.longitude, forKey: "Longitude")
        }
        
        
        var jsonSafeHobbiesArray = [String]()
        
        for hobby in self.hobbies{
                jsonSafeHobbiesArray.append(hobby.hobbyName!)
        }
        dict.setValue(jsonSafeHobbiesArray, forKey: "Hobbies")
        
        if self.searchHobby != nil
        {
            dict.setValue(self.searchHobby?.hobbyName, forKey: "HobbySearch")
        }
        return dict
    }
    
    override func readFromJSONDictionary(dict: NSDictionary) {
        
        super.readFromJSONDictionary(dict)
        self.userId = dict["UserId"] as? String
        self.userName = dict["Username"] as? String
        self.latitude = dict["Latitude"] as? Double
        self.longitude = dict["Longitude"] as? Double
        let returnedHobbies = dict["Hobbies"] as? NSArray
        if let hobbies = returnedHobbies
        {
            self.hobbies = Hobby.deserializeHobbies(hobbies)
        }

    }
}


class ListofUser: SFLBaseModel,JSONSerializable {
    
}

class Hobby: SFLBaseModel,NSCoding {
    var hobbyName : String?
    
    init(hobbyName:String?)
    {
        super.init()
        self.hobbyName = hobbyName
    }
    
    required init?(coder aDecoder:NSCoder)
    {
        self.hobbyName = aDecoder.decodeObjectForKey("HobbyName") as? String
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(self.hobbyName,forKey: "HobbyName")
    }

    class func deserializeHobbies(hobbies:NSArray)->Array<Hobby>
    {
        var returnArray = Array<Hobby>()
        for hobby in hobbies
        {
            if let hobbyName = hobby as? String
            {
                returnArray.append(Hobby(hobbyName:hobbyName))
            }
        }
        return returnArray
    }
}
