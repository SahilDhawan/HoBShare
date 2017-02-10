//
//  DataProviders.swift
//  HoBShare Assignment 054
//
//  Created by Sahil Dhawan on 24/01/17.
//  Copyright © 2017 Sahil Dhawan. All rights reserved.
//

import Foundation

let serverPath = "http://uci.smilefish.com/HBSRest-Dev/api/"
let endPoint = "HobbyRest"

class UserDP: NSObject {
    
    func getAccountForUser(user:User,completion:(User)->())
    {
        let requestUrlString = serverPath+endPoint
        let HTTPMethod = "CREATE_USER"
        let requestModel = user
        
        SFLConnection().ajax(requestUrlString, verb: HTTPMethod, requestBody: requestModel){
            (returnJSONDict) in
            let dict = NSDictionary(dictionary:returnJSONDict)
            let returnedUser = User()
            returnedUser.readFromJSONDictionary(dict)
            completion(returnedUser)
        }
    }
    func fetchUsersForHobby(user:User,hobby:Hobby,completion:
        (ListofUsers) -> ())
    {
        let requestUrlString = serverPath+endPoint
        let HTTPMethod = "FETCH_USERS_WITH_HOBBY"
        let requestModel = user
        requestModel.searchHobby = hobby
        SFLConnection().ajax(requestUrlString, verb: HTTPMethod, requestBody: requestModel){(returnJSONDict) in
            let dict = NSDictionary(dictionary: returnJSONDict)
            let returnedListOfUsers = ListofUsers()
            returnedListOfUsers.readFromJSONDictionary(dict)
            completion(returnedListOfUsers)
        }
    }
    
}
class HobbyDP: NSObject {
    func fetchHobbies() -> [String : [Hobby]]
    {
        return ["TECHNOLOGY" : [Hobby(hobbyName:"Video Games"),
                                Hobby(hobbyName:"Computers"),
                                Hobby(hobbyName:"IDEs"),
                                Hobby(hobbyName:"Smartphones"),
                                Hobby(hobbyName:"Programming"),
                                Hobby(hobbyName:"Electronics"),
                                Hobby(hobbyName:"Gadgets"),
                                Hobby(hobbyName:"Product Reviews"),
                                Hobby(hobbyName:"Computer Repair"),
                                Hobby(hobbyName:"Software"),
                                Hobby(hobbyName:"Hardware"),
                                Hobby(hobbyName:"Apple"),
                                Hobby(hobbyName:"Google"),
                                Hobby(hobbyName:"Microsoft")]]
    }
    func saveHobbiesForUser(user:User,completion:(User)->())
    {
        let requestUrlString = serverPath+endPoint
        let HTTPMethod = "SAVE_HOBBIES"
        let requestModel = user
        SFLConnection().ajax(requestUrlString,verb:HTTPMethod,requestBody:requestModel)
        {(returnJSONDict)in
            let returnedUser = User()
            returnedUser.readFromJSONDictionary(returnJSONDict)
            completion(returnedUser)
        }
    }

}

