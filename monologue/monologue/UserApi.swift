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
import FirebaseDatabase
class UserApi {
    
    var REF_USERS = Firestore.firestore().collection("Users")
    let currentUser = Auth.auth().currentUser!.uid
    
    func observeUserByUid(Uid: String) -> Query{
        return REF_USERS.whereField("uid", isEqualTo: Uid)

    }
    
    func observeUser(uid : String, completion: @escaping (User) -> Void){
        let userRef = REF_USERS.document(uid)

        userRef.getDocument { (document, error) in
            if let user = document.flatMap({
                $0.data().flatMap({ (data) in
                    return User.transformUser(dict: data)
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
    
    
    func observeCurrentUser(completion: @escaping (User) -> Void){
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let userRef = REF_USERS.document(currentUser.uid)

        userRef.getDocument { (document, error) in
            if let user = document.flatMap({
                $0.data().flatMap({ (data) in
                    return User.transformUser(dict: data)
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
    
    func setUserByUid(Uid : String, dictionary : [String : Any]){
        let userRef = REF_USERS.document(Uid)
        
        userRef.updateData(dictionary)
    }
    
    func setCurrentUser(dictionary : [String : Any]){
        guard let currentUser = Auth.auth().currentUser else {
            return
        }
        let userRef = REF_USERS.document(currentUser.uid)
        
        userRef.updateData(dictionary)
    }
}

