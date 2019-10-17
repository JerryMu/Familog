//
//  CommentTableViewCell.swift
//  Familog
//
//  Created by 刘仕晟 on 2019/10/5.
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
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            setupUserInfo()
        }
    }
    func updateView() {
           commentLabel.text = comment?.commentText
      
           if let timestamp = comment?.timestamp {
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
        let tapGestureForNameLabel = UITapGestureRecognizer(target: self, action: #selector(self.nameLabel_TouchUpInside))
        nameLabel.addGestureRecognizer(tapGestureForNameLabel)
        nameLabel.isUserInteractionEnabled = true
    }
    
    //for jump to view other users profile page
    @objc func nameLabel_TouchUpInside() {
        if let id = user?.uid {
            delegate?.goToProfileUserVC(userId: id)
        }
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        profileImageView.image = UIImage(named: "placeholderImg")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
