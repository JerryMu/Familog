//
//  CommentViewController.swift
//  Familog
//
//  Created by 刘仕晟 on 2019/10/5.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CommentViewController: UIViewController {

    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!

    
    let currentUser = Auth.auth().currentUser?.uid
    var postId: String!
    var postUid: String!
    var comments = [Comment]()
    var users = [User]()
    var commentIDList :[String] = []
     var commentID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Firestore.firestore().collection("Post-comments").document(self.postId).getDocument { (document, error) in
            if let document = document, document.exists {
                return
            } else {
                Firestore.firestore().collection("Post-comments").document(self.postId).setData([
                "commentsID" : []]  )
            }
        }
        
        title = "Comment"
        tableView.dataSource = self
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableView.automaticDimension
        empty()
        handleTextField()
        loadComments()

    }
    
    func loadComments() {
    //     Api.Post_Comment.REF_POST_COMMENTS.child(self.postId).observe(.childAdded, with: {
     //      snapshot in
     //      Api.Comment.observeComments(withPostId: snapshot.key, completion: {
//                comment in
//                self.fetchUser(uid: comment.uid!, completed: {
//                    self.comments.append(comment)
//                    self.tableView.reloadData()
//                })
//            })
//        })
        
        Api.Post_Comment.observePost_Comment(postid: postId){post_comment in
            print(self.postId)
            print(post_comment.commentsID)
            self.commentIDList = post_comment.commentsID
            for i in 0..<self.commentIDList.count{
                Api.Comment.observeComment(commentID: self.commentIDList[i]){comment in
                    self.fetchUser(uid: comment.uid!, completed: {
                                       self.comments.append(comment)
                                       self.tableView.reloadData()
                                   })
                }
                
            }
              //   Api.Post_Comment.updateComment(postid: self.postId, commentsID: ref)
         
    }
    }
    
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        
        Api.User.observeUserByUid(Uid: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
    }
   
    func handleTextField() {
        commentTextField.addTarget(self, action: #selector(self.textFieldDidChange), for: UIControl.Event.editingChanged)
    }
    
    
    // enable sendbutton
   @objc func textFieldDidChange() {
        if let commentText = commentTextField.text, !commentText.isEmpty {
            sendButton.setTitleColor(UIColor.black, for: UIControl.State.normal)
            sendButton.isEnabled = true
            return
        }
        sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
        sendButton.isEnabled = false
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    
    //
    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
       let ref =   Firestore.firestore().collection("Comment").document().documentID
     //   print(ref)
     //   print(self.postId)
         let text = self.commentTextField.text!
        
      //  Api.Post_Comment.observePost_Comment(postid: postId){post_comment in
    //      self.commentID = post_comment.commentsID
    //        self.commentID.append(text)
     //       Api.Post_Comment.updateComment(postid: self.postId, commentsID: ref)
   /*     Firestore.firestore().collection("Post-comments").document(self.postId).setData([
                "commentsID" : ref ,
                
                
            ]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }*/
            
             
        Firestore.firestore().collection("Post-comments").document(self.postId).updateData([
           "commentsID": FieldValue.arrayUnion([ref])
       ])
        
        
            Api.Post.observePost(uid: self.postId){post in
            
            
        self.commentIDList = post.commentsIDList
       
            Firestore.firestore().collection("Comment").document(ref).setData([
                           "commentText": text,
                           "uid": self.currentUser! ,
                       ]) { err in
                           if let err = err {
                               print("Error writing document: \(err)")
                           } else {
                               print("Document successfully written!")
                           }
                       }
     //       self.commentIDList.append(self.commentTextField.text!)
        
      //      Api.Comment.updateComment(commentId: "1", newComment:self.commentTextField.text! )
        }
        self.empty()
        self.view.endEditing(true)
    
    }
    
    
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
    }
    
  }


extension CommentViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
        let comment = comments[indexPath.row]
        let user = users[indexPath.row]
        cell.comment = comment
        cell.user = user
       
        return cell
    }
}

