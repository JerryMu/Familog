//
//  CommentApi.swift
//  Familog
//
//  Created by 刘仕晟 on 2019/10/5.
//
import FirebaseFirestore
import Foundation
import FirebaseDatabase
import FirebaseAuth
class CommentApi {
     var commentRef = Firestore.firestore().collection("Comment")
     let currentUser = Auth.auth().currentUser?.uid
  
  
    // get the comment
/*    func observeComments(commentID: String, completion : @escaping (Comment) -> Void){
        commentRef.document(commentID)
             .addSnapshotListener { documentSnapshot, error in
                guard let document = documentSnapshot else {
                 print("Error fetching document: \(error!)")
                 return
               }
               guard let data = document.data() else {
                 print("Document data was empty.")
                 return
               }
                 if let dict = documentSnapshot!.data() {
             
                     let comment = Comment.transformComment(dict: dict)
                        completion(comment)
                }
         }
         
         }*/
    func updateComment(commentId: String, newComment : String)
    {
        let commentref = commentRef.document(commentId)
        
        commentref.updateData(["uid" :currentUser! ,"commentText" :newComment])

    }
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
