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
    let userRef = Firestore.firestore().collection("Users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 521
        tableView.dataSource = self
        tableView.delegate = self
        loadPosts()
    }
    
    func loadPosts() {
//       //let currentUser = Auth.auth().currentUser!.uid
//        Firestore.firestore().collection("AllPost").addSnapshotListener { [unowned self] (snapshot, error) in
//            guard let snapshot = snapshot else {
//                print("Error fetching snapshot results: \(error!)")
//                return
//            }
//            _ = snapshot.documents.map { (document) in
//                let newPost = Post.transformPostPhoto(dict: document.data())
//                self.posts.append(newPost)
//                self.tableView.reloadData()
//            }
//            }
//        let userdb = Firestore.firestore().collection("Users")
//        let postdb = userdb.document().collection("Post")
//        postdb.getDocuments{ (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//            } else {
//                for document in querySnapshot!.documents {
//                    Api.Post.observePost(Uid: document.documentID){ (post) in
//                        self.posts.append(post)
//                        self.tableView.reloadData()
//                        print("POST\(post)")
//                    }
//                }
//            }
//
//        }
        userRef.getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    Api.Post.observePost(Uid: document.documentID, completion: { (post) in
                        Api.User.observeUserByUid(Uid: document.documentID, completion: { (user) in
                            post.username = user.firstname! + " " + user.lastname!
                            self.posts.append(post)
                            self.tableView.reloadData()
                        })
                    })
                    
                }
            }
        }
    }
    
}
// Use fake data to show that our post can be displayed correctly
extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! TimelineTableViewCell
        let post = posts[indexPath.row]
        cell.profileImageView.image = UIImage(named: "Head_Icon.png")
        cell.nameLabel.text = post.username
        cell.postImageView.image = UIImage(named: "photo2.jpeg")
        cell.captionLabel.text = post.discription
        if let urlString = post.URL {
            let url = URL(string: urlString)
            cell.postImageView.sd_setImage(with: url)
        }
//        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
