//
//  JoinFamilyViewController.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/6.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

class JoinFamilyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        print("CurrentUser:\(Api.User.currentUser)")

        // Do any additional setup after loading the view.
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var familyIdTextField: UITextField!
    
    
    @IBAction func joinTapped(_ sender: Any) {
        
        let familyId = familyIdTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        if familyId == "" {
            Alert.presentAlert(on: self, with: "Error", message: "Please enter family!")
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
                    Alert.presentAlert(on: self, with: "Error", message: "Can not find this family!")
                    return
                } else {
                    Api.User.REF_USERS.document(Api.User.currentUser!.uid).getDocument{(document, error) in
                        if let document = document, document.exists {
                            var familys = document.get("families") as! [String]
                            familys.append(familyId)
                            Api.User.REF_USERS.document(Api.User.currentUser!.uid).updateData(  ["familyId": familyId, "families": familys])
                                {err in
                                    if err != nil {
                                        Alert.presentAlert(on: self, with: "Error", message: "Can not join this family!")
                                    } else {
                                        Alert.presentAlert(on: self, with: "Success", message: "Join family successfully!")
                                        self.moveToTimeLinePage()
                                    }
                                }
                            } else {
                                Alert.presentAlert(on: self, with: "Error", message: "Can not get familys!")
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
