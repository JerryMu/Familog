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
//    let postRef = Firestore.firestore().collection("AllPost")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 521
        tableView.dataSource = self
        loadPosts()
    }
    
    @IBAction func button_TouchUpInside(_ sender: Any) {
        self.performSegue(withIdentifier: "CommentSegue", sender: nil)
        
    }
    func getFamily() {
        userRef.document(currentUser).getDocument {(document, error) in
            if let document = document, document.exists {
                self.familyId = document.get("familyId") as! String
            } else {
                print("Family does not exist")
            }
        }
            
    }

    
  func loadPosts() {
//        Api.Post.observePostsByFamily(familyId: familyId, familyPost: posts)
        self.tableView.reloadData()
        Api.Post.observePostsByFamily(familyId: fakeFamilyID).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    Api.Post.observePost(uid: document.documentID, completion:  { (post) in
                        self.posts.append(post)
                        //get user for each post
                        Api.User.observeUserByUid(Uid: post.userId!){user in
                            self.users.append(user)
                            self.tableView.reloadData()
                        }
                    })
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

}
    
    

// Use fake data to show that our post can be displayed correctly
extension TimelineViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! TimelineTableViewCell
        let post = posts[indexPath.row]
        let user = users[indexPath.row]
        print("User",users.count)
        print("Post",posts.count)
        cell.post = post
        cell.user = user
        cell.delegate = self
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

