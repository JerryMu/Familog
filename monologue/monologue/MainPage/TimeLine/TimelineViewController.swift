//
//  TimelineViewController.swift
//  Familog
//
//  Created by Ziyuan on 18/09/19.
//
//  This file works primarily for the Timeline page, which defines how we use the table cell to display our post.
import UIKit
import FirebaseAuth
import FirebaseDatabase
class TimelineViewController: UIViewController {

//  Each of our tablecells is dynamic.
//  It can determine the width of each cell based on the length of the text uploaded by the user.
    @IBOutlet weak var tableView: UITableView!
    var posts = [Post]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.estimatedRowHeight = 521
        tableView.dataSource = self
        tableView.delegate = self
        loadPosts()
    }
    
    func loadPosts() {
        Database.database().reference().child("posts").observe(.childAdded) { (snapshot: DataSnapshot) in
            print(Thread.isMainThread)
            if let dict = snapshot.value as? [String: Any] {
                let newPost = Post.transformPostPhoto(dict: dict)
                self.posts.append(newPost)
                self.tableView.reloadData()

            }
        }
    }
    
}
// Use fake data to show that our post can be displayed correctly
extension TimelineViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! TimelineTableViewCell
        cell.profileImageView.image = UIImage(named: "Head_Icon.png")
        cell.nameLabel.text = "Leo Xiao"
        cell.postImageView.image = UIImage(named: "photo2.jpeg")
        cell.captionLabel.text = "TesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTestTesstTestTestTestTestTestTestTestTestTestTestTestTestTestTest"
//        cell.textLabel?.text = posts[indexPath.row].caption
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

