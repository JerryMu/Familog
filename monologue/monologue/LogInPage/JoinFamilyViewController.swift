//
//  JoinFamilyViewController.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/6.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth
import ProgressHUD

class JoinFamilyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var familyIdTextField: UITextField!
    @IBOutlet weak var joinButton: DesignableButton!
    
    
    @IBAction func joinTapped(_ sender: Any) {
        
        ProgressHUD.show("Waiting...", interaction: false)
        let familyId = familyIdTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        // Must fill family ID
        if familyId == "" {
            ProgressHUD.showError("Please enter family!")
            return
        }
        
        var familys = [String]()
        Api.Family.REF_FAMILY.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    familys.append(document.documentID)
                }
                if !familys.contains(familyId) {
                    ProgressHUD.showError("Can not find this family!")
                    return
                } else {
                    Api.User.REF_USERS.document(Api.User.currentUser!.uid).getDocument{(document, error) in
                        if let document = document, document.exists {
                            var familys = document.get("families") as! [String]
                            familys.append(familyId)
                            let newFamilys = Array(Set(familys))
                            Api.User.REF_USERS.document(Api.User.currentUser!.uid).updateData(  ["familyId": familyId, "families": newFamilys])
                                {err in
                                    if err != nil {
                                        ProgressHUD.showError("Can not join this family!")
                                    } else {
                                        ProgressHUD.showSuccess("Join family successfully!", interaction: false)
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            self.moveToTimeLinePage()
                                        }
                                    }
                                }
                            } else {
                               ProgressHUD.showError("Can not get familys!")
                            }
                    }
                }
            }
        }
    }
    
    // Move to the timeline page
       func moveToTimeLinePage() {
           let storyBoard = UIStoryboard(name: "Main", bundle: nil)
           let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
           self.present(newViewController, animated: true, completion: nil)
       }
    
    
    

    

}
