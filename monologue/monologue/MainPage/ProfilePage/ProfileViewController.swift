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
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var familyId: UILabel!
    
//    @IBOutlet weak var more: UIButton!
//    @IBOutlet weak var set: UIButton!
//    @IBOutlet weak var edit: UIButton!
    
    var editButtonCenter: CGPoint!
    var setButtonCenter: CGPoint!
    var user: User!
    var posts: [Post] = []
    var uid =  Auth.auth().currentUser!.uid
    let initImage =  "https://firebasestorage.googleapis.com/v0/b/monologue-10303.appspot.com/o/Avatar%2Fy8sEy6wi7VU2XzQ7IrwOyNpu4tD2?alt=media&token=04c3c554-eb96-4a49-b348-3f1404759acb"
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        fetchPost()
        fetchUser()
        
//        editButtonCenter = edit.center
//        setButtonCenter = set.center
//
//        set.center = more.center
//        edit.center = edit.center
    }
    
    // Animation for the left Button
//
//    @IBAction func moreClicked(_ sender: UIButton) {
//        if more.currentImage = "moreOff" {
//            UIView.animate(withDuration: 0.4, animations: {
//                // Make button visiable
//
//                self.edit.alpha = 1
//                self.set.alpha = 1
//
//                // Animation happens
//                self.edit.center = self.editButtonCenter
//                self.set.center = self.setButtonCenter
//            })
//            // expand button
//        } else {
//            // collapse button
//            UIView.animate(withDuration: 0.4, animations: {
//                // Make button invisiable
//
//                self.edit.alpha = 0
//                self.set.alpha = 0
//
//                // Animation happens
//
//                self.set.center = self.more.center
//                self.edit.center = self.edit.center
//            })
//        }
    
//    func toggledButton(button: sender, onImage: "more", offImage: "moreoff")
//    }
//
//    @IBAction func setClicked(_ sender: UIButton) {
//    }
//
//    @IBAction func editClicked(_ sender: UIButton) {
//    }
    
//    func toggledButton(button: UIButton, onImage: UIImage, offImage: UIImage){
//        if button.currentImage == offImage {
//            button.setImage(onImage, for: .normal)
//        } else {
//            button.setImage(offImage, for: .normal)
//
//        }
//    }
    
    func fetchUser(){
        Api.User.observeCurrentUser(){
            user in
            self.user = user
            if(self.user != nil){
                self.updateInfo()
            }
        }
    }

    func updateInfo(){
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            userAvatar.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Head_Icon"))
        }
        userBioLabel.text = user.bio
        userDobLabel.text = user.dob
        userNameLabel.text = user.firstname! + " " + user.lastname!
        postLabel.text = "\(user.postNumber)"
        familyId.text = user.familyId
    }
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
