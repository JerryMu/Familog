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
    
    var delegate: CommentTableViewCellDelegate?
    
   
    var comment: Comment? {
        didSet {
            updateView()
        }
    }
    
    var user: User? {
        didSet {
            print("Userer")
            setupUserInfo()
        }
    }

    func updateView() {
        commentLabel.text = comment?.commentText
       
    }
    
    func setupUserInfo() {
        nameLabel.text = user?.firstname
        if let photoUrlString = user?.profileImageUrl {
            let photoUrl = URL(string: photoUrlString)
            profileImageView.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "placeholderImg"))
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
