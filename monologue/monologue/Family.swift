//
//  Family.swift
//  Familog
//
//  Created by Pengyu Mu on 2/10/19.
//
//Family class for store data

import Foundation

class Family {
    // the name of this family
    var familyName: String?
    // unique id of this family
    var uid: String?
}

extension Family {
    //convert firebase dictionary to Family instance
    static func transformFamily(dict: [String: Any]) -> Family {
        let family = Family()
        family.familyName = dict["familyName"] as? String
        family.uid = dict["uid"] as? String
        return family
    }
}
