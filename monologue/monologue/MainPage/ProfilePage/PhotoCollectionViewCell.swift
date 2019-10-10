//
//  PhotoCollectionViewCell.swift
//  Familog
//
//  Created by Pengyu Mu on 19/9/19.
//
//  Collection View Controller for display all user artifacts
//  The entire file is for the work of displaying artificats on the profile.

import UIKit

protocol PhotoCollectionViewCellDelegate {
    func goToDetailVC(postId: String)
}

// The cell take charge of displaying artificates
class PhotoCollectionViewCell : UICollectionViewCell {
    
    @IBOutlet weak var photo: UIImageView!
    var delegate: PhotoCollectionViewCellDelegate?
    
    var post: Post? {
        didSet {
            updateView()
        }
    }
    //update profile photo
    func updateView() {
        if let photoUrlString = post?.url {
            let photoUrl = URL(string: photoUrlString)
            photo.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Head_Icon"))
            
        }
        
//        let tapGestureForPhoto = UITapGestureRecognizer(target: self, action: #selector(self.photo_TouchUpInside))
//        photo.addGestureRecognizer(tapGestureForPhoto)
//        photo.isUserInteractionEnabled = true
        
    }
    
//    @objc func photo_TouchUpInside() {
//        if let id = post?.uid {
//            delegate?.goToDetailVC(postId: id)
//        }
//    }
}

