//
//  File Name : TimelineTableViewCell.swift
//  Project Name : Familog
//
//  Created by Ziyuan on 18/09/19.
//
//

import UIKit
import Vision

protocol TimelineTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
    func goToDeatilVC(postId: String)
}

class TimelineTableViewCell: UITableViewCell {
  
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var timelineVC : TimelineViewController?
    var delegate: TimelineTableViewCellDelegate?
    
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
    
    func updateView() {
        captionLabel.text = post?.discription
        if let photoUrlString = post?.url {
            let photoUrl = URL(string: photoUrlString)
            postImageView.sd_setImage(with: photoUrl)
        }
        if let timestamp = post?.timestamp {
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
             
            self.timeLabel.text = timeText
         
        }
    }
 
    
    func setupUserInfo() {
        nameLabel.text = user?.firstname
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Head_Icon"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        captionLabel.text = ""
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
        
        let tapGestureForUserImageLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        profileImageView.addGestureRecognizer(tapGestureForUserImageLabel)
        profileImageView.isUserInteractionEnabled = true
        
        let tapGestureForImageLabel = UITapGestureRecognizer(target: self, action: #selector(self.postImageView_TouchUpInside))
        postImageView.addGestureRecognizer(tapGestureForImageLabel)
        postImageView.isUserInteractionEnabled = true
       
        
    }
    
    
    @objc func nameLabel_TouchUpInside() {
        print("nameLabel_TouchUpInside")
        if let id = user?.uid {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    
    @IBAction func commentButton(_ sender: Any) {
        print("commentImageView_TouchUpInside")
          
          if let id = post?.uid {
              delegate?.goToCommentVC(postId: id)
          }
    }
    
    @objc func postImageView_TouchUpInside() {
        print("postImageView_TouchUpInside")
        if let id = post?.uid {
            delegate?.goToDeatilVC(postId: id)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}

