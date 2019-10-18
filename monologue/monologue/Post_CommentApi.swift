//
//  Post_CommentApi.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/5.
//

import Foundation
import FirebaseDatabase
import FirebaseFirestore
class Post_CommentApi {
    var post_commentRef = Firestore.firestore().collection("Post-comments")
    
    
    func observePost_Comment(postid: String,completion: @escaping (Post_Comment) -> Void){
           let document = post_commentRef.document(postid)
           document.getDocument { (document, error) in
               if let post_comment = document.flatMap({
                   $0.data().flatMap({ (data) in
                       return Post_Comment.transformPost_Comment(dict: data)
                   })
               })
               {
                   completion(post_comment)
               }
               else{
                   print("Post not found")
               }
           }
           
       }
    
    func updateComment(postid: String, commentsID: String)
    {
        let post_commentref = post_commentRef.document(postid)
        
            post_commentref.updateData(["commentid" : commentsID])

    }
}
