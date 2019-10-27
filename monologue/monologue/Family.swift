//
//  Family.swift
//  Familog
//
//  Created by Pengyu Mu on 2/10/19.
//
//Family class for store data

import Foundation

class Family {
    var profileImageUrl: String?
    var familyName: String?
    var uid: String?
    var introduce : String?
    var userNumber : Int?
}

extension Family {
    
    static func transformFamily(dict: [String: Any]) -> Family {
        let family = Family()
        family.profileImageUrl = dict["profileImageUrl"] as? String
        family.familyName = dict["familyName"] as? String
        family.uid = dict["uid"] as? String
        family.introduce = dict["introduce"] as? String
        family.userNumber = dict["userNumber"] as? Int
        return family
    }
}
