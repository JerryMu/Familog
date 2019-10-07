//
//  PostApi.swift
//  Familog
//
//  Created by 袁翥 on 2019/9/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth
import FirebaseDatabase
import SDWebImage

class PostApi {
    var postRef = Firestore.firestore().collection("AllPost")
    var userPosts = [Post]()
    var familyPosts = [Post]()
     var REF_POSTS = Database.database().reference().child("posts")
    
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
        }    }
    
    
    func observePosts(completion: @escaping (Post) -> Void) {
        REF_POSTS.observe(.childAdded) { (snapshot: DataSnapshot) in
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict)
                completion(newPost)
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
    
    func setPostByUid(Uid : String, dictionary : [String : Any]){
        let post = postRef.document(Uid)
        
        post.updateData(dictionary)
    }
    
}
