//
//  Family.swift
//  Familog
//
//  Created by Pengyu Mu on 2/10/19.
//
//Family class for store data

import Foundation

class Family {
    var profileImageUrl: URL?
    var familyName: String?
    var uid: String?
    var introduce : String?
    var familyOwner : String?
    var userNumber : Int?
}

extension User {
    
    static func transformFamily(dict: [String: Any], key: String) -> Family {
        let family = Family()
        family.profileImageUrl = dict["profileImageUrl"] as? URL
        family.familyName = dict["familyName"] as? String
        family.uid = dict["uid"] as? String
        family.introduce = dict["introduce"] as? String
        family.familyOwner = dict["familyOwner"] as? String
        family.userNumber = dict["userNumber"] as? Int
        return family
    }
}
