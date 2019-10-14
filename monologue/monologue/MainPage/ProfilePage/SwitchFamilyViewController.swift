//
//  SwitchFamilyViewController.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/13.
//

import UIKit

class SwitchFamilyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    var familys : [String: String] = [:]
    
    func switchFamily() {
        Api.User.REF_USERS.document(Api.User.currentUser).getDocument{(document, error) in
            if let document = document, document.exists {
                let familys = document.get("families") as! [String]
                for familyId in familys {
                    Api.Family.REF_FAMILY.document(familyId).getDocument{(document, error) in
                        if let document = document, document.exists {
                            let familyName = document.get("familyName") as! String
                            self.familys[familyName] = familyId
                        } else {
                            Alert.presentAlert(on: self, with: "Error", message: "Can not get families!")
                        }
                    }
                }
            } else {
                Alert.presentAlert(on: self, with: "Error", message: "Can not get families!")
            }
        }
    }
    
    //TimelineViewController.familyId
    
    func moveToFamilyPage() {
        let storyBoard = UIStoryboard(name: "Family", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "familyVC")
        self.present(newViewController, animated: true, completion: nil)
    }

    

}
