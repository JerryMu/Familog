//
//  UserApi.swift
//  Familog
//
//  Created by Pengyu Mu on 19/9/19.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
class UserApi {
    var REF_USERS = Firestore.firestore().collection("Users")
    
    func observeUserByUid(Uid: String){
        let userRef = REF_USERS.document(Uid)
        
        userRef.getDocument { (document, error) in
            if let user = document.flatMap({
                $0.data().flatMap({ (data) in
                    return User.transformUser(dict: data, key: Uid).firstname
                })
            }) {
                print("User: \(user)")
            } else {
                print("Document does not exist")
            }
        }
    }
//    func getCurrent(){
//        return Auth.auth().currentUser!.uid
//    }
}
