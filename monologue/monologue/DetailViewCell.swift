//
//  DetailViewCell.swift
//  Familog
//
//  Created by Pengyu Mu on 22/10/19.
//
// show the detail of every post, include view big image function

import Foundation
import UIKit
import Vision
import Lightbox

protocol DetailTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
    func moveToProfilePage()
    func presentImage(imageViewController : LightboxController)
}

class DetailViewCell:UITableViewCell{

    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var timelineVC : TimelineViewController?
    var delegate: DetailTableViewCellDelegate?
    
    var post: Post? {
         didSet {
             updateView()
         }
     }
     
     var user: User? {
         didSet {
             setupUserInfo()
         }
     }
    
    //update information for every post
    func updateView() {
        captionLabel.text = post?.discription
        
        //get image url
        if let photoUrlString = post?.url {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        
        //add temp stamp for every post
        if let timestamp = post?.timestamp {
            print(timestamp)
            let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
            let now = Date()
            let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
            let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
            
            var timeText = ""
            if diff.second! <= 0 {
                timeText = "Now"
            }
            if diff.second! > 0 && diff.minute! == 0 {
                timeText = (diff.second == 1) ? "\(diff.second!) second ago" : "\(diff.second!) seconds ago"
            }
            if diff.minute! > 0 && diff.hour! == 0 {
                timeText = (diff.minute == 1) ? "\(diff.minute!) minute ago" : "\(diff.minute!) minutes ago"
            }
            if diff.hour! > 0 && diff.day! == 0 {
                timeText = (diff.hour == 1) ? "\(diff.hour!) hour ago" : "\(diff.hour!) hours ago"
            }
            if diff.day! > 0 && diff.weekOfMonth! == 0 {
                timeText = (diff.day == 1) ? "\(diff.day!) day ago" : "\(diff.day!) days ago"
            }
            if diff.weekOfMonth! > 0 {
                timeText = (diff.weekOfMonth == 1) ? "\(diff.weekOfMonth!) week ago" : "\(diff.weekOfMonth!) weeks ago"
            }
            
            timeLabel.text = timeText
        }
    }
    
    //delete current post
    @IBAction func deletePostButtonTapped(_ sender : Any) {
        Api.Post.deletePost(PostId: post!.uid!)
        delegate?.moveToProfilePage()
    }
    
    // update users' information
    func setupUserInfo() {
        nameLabel.text = user?.firstname
        
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Head_Icon"))
        }
        //only if the post is current user's post show delete button
        if(user?.uid != Api.User.currentUser?.uid){
            deleteButton.isHidden = true
        }else{
            deleteButton.isHidden = false
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        //touch name label will go to user's profile page
        captionLabel.text = ""
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
        
        // tap user image will also go to profile page
        let tapGestureForUserImageLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        profileImageView.addGestureRecognizer(tapGestureForUserImageLabel)
        profileImageView.isUserInteractionEnabled = true
        
        // tap post image will show detail image
        let tapGestureForPostImageLabel = UITapGestureRecognizer(target: self, action: #selector(self.showLightbox))
        postImageView.addGestureRecognizer(tapGestureForPostImageLabel)
        postImageView.isUserInteractionEnabled = true
       
        
    }
    
    
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.uid {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    
    // tap comment button to
    @IBAction func commentButton(_ sender: Any) {
          if let id = post?.uid {
              delegate?.goToCommentVC(postId: id)
          }
    }
    
    // Configure the view for the selected state
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    // show detailed image with image recognition result
    @objc func showLightbox() {
        if let photoUrlString = post?.url {
            let photoUrl = URL(string: photoUrlString)
        
            let images = [
                LightboxImage(
                    imageURL: photoUrl!,
                    //include the image recognition result
                    text: self.post!.predictItem! + "\n" + self.post!.predictAcc!
                )
            ]
          
            let controller = LightboxController(images: images)
            controller.dynamicBackground = true
            controller.modalPresentationStyle = .currentContext
            delegate?.presentImage(imageViewController: controller)
        }
    }
}
