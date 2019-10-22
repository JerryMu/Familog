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
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    var posts = [Post]()
    var users = [User]()
    static var familyId: String = ""
    let currentUser = Auth.auth().currentUser!.uid
    let userRef = Firestore.firestore().collection("User")
    let refreshControl = UIRefreshControl()

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
        loading.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.refresh()
        
    }
    
    func setCustomebBackImage(){
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    @objc func refresh() {
        posts.removeAll()
        users.removeAll()
        load()
        refreshControl.endRefreshing()
    }
    
    func getFamilyId() {
        Api.User.REF_USERS.document(Api.User.currentUser!.uid).getDocument{(document, error) in
                if let document = document, document.exists {
                    TimelineViewController.self.familyId = document.get("familyId") as! String
                    if TimelineViewController.self.familyId == "" {
                        self.moveToFamilyPage()
                    }
                }
        }
    }
    
    func load(){
        Api.User.observeCurrentUser(){ currentUser in
            self.loadPosts(fid : currentUser.familyId!)
        }
        
    }
    
    
    func loadPosts(fid : String) {
        Api.Post.observePostsByFamily(familyId: fid).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let post = Post.transformPostPhoto(dict: document.data())
                    guard let postUid = post.userId else {
                        return
                    }
                    self.fetchUser(uid: postUid, completed: {
                        self.posts.append(post)
                        self.loading.stopAnimating()
                        self.tableView.reloadData()
                    })
                    
                }
            }
        }
    }
    
    func fetchUser(uid: String, completed:  @escaping () -> Void ) {
        Api.User.observeUser(withId: uid, completion: {
            user in
            self.users.append(user)
            completed()
        })
    }
     
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "CommentSegue" {
            let commentVC = segue.destination as! CommentViewController
            let postId = sender  as! String
            commentVC.postId = postId
        }
        
        if segue.identifier == "Home_ProfileSegue" {
            let profileVC = segue.destination as! OthersProfileViewController
            let userId = sender  as! String
            profileVC.uid = userId
        }
        
        if segue.identifier == "Home_DetailSegue" {
            let detailVC = segue.destination as! DetailViewController
            let postId = sender  as! String
            detailVC.postId = postId
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
        if(posts.count > indexPath.row && users.count > indexPath.row){
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
    func goToDeatilVC(postId: String){
        performSegue(withIdentifier: "Home_DetailSegue", sender: postId)
    }
}

