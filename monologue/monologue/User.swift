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
    // the email of user
    var email: String?
    // the url of user's profile image in fire base
    var profileImageUrl: String?
    // the first name of a user
    var firstname: String?
    // the user id in firebase of user
    var uid: String?
    // the date of bieth of user
    var dob : String = "Unknow"
    //the biography of user
    var bio : String?
    //user's family id
    var familyId : String?
    //all family user joined
    var families : [String]?
}





extension User {
    // convert firebase snapshot to a User instance
    static func transformUser(dict: [String: Any]) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.firstname = dict["firstname"] as? String
        user.uid = dict["uid"] as? String
        user.bio = dict["bio"] as? String
        user.familyId = dict["familyId"] as? String
        user.dob = dict["dob"] as! String
        user.families = dict["families"] as? [String]
        return user
    }
}
