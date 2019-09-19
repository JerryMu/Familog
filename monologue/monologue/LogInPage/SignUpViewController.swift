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
        // Do any additional setup after loading the view.
    }
    
    
    // Make a standard format of password : "It must have at least one uppercase letter, one lowercase letter and one number, the length of the password should be greater than 8
    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])[A-Za-z0-9]{8,}")
        return passwordTest.evaluate(with: password)
    }
    
    // Validate all the field users fill, if there any error, return the error message, otherwise returns nil
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
        let error = validateFields()
        
        // Something wrong show error message!
        if error != nil {
            Alert.presentAlert(on: self, with: "Error!", message: error!)
        }
        else {
            // Create users
            let firstName = firstNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let lastName = lastNameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                
                if err != nil {
                    Alert.presentAlert(on: self, with: "Error!", message: "Creating user")
                }
                    // Upload user information to database
                else {
                    let db = Firestore.firestore()
                    db.collection("Users").addDocument(data: ["firstname":firstName, "lastname":lastName,"uid":result!.user.uid, "email": email]) { (error) in
                        if error != nil {
                            Alert.presentAlert(on: self, with: "Error!", message: "Saving user data")
                        }
                    }
                    self.moveToTimeLinePage()
                }
            }
        }
    }
    
    
    // Move to timeline page
    func moveToTimeLinePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        self.present(newViewController, animated: true, completion: nil)
    }
 }
