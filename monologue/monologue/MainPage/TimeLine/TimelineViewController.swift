//
//  TimelineViewController.swift
//  Familog
//
//  Created by Ziyuan on 18/09/19.
//
//  This file works primarily for the Timeline page, which defines how we use the table cell to display our post.
import UIKit
import FirebaseAuth
import FirebaseFirestore
import SDWebImage
class TimelineViewController: UIViewController {

//  Each of our tablecells is dynamic.
//  It can determine the width of each cell based on the length of the text uploaded by the user.
    @IBOutlet weak var tableView: UITableView!
    
    var posts = [Post]()
    var users = [User]()
    var familyId: String = ""
    let currentUser = Auth.auth().currentUser!.uid
    let userRef = Firestore.firestore().collection("User")
    let fakeFamilyID = "123456"
    let refreshControl = UIRefreshControl()
//    let NaviImg = UIImage(named: "NaviBackground")

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.reloadData()
        getFamilyId()
        navigationController?.navigationBar.shadowImage = UIImage()
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 650
        tableView.rowHeight = UITableView.automaticDimension
        tableView.dataSource = self
        loadPosts()
    }
    
    
    @objc func refresh() {
        posts.removeAll()
        users.removeAll()
        loadPosts()
    }
    
    func getFamilyId() {
        Api.User.REF_USERS.document(Api.User.currentUser).getDocument{(document, error) in
                if let document = document, document.exists {
                    self.familyId = document.get("familyId") as! String
                    if self.familyId == "" {
                        self.moveToFamilyPage()
                    }
                }
        }
    }
    
    func loadPosts() {
        Api.Post.observePostsByFamily(familyId: fakeFamilyID).addSnapshotListener{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
//                    Api.Post.observePost(uid: document.documentID, completion:  { (post) in
                    let post = Post.transformPostPhoto(dict: document.data())
                        self.posts.insert(post, at: 0)
                        self.tableView.reloadData()
                        //get user for each post
                    Api.User.observeUserByUid(Uid: post.userId!).addSnapshotListener{ (querySnapshot, err) in
                            if let err = err {
                                print("Error getting documents: \(err)")
                            } else {
                                for document in querySnapshot!.documents {
                                    let user = User.transformUser(dict: document.data())
                                    self.users.insert(user, at: 0)
                                    self.tableView.reloadData()
                                }
                            }
                    }
                }
            }
        }
    }
     
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "CommentSegue" {
                let commentVC = segue.destination as! CommentViewController
                let postId = sender  as! String
                commentVC.postId = postId
            }
    }
     func moveToFamilyPage() {
            let storyBoard = UIStoryboard(name: "Family", bundle: nil)
            let newViewController = storyBoard.instantiateViewController(withIdentifier: "familyVC")
            self.present(newViewController, animated: true, completion: nil)
        }
    

}
    
    

// Use fake data to show that our post can be displayed correctly
extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! TimelineTableViewCell
        if(posts.count == users.count){
            let post = posts[indexPath.row]
            let user = users[indexPath.row]
            cell.post = post
            cell.user = user
            cell.delegate = self
        }
        return cell
    }
}

extension TimelineViewController: TimelineTableViewCellDelegate {
    func goToCommentVC(postId: String) {
        performSegue(withIdentifier: "CommentSegue", sender: postId)
    }
    func goToProfileUserVC(userId: String) {
        performSegue(withIdentifier: "Home_ProfileSegue", sender: userId)
    }
}

