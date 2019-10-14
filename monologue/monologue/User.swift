//
//  User.swift
//  Familog
//
//  Created by Pengyu Mu on 12/9/19.
//
// This file mainly shows what important information will be recorded by us in our database.

import Foundation
import MessageKit
class User {
    var email: String?
    var profileImageUrl: String?
    var firstname: String?
    var lastname: String?
    var uid: String?
    var dob : String = "Unknow"
    var bio : String?
    var postNumber = 0
    var familyId : String?
    var families : [String]?
//    var dictionary: [String: Any] {
//        return ["email": email!,
//                "profileImageUrl": profileImageUrl!,
//                "firstname": firstname!,
//                "lastname" : lastname!,
//                "bio" : bio!
//                ]
//    }
}





extension User {
    
    static func transformUser(dict: [String: Any]) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.firstname = dict["firstname"] as? String
        user.lastname = dict["lastname"] as? String
        user.uid = dict["uid"] as? String
        user.bio = dict["bio"] as? String
        user.familyId = dict["familyId"] as? String
//        user.dob = dict["dob"] as! String
        return user
    }
//    var nsDictionary: NSDictionary {
//        return dictionary as NSDictionary
//    }
}
