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

    
    let currentUser = Auth.auth().currentUser?.uid
    let REF_FAMILY = Firestore.firestore().collection("Family")
    var familyId:String = ""
    
    
    func setFamilyByUid(Uid : String, dictionary : [String : Any]){
        let family = REF_FAMILY.document(Uid)
        
        family.updateData(dictionary)
    }
    
    func getFamilyNameById(familyId : String, completion: @escaping (String) -> Void){
        REF_FAMILY.document(familyId).getDocument() { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data()!["familyName"] ?? "nil"
                    completion(dataDescription as? String ?? "Family")
                } else {
                    print("Document does not exist\n\n\n")
                }
            }
        }
}
