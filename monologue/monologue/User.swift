//
//  User.swift
//  Familog
//
//  Created by Pengyu Mu on 12/9/19.
//
// This file mainly shows what important information will be recorded by us in our database.

import Foundation
class User {
    var email: String?
    var profileImageUrl: URL?
    var firstname: String?
    var lastname: String?
    var uid: String?
    var age : String?
    var bio : String?
    var postNumber = 0
    var familyId : String?
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
    
    static func transformUser(dict: [String: Any], key: String) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? URL
        user.firstname = dict["firstname"] as? String
        user.lastname = dict["lastname"] as? String
        user.uid = key
        user.bio = dict["bio"] as? String
        return user
    }
//    var nsDictionary: NSDictionary {
//        return dictionary as NSDictionary
//    }
}
