 //
//  SignUpViewController.swift
//  monologue
//
//  Created by 袁翥 on 2019/8/18.
//
// The entire file is working for the authentication function

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
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion:nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    func isPasswordValid(_ password : String) -> Bool{
        let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])[A-Za-z0-9]{8,}")
        return passwordTest.evaluate(with: password)
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
    
// Check the input information and the database to match, if the account password is correct, you can enter
// If the account password is wrong, an error message will be displayed.

    @IBAction func signUpTapped(_ sender: Any) {
        // Validate
        let error = validateFields()
        
        if error != nil {
            // something wrong show error message!
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
                    Alert.presentAlert(on: self, with:"Error!", message: "Creating user fail, please check all field you has filled")
                }
                else {
                    let db = Firestore.firestore()
                    let currentUser = Auth.auth().currentUser!.uid
                                        
                    let user = ["email": email, "profileImageUrl": "", "firstname": firstName, "lastname": lastName, "uid": currentUser, "dob": "Unknow", "bio" : "Write first bio", "postNumber" : 0, "familyId": ""] as [String : Any?]
                    
                    db.collection("Users").document(currentUser).setData(user as [String : Any], completion: {(error) in
                        if error != nil {
                            Alert.presentAlert(on: self, with: "Error!", message: "Saving user data")
                        }
                    })
                    Alert.presentAlert(on: self, with: "Success!", message: "Sign up Successfully!")
                    self.moveToFamilyPage()
                }
            }
        }
    }
    
    func moveToFamilyPage() {
        let storyBoard = UIStoryboard(name: "Family", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "familyVC")
        self.present(newViewController, animated: true, completion: nil)
    }
 }
