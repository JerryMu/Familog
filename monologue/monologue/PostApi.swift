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
    var postRef = Firestore.firestore().collection("AllPost")
    var userPosts = [Post]()
    var familyPosts = [Post]()
    
    func observePost(uid: String,completion: @escaping (Post) -> Void){
        let document = postRef.document(uid)
        document.getDocument { (document, error) in
            if let post = document.flatMap({
                $0.data().flatMap({ (data) in
                    return Post.transformPostPhoto(dict: data)
                })
            })
            {
                completion(post)
            }
            else{
                print("Post not found")
            }
        }
    }
    func observePostsNumberByUser(userId: String, completion : @escaping (Int) -> Void){
        
        postRef.whereField("userId", isEqualTo: userId).getDocuments{(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                completion((querySnapshot?.documents.count)!)
            }
        }
        
    }
    func observePostsByUser(userId: String) -> Query{
        
        return postRef.whereField("userId", isEqualTo: userId)
        
    }
    
    func observePostsByFamily(familyId: String) -> Query{
        return postRef.whereField("familyId", isEqualTo: familyId)
    }
    
}
