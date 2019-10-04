//
//  FamilyApi.swift
//  Familog
//
//  Created by Pengyu Mu on 2/10/19.
//
//
import Foundation
import FirebaseAuth
import FirebaseFirestore

class FamilyApi{
    
    func observeFamily(){
        
    }
    
    let currentUser = Auth.auth().currentUser!.uid
    let userRef = Firestore.firestore().collection("User")
    var familyId:String = ""
    
    func getFamilyId() {
        userRef.document(currentUser).getDocument {(document, error) in
            if let document = document, document.exists {
                self.familyId = document.get("familyId") as! String
            } else {
                print("Family does not exist")
            }
        }
    }
}
