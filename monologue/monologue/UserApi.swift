//
//  UserApi.swift
//  Familog
//
//  Created by Pengyu Mu on 19/9/19.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
class UserApi {
    var REF_USERS = Database.database().reference().child("users")
    
    func observeUserByUsername(username: String, completion: @escaping (User) -> Void) {
        REF_USERS.queryOrdered(byChild: "username_lowercase").queryEqual(toValue: username).observeSingleEvent(of: .childAdded, with: {
            snapshot in
            print(snapshot)
            if let dict = snapshot.value as? [String: Any] {
                let user = User.transformUser(dict: dict, key: snapshot.key)
                completion(user)
            }
        })
    }
    
    var REF_CURRENT_USER: DatabaseReference? {
        
        guard let currentUser = Auth.auth().currentUser else {
            return nil
        }
        
        return REF_USERS.child(currentUser.uid)
    }
}
