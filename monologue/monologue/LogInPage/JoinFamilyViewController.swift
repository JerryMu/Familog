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

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var preferIdTextField: UITextField!
    
    func joinTapped(){
        let preferId = preferIdTextField.text!
        let userRef = Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid)
        userRef.updateData([
            "familyId": preferId
        ]) {err in
            if err == nil {
                Alert.presentAlert(on: self, with: "Error", message: "Can not join this family!")
            } else {
                Alert.presentAlert(on: self, with: "Success", message: "Join family successfully!")
            }
        }
        
    }
    
    
    

    

}
