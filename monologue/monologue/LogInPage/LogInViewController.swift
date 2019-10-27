//
//  LogInViewController.swift
//  monologue
//
//  Created by 袁翥 on 2019/8/18.
//

import UIKit
import FirebaseAuth
import ProgressHUD
//import FirebaseFirestore

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func dismissPopup(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func logInTapped(_ sender: Any) {
        ProgressHUD.show("Waiting...", interaction: false)
        let email = emailTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Validate first, if success then sign in and move to the timeline page        
        Auth.auth().signIn(withEmail: email, password: password) {(result, error) in
            if error != nil {
                ProgressHUD.showError(error!.localizedDescription)
            } else {
                Api.User.REF_USERS.whereField("email", isEqualTo: email).getDocuments() { (querySnapshot, err) in
                        if let err = err {
                            print("Error getting documents: \(err)")
                        } else {
                            for document in querySnapshot!.documents {
                                let familyId : String = document.get("familyId") as! String
                                if familyId == "" {
                                    self.moveToFamilyPage()
                                } else {
                                    self.moveToTimeLinePage()
                                }
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
    
    // Move to family page
    func moveToFamilyPage() {
        let storyBoard = UIStoryboard(name: "Family", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "familyVC")
        self.present(newViewController, animated: true, completion: nil)
    }
}
