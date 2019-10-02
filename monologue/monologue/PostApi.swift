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
    
    func observePost(document: DocumentReference,completion: @escaping (Post) -> Void){
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
    func observePostsByUser(userId: String, userPosts: [Post]){
        postRef.whereField("userId", isEqualTo: userId).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let postdb = self.postRef.document(document.documentID)
                    self.observePost(document: postdb, completion:  { (post) in
                        Api.User.observeUserByUid(Uid: document.get("userId") as! String, completion: { (user) in
                            post.username = user.firstname! + " " + user.lastname!
                            self.userPosts.append(post)
                        })
                    })
                }
            }
        }
    }
    
    func observePostsByFamily(familyId: String, familyPost: [Post]){
        postRef.whereField("userId", isEqualTo: familyId).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let postdb = self.postRef.document(document.documentID)
                    self.observePost(document: postdb, completion:  { (post) in
                        Api.User.observeUserByUid(Uid: document.get("userId") as! String, completion: { (user) in
                            post.username = user.firstname! + " " + user.lastname!
                            self.familyPosts.append(post)
                        })
                    })
                }
            }
        }
    }
    
}
