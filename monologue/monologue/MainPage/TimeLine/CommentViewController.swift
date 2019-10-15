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

    @IBOutlet weak var currentUserAvatar: UIImageView!
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    private var messageListener: ListenerRegistration?
    private var reference: CollectionReference?
    let currentUser = Auth.auth().currentUser?.uid
    var postId: String!
    var postUid: String!
    var comments = [Comment]()
    var users = [User]()
    var commentIDList :[String] = []
    var commentID: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
      
        reference = Firestore.firestore().collection(["Post-comments", self.postId, "Comment"].joined(separator: "/"))
       
        
        messageListener = reference?.addSnapshotListener { querySnapshot, error in
          guard let snapshot = querySnapshot else {
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
          }
          
          snapshot.documentChanges.forEach { change in
           
           
            self.commentID =  change.document.data()["commentsID"] as? String
            
         
            Api.Comment.observeComments(commentID: self.commentID){comment in
                           self.fetchUser(uid: comment.uid!, completed: {
                           
                                              self.comments.append(comment)
                                          
                                              self.tableView.reloadData()
                                          })
                       }
            
            
            }
        }
        title = "Comment"
        tableView.dataSource = self
        tableView.estimatedRowHeight = 77
        tableView.rowHeight = UITableView.automaticDimension
        empty()
        handleTextField()
     

    }
    
         
        
    
    //test
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        
                Api.User.observeUser(withId: uid, completion: {
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
        let text = self.commentTextField.text!
        reference?.addDocument(data:[
            "commentsID": ref] ) { error in
          if let e = error {
            print("Error sending message: \(e.localizedDescription)")
            return
          }
          }
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
        cell.delegate = self
        cell.comment = comment
        cell.user = user
       
        return cell
    }
}

extension CommentViewController: CommentTableViewCellDelegate {
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Comment_ProfileSegue", sender: userId)
    }
}

