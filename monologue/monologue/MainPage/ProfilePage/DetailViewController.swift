//
//  DetailViewController.swift
//  Familog
//
//  Created by Pengyu Mu on 10/10/19.
//

import UIKit

class DetailViewController: UIViewController {

    var postId = ""
    var post = Post()
    var user = User()
    
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
                self.tableView.reloadData()
            })
        }
    }
    
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.User.observeUser(uid: uid, completion: {
            user in
            self.user = user
            if(user.uid != Api.User.currentUser){
                self.deletePostButton.isHidden = true
            }
            completed()
        })
        
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! TimelineTableViewCell
        cell.post = post
        cell.user = user
        cell.delegate = self
        return cell
    }
}

extension DetailViewController: TimelineTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "Detail_CommentVC", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Detail_ProfileUserSegue", sender: userId)
    }
}
