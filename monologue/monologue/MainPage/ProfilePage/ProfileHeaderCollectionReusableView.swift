//
//  ProfileHeaderCollectionReusableView.swift
//  Familog
//
//  Created by Pengyu Mu on 18/9/19.
//

import UIKit

class ProfileHeaderCollectionReusableView: UICollectionReusableView {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var artifactsNumberLabel: UILabel!
    
    //current user information
    var user: User? {
        didSet {
            updateView()
        }
    }
    
    func updateView(){
//        Api.User.REF_CURRENT_USER?.observeSingleEvent(of: .value, with: {
//            snapshot in
//            print(snapshot)
//        })
        nameLabel.text = "JerryMu"
        profileImage.image = UIImage(named : "Head_Icon.png")
        artifactsNumberLabel.text = "0"
    }
}
