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
    
    let currentUser = Auth.auth().currentUser?.uid
    let REF_FAMILY = Firestore.firestore().collection("Family")
    var familyId:String = ""
    
    
    func setFamilyByUid(Uid : String, dictionary : [String : Any]){
        let family = REF_FAMILY.document(Uid)
        
        family.updateData(dictionary)
    }
    
    
}
