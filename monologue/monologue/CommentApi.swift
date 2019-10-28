//
//  CommentApi.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/5.
//
// fetch comment information from firestore


import FirebaseFirestore
import Foundation
import FirebaseDatabase
import FirebaseAuth


class CommentApi {
    var commentRef = Firestore.firestore().collection("Comment")
    let currentUser = Auth.auth().currentUser?.uid
    
    //update comment
    func updateComment(commentId: String, newComment : String) {
        let commentref = commentRef.document(commentId)
        commentref.updateData(["uid" :currentUser! ,"commentText" :newComment])
    }
    
    //get comment by comment id
    func observeCommentsBycommentID(commentID: String) -> Query{
        return commentRef.order(by: "timestamp", descending: true)
     }
    
    func observeComments(commentID: String,postId: String, completion : @escaping (Comment) -> Void){
        commentRef.order(by: "timestamp", descending: false).whereField("postId", isEqualTo: postId).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let comment = Comment.transformComment(dict: document.data())
                    completion(comment)
                }
            }
                          
        }
    }
}
