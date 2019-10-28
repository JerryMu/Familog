//
//  DetailViewController.swift
//  Familog
//
//  Created by Pengyu Mu on 10/10/19.
//
// This class is for showing detail of users' posts and provide delete function

import UIKit
import FirebaseFirestore
import Lightbox

class DetailViewController: UIViewController {

    var postId = ""
    var post = Post()
    var user = User()
    var commentUsers = [User]()
    var comments = [Comment]()
    let commentRef = Firestore.firestore().collection("Comment")
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        tableView.dataSource = self
        super.viewDidLoad()
        loadPost()
    }

    //send data to table view
    func loadPost() {
        Api.Post.observePost(uid: postId) { (post) in
            guard let postUid = post.userId else {
                return
            }
            self.fetchUser(uid: postUid, completed: {
                self.post = post
                self.tableView.reloadData()
            })
        }
    }
    
    //get user information
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.User.observeUser(uid: uid, completion: {
            user in
            self.user = user
            completed()
        })
        
    }
    
    //functions of jump to other pages
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
    

    
}

extension DetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! DetailViewCell
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
        
    }
}

extension DetailViewController: DetailTableViewCellDelegate, CommentTableViewCellDelegate {
    
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "Detail_CommentVC", sender: postId)
    }
    //go to others profile page
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Detail_ProfileUserSegue", sender: userId)
    }
    //move to users' own profile page
    func moveToProfilePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        newViewController.selectedIndex = 2
        self.present(newViewController, animated: true, completion: nil)
    }
    // present detailed image
    func presentImage(imageViewController : LightboxController){
        self.present(imageViewController, animated: true, completion: nil)
    }
}

