//
//  ResetPasswordViewController.swift
//  monologue
//
//  Created by 袁翥 on 2019/8/27.
//

import UIKit
import FirebaseAuth

class ResetPasswordViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()

        // Do any additional setup after loading the view.
    }
    func setUpElements() {
        errorLabel.alpha = 0
    }
    func showErrorMessage(_ message:String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func moveToLogInPage() {
        let logInViewController = storyboard?.instantiateViewController(withIdentifier: "logInVC") as? LogInViewController
        view.window?.rootViewController = logInViewController
        view.window?.makeKeyAndVisible()
    }
    
    @IBAction func resetPasswordTapped(_ sender: Any) {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            self.showErrorMessage("Please fill your email address")
        }
        else {
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error != nil {
                    self.showErrorMessage(error!.localizedDescription)
                }
            
            }
            self.moveToLogInPage()
        
        }
    }
}
