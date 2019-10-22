//
//  DetailViewController.swift
//  Familog
//
//  Created by Pengyu Mu on 10/10/19.
//

import UIKit
import FirebaseFirestore

class DetailViewController: UIViewController {

    var postId = ""
    var post = Post()
    var user = User()
    var commentUsers = [User]()
    var comments = [Comment]()
    let commentRef = Firestore.firestore().collection("Comment")
    
    @IBOutlet weak var deletePostButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.dataSource = self
        super.viewDidLoad()
        loadPost()
    }

    func loadPost() {
        Api.Post.observePost(uid: postId) { (post) in
            guard let postUid = post.userId else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.post = post
                self.fetchComment(postId: self.postId)
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchCommentUsers(uid: String, completed:  @escaping () -> Void ) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.commentUsers.append(user)
            completed()
        })
    }
    
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.User.observeUser(uid: uid, completion: {
            user in
            self.user = user
            if(user.uid != Api.User.currentUser!.uid){
                self.deletePostButton.isHidden = true
            }
            completed()
        })
        
    }
    
    func fetchComment(postId : String) {
        commentRef.order(by: "timestamp", descending: false).whereField("postId", isEqualTo: postId).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let comment = Comment.transformComment(dict: document.data())
                    self.fetchCommentUsers(uid: comment.uid!, completed: {
                        self.comments.append(comment)
                        self.tableView.reloadData()
                    })
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Detail_CommentVC" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender  as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "Detail_ProfileUserSegue" {
            let profileVC = segue.destination as! OthersProfileViewController
            let userId = sender  as! String
            profileVC.uid = userId
        }
    }
    
    @IBAction func deletePostButtonTapped(_ sender : Any) {
        print(self.postId)
        Api.Post.deletePost(PostId: self.postId)
        moveToProfilePage()
    }
    
    func moveToProfilePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        newViewController.selectedIndex = 2
        self.present(newViewController, animated: true, completion: nil)
    }
    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row < 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! DetailViewCell
            cell.post = post
            cell.user = user
            cell.delegate = self
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentTableViewCell
            if(indexPath.row < comments.count && indexPath.row < commentUsers.count){
                let comment = comments[indexPath.row]
                let user = commentUsers[indexPath.row]
                cell.delegate = self
                cell.comment = comment
                cell.user = user
            }
            return cell
            }
    }
}

extension DetailViewController: DetailTableViewCellDelegate, CommentTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "Detail_CommentVC", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Detail_ProfileUserSegue", sender: userId)
    }
}

