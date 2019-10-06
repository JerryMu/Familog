//
//  UserApi.swift
//  Familog
//
//  Created by Pengyu Mu on 19/9/19.
//
// This file mainly shows how we look for users in the database and extract information about this user.

import Foundation
import FirebaseFirestore
import FirebaseAuth
class UserApi {
    var REF_USERS = Firestore.firestore().collection("Users")
    
    func observeUserByUid(Uid: String, completion: @escaping (User) -> Void){
        let userRef = REF_USERS.document(Uid)
        
        userRef.getDocument { (document, error) in
            if let user = document.flatMap({
                $0.data().flatMap({ (data) in
                    return User.transformUser(dict: data, key: Uid)
                })
            })
            {
                completion(user)
            }
            else{
                print("User not found")
            }
        }

    }
    
//    func setUserByUid(Uid : String, dictionary : [String : Any]){
//        let userRef = REF_USERS.document(Uid)
//
//        userRef.setData(dictionary)
//    }
    
}

