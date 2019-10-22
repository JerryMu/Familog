//
//  CommentViewController.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/5.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

class CommentViewController: UIViewController {
     let refreshControl = UIRefreshControl()
    var commentRef = Firestore.firestore().collection("Comment")
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
    
    func setupUserInfo() {
        Api.User.observeUser(withId: currentUser!, completion: {
                       user in
            if let photoUrlString = user.profileImageUrl {
                let photoUrl = URL(string: photoUrlString)
                self.currentUserAvatar.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Head_Icon"))
           }
        })
   }
    @objc func refresh() {
        comments.removeAll()
        users.removeAll()
        load()
        refreshControl.endRefreshing()
    }
    func load(){
        Api.User.observeCurrentUser(){ currentUser in
            self.loadPosts(postId : self.postId)
        }
    }

    func loadPosts(postId : String) {
        commentRef.order(by: "timestamp", descending: false).whereField("postId", isEqualTo: postId).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let comment = Comment.transformComment(dict: document.data())
                    self.fetchUser(uid: comment.uid!, completed: {
                        self.comments.append(comment)
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUserInfo()
        self.refresh()
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
    
    @IBAction func sendButton_TouchUpInside(_ sender: Any) {
        let timestamp = Int(Date().timeIntervalSince1970)
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
            "timestamp": timestamp,
            "uid": self.currentUser! ,
            "postId":self.postId]) { err in
                if let err = err {
                    print("Error writing document: \(err)")
                } else {
                    print("Document successfully written!")
                }
            }
        self.empty()
        self.view.endEditing(true)
        refresh()
    }
    
    
    func empty() {
        self.commentTextField.text = ""
        self.sendButton.isEnabled = false
        sendButton.setTitleColor(UIColor.lightGray, for: UIControl.State.normal)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Comment_ProfileSegue" {
            let detailVC = segue.destination as! OthersProfileViewController
            let userId = sender  as! String
            detailVC.uid = userId
        }
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

