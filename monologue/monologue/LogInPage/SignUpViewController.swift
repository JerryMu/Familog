 //
//  SignUpViewController.swift
//  monologue
//
//  Created by 袁翥 on 2019/8/18.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
 
class SignUpViewController: UIViewController {
    
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmedPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpElements()
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
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])[A-Za-z0-9]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    
    func showErrorMessage(_ message:String) {
        errorLabel.alpha = 1
        errorLabel.text = message
    }
    

    func validateFields() -> String? {
        
        if firstNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastNameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmedPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
            
            return "Please fill all the fields!"
        }
        
        let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        let confirmedPassword = confirmedPasswordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if isPasswordValid(password) == false {
            return "Please make sure your password at least 8 characters, contains at least one upcase letter and number!"
        }
        
        if password != confirmedPassword {
            return " Please make sure that your passwords are same"
        }
        return nil
    }
    
    
    @IBAction func signUpTapped(_ sender: Any) {
        // Validate
        let error = validateFields()
        
        if error != nil {
            // something wrong show error message!
            showErrorMessage(error!)
        }
        else {
            // Create users
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    self.showErrorMessage("Error: Creating user")
                }
                else {
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: ["firstname":firstName, "lastname":lastName,"uid":result!.user.uid]) { (error) in
                        if error != nil {
                            self.showErrorMessage("Error: Saving user data")
                        }
                    }
                    self.moveToWelcomePage()
                }
            }
        }
    }
    
    
    func moveToWelcomePage() {
        let welcomeViewController = storyboard?.instantiateViewController(withIdentifier: Constants.Storyboard.welcomeViewController) as? WelcomeViewController
        view.window?.rootViewController = welcomeViewController
        view.window?.makeKeyAndVisible()
    }
 }
