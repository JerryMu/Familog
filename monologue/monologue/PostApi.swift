//
//  PostApi.swift
//  Familog
//
//  Created by 袁翥 on 2019/9/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class PostApi {
    var REF_USER = Firestore.firestore().collection("Users")
    
    
    func observePost(Uid: String, completion: @escaping (Post) -> Void){
        
        let postRef = REF_USER.document(Uid).collection("Post")
        postRef.getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let postdb = postRef.document(document.documentID)
                    postdb.getDocument { (document, error) in
                        if let post = document.flatMap({
                            $0.data().flatMap({ (data) in
                                return Post.transformPostPhoto(dict: data)
                            })
                        })
                        {
                            print("POST\(post)")
                            completion(post)
                        }
                        else{
                            print("User not found")
                        }
                    }
                }
            }
        }
    }
}
