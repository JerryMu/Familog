//
//  SwitchFamilyTableViewCell.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/17.
//

import UIKit
protocol SwitchFamilyTableViewCellDelegate {
    func moveToTimeLinePage()
}
class SwitchFamilyTableViewCell: UITableViewCell {

    @IBOutlet weak var famliyButton: UIButton!
    var familyId = String()
    var switchFamliyVC : SwitchFamilyViewController?
    var delegate: SwitchFamilyTableViewCellDelegate?
    
    // Initialization code
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Configure the view for the selected state
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //click every joined family
    @IBAction func famliyTapped(_ sender: Any) {
        Api.User.setCurrentUser(dictionary: ["familyId" : familyId])
        delegate?.moveToTimeLinePage()
    }
}
