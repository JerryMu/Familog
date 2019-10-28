//
//  PostApi.swift
//  Familog
//
//  Created by 袁翥 on 2019/9/23.
//
// fetch data of post from firebase

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class PostApi {
    var postRef = Firestore.firestore().collection("Post")
    var userPosts = [Post]()
    var familyPosts = [Post]()
    // get the information from the database
    
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
    
    
    // update comment to post
    func updateComment(postId: String, commentsIDList : String)
    {
        let postref = postRef.document(postId)
        
            postref.updateData(["comment" : commentsIDList])

    }
    
    //get post number from user id
    func observePostsNumberByUser(userId: String, completion : @escaping (Int) -> Void){
        
        postRef.whereField("userId", isEqualTo: userId).getDocuments{(querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                completion((querySnapshot?.documents.count)!)
            }
        }
        
    }
    
    //get all post of this user
    func observePostsByUser(userId: String) -> Query{
        
        return postRef.whereField("userId", isEqualTo: userId)
        
    }
    
    //get all post of a family
    func observePostsByFamily(familyId: String) -> Query{
        return postRef.order(by: "timestamp", descending: true).whereField("familyId", isEqualTo: familyId)
    }
    
    // delete a post from firebase by id
    func deletePost(PostId : String){
        postRef.document(PostId).delete(){ err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    
    //update post data by id
    func setPostByUid(Uid : String, dictionary : [String : Any]){
        let post = postRef.document(Uid)
        
        post.updateData(dictionary)
    }
    
}
