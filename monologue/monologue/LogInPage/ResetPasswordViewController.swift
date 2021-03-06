//
//  ResetPasswordViewController.swift
//  monologue
//
//  Created by 袁翥 on 2019/8/27.
//

import UIKit
import FirebaseAuth
import ProgressHUD

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // The function of reset password
    @IBAction func resetPasswordTapped(_ sender: Any) {
        // Validate the email address, if it is nil, shows error message
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            ProgressHUD.showError("Please fill your email address")
        }
            
        // If the email address is not nil, send the reset password email to it
        else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error != nil {
                     ProgressHUD.showError(error!.localizedDescription)
                }
                
            }
            self.moveToLogInPage()
            
        }
    }
    
    // Move to log in page
    func moveToLogInPage() {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let logInViewController = storyboard.instantiateViewController(withIdentifier: "logInVC") as! LogInViewController
        self.present(logInViewController, animated: true, completion: nil)
    }

}
