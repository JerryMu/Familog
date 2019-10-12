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
  
  /*  var REF_COMMENTS = Database.database().reference().child("comments")
    
    func observeComments(withPostId id: String, completion: @escaping (Comment) -> Void) {
        REF_COMMENTS.child(id).observeSingleEvent(of: .value, with: {
            snapshot in
            if let dict = snapshot.value as? [String: Any] {
                let newComment = Comment.transformComment(dict: dict)
                completion(newComment)
            }
        })
    }*/
    // get the comment
    func observeComments(commentID: String, completion : @escaping (Comment) -> Void){
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
         
         }
    func updateComment(commentId: String, newComment : String)
    {
        let commentref = commentRef.document(commentId)
        
        commentref.updateData(["uid" :currentUser! ,"commentText" :newComment])

    }
  /*  func setupComment(postId: String, newComment : String)
     {
        let commentref = commentRef.document(postId)
         
         commentref.putData(["uid" :currentUser ,"commentText" :newComment ])

     }
     
    */
    


}
