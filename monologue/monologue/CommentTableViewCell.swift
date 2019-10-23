//
//  CommentTableViewCell.swift
//  Familog
//
//  Created by shisheng liu on 2019/10/5.
//

import UIKit
protocol CommentTableViewCellDelegate {
    func goToProfileUserVC(userId: String)
}

class CommentTableViewCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var timeLabel: UILabel!
    var delegate: CommentTableViewCellDelegate?
    
   
    var comment: Comment? {
        didSet {
            // update the content of comment  and its date
            updateView()
        }
    }
    
    var user: User? {
        didSet {
           // update the content of user
            setupUserInfo()
        }
    }
    func updateView() {
           commentLabel.text = comment?.commentText
        if let timestamp = comment?.timestamp {
               let timestampDate = Date(timeIntervalSince1970: Double(timestamp))
               let now = Date()
               let components = Set<Calendar.Component>([.second, .minute, .hour, .day, .weekOfMonth])
               let diff = Calendar.current.dateComponents(components, from: timestampDate, to: now)
               // show different  unit of times accordingly
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
 
    
    func setupUserInfo() {
        nameLabel.text = user?.firstname
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Head_Icon"))
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        commentLabel.text = ""
        //  nameLabel can be tapped
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
        //  profileImageView can be tapped
        let tapGestureForUserImageLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        profileImageView.addGestureRecognizer(tapGestureForUserImageLabel)
        profileImageView.isUserInteractionEnabled = true
    }
    
    //for jump to view other users profile page
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.uid {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    //initialise it
    override func prepareForReuse() {
        super.prepareForReuse()
     //initialise its profileImage
        profileImageView.image = UIImage(named: "placeholderImg")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
