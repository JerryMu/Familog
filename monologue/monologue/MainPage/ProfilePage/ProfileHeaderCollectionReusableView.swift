//
//  ProfileHeaderCollectionReusableView.swift
//  Familog
//
//  Created by Pengyu Mu on 18/9/19.
//
//  For personal profile page header

import UIKit
import FirebaseAuth
class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var artifactsNumberLabel: UILabel!
    
    let initImage = URL(string : "https://firebasestorage.googleapis.com/v0/b/monologue-10303.appspot.com/o/images%2FHead_Icon.png?alt=media&token=abd7d70b-ac25-43d1-9289-a811e2e0e7bc")
    //current user information
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    //get current user's information
    func updateView(){
        nameLabel.text = user?.firstname
        profileImage.sd_setImage(with: user?.profileImageUrl ?? initImage!)
        
        
        Api.Post.observePostsNumberByUser(userId: user!.uid!){count in
            self.artifactsNumberLabel.text = "\(count)"
        }
    }
}
