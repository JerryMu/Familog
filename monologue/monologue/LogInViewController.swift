//
//  LogInViewController.swift
//  monologue
//
//  Created by 袁翥 on 2019/8/18.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
 /*       if Auth.auth().currentUser != nil{
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {(Timer) in
                self.performSegue(withIdentifier: "sin", sender: nil)
            })
            
        }*/
        // Do any additional setup after loading the view.
    }
    
    func setUpElements() {
        errorLabel.alpha = 0
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
//    func showErrorMessage(_ message:String) {
//        errorLabel.alpha = 1
//        errorLabel.text = message
//    }
//
//    func validateFields() -> String? {
//        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
//            return "Please fill the email"
//        }
//        if passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
//            return "Please fill the password"
//        }
//        return nil
//    }
    
    @IBAction func logInTapped(_ sender: Any) {
//        // Validate
//        let errMessage = validateFields()
//        if errMessage != nil {
//            self.showErrorMessage(errMessage!)
//        }
        
        let email = emailTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)

        // Sign in
        Auth.auth().signIn(withEmail: email, password: password) {(result, error) in
            if error != nil {
                self.errorLabel.text = error!.localizedDescription
                self.errorLabel.alpha = 1
            }
            else {
                self.moveToWelcomePage()
            }
        }
    }
    
    func moveToWelcomePage() {
        let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.welcomeViewController) as? WelcomeViewController
        view.window?.rootViewController = welcomeViewController
        view.window?.makeKeyAndVisible()
    }
}
