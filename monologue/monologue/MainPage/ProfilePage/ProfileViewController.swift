//
//  ProfileViewController.swift
//  Familog
//
//  Created by Pengyu Mu on 18/9/19.
//

import UIKit
//test only
import FirebaseAuth
//The main page of personal profile storyboard
class ProfileViewController: UIViewController {
    @IBOutlet weak var userAvatar: UIImageView!
    @IBOutlet weak var userBioLabel: UILabel!
    @IBOutlet weak var userDobLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var currentFamily: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    var user: User!
    var posts: [Post] = []
    let uid =  Auth.auth().currentUser!.uid
    let initImage =  "https://firebasestorage.googleapis.com/v0/b/monologue-10303.appspot.com/o/Avatar%2Fy8sEy6wi7VU2XzQ7IrwOyNpu4tD2?alt=media&token=04c3c554-eb96-4a49-b348-3f1404759acb"
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchPost()
        //fetchUser()
    }
    
////  Take out user information from the database
//    func fetchUser() {
//        Api.User.observeUserByUid(Uid: uid){ (user) in
//            self.user = user
//            self.navigationItem.title = user.firstname
//            self.updateView()
//        }
//    }
    
    func fetchPost() {
        Api.Post.observePostsByUser(userId: self.uid).getDocuments{ (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    Api.Post.observePost(uid: document.documentID, completion:  { (post) in
                        self.posts.append(post)
                        self.collectionView.reloadData()
                    })
                }
            }
        }
    }
}

// Show how many and what kinds of artificates user has uploaded and add them the cell
extension ProfileViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return posts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCollectionViewCell", for: indexPath) as! PhotoCollectionViewCell
        let post = posts[indexPath.row]
        cell.post = post
        return cell
    }
    

    func updateView(){
        userNameLabel.text = user?.firstname
        userBioLabel.text = user?.bio
        userDobLabel.text = user?.dob
        userAvatar.sd_setImage(with: URL(string: user?.profileImageUrl ?? initImage))
        Api.Post.observePostsNumberByUser(userId: user!.uid!){count in
            self.postLabel.text = "\(count)"
        }
    }
}
//set image distance and image size
extension ProfileViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 3 - 1, height: collectionView.frame.size.width / 3 - 1)
    }
}
