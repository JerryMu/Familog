//
//  User.swift
//  Familog
//
//  Created by Pengyu Mu on 12/9/19.
//

import Foundation
class User {
    var email: String?
    var profileImageUrl: URL?
    var firstname: String?
    var lastname: String?
    var id: String?
    var age : String?
    var bio : String?
    var postNumber : Int?
}

extension User {
    
    static func transformUser(dict: [String: Any], key: String) -> User {
        let user = User()
        user.email = dict["email"] as? String
        user.profileImageUrl = dict["profileImageUrl"] as? URL
        user.firstname = dict["firstname"] as? String
        user.lastname = dict["lastname"] as? String
        user.id = key
        user.bio = dict["bio"] as? String
        return user
    }
}
