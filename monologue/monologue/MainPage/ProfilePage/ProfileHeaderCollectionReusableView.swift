//
//  ProfileHeaderCollectionReusableView.swift
//  Familog
//
//  Created by Pengyu Mu on 18/9/19.
//
//For personal profile page header
import UIKit
import FirebaseAuth
class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var artifactsNumberLabel: UILabel!
    
    let uid =  Auth.auth().currentUser!.uid
    //current user information
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    //get current users' information
    func updateView(){
        Api.User.observeUserByUid(Uid : uid)
        nameLabel.text = "user.username"
        profileImage.image = UIImage(named : "Head_Icon.png")
        artifactsNumberLabel.text = "0"
    }
}
