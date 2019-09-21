//
//  User.swift
//  Familog
//
//  Created by Pengyu Mu on 12/9/19.
//

import Foundation
class User {
    var email: String?
    var profileImageUrl: String?
    var firstname: String?
    var lastname: String?
    var id: String?
    var age : String?
    var bio : String?
}

extension User {
    
    static func transformUser(dict: [String: Any], key: String) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? String
        user.firstname = dict["firstname"] as? String
        user.lastname = dict["lastname"] as? String
        user.id = dict["uid"] as? String
        user.bio = dict["bio"] as? String
        return user
    }
}
