//
//  TimelineTableViewCell.swift
//  Familog
//
//  Created by Ziyuan on 18/09/19.
//

import UIKit

protocol TimelineTableViewCellDelegate {
    func goToCommentVC(postId: String)
    func goToProfileUserVC(userId: String)
}

class TimelineTableViewCell: UITableViewCell {


    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var likeImageView: UIImageView!
    @IBOutlet weak var shareImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    @IBOutlet weak var commentImageView: UIImageView!
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
        captionLabel.text = post?.caption
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.firstname
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Placeholder-image"))
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        captionLabel.text = ""
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.commentImageView_TouchUpInside))
        commentImageView.addGestureRecognizer(tapGesture)
        commentImageView.isUserInteractionEnabled = true
       
        
    }
    
    @objc func commentImageView_TouchUpInside() {
      print("commentImageView_TouchUpInside")
        
        if let id = post?.uid {
            delegate?.goToCommentVC(postId: id)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    

}

