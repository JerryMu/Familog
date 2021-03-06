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
 import ProgressHUD
   
 class SignUpViewController: UIViewController {
     
     
     @IBOutlet weak var nameTextField: UITextField!
     @IBOutlet weak var emailTextField: UITextField!
     @IBOutlet weak var passwordTextField: UITextField!
     @IBOutlet weak var confirmedPasswordTextField: UITextField!
     @IBOutlet weak var signUpButton: UIButton!
     
     @IBAction func dismissPopup(_ sender: UIButton) {
         dismiss(animated: true, completion:nil)
     }
    
    
     override func viewDidLoad() {
         super.viewDidLoad()
     }
     
     // check the password format, it must have one uppercase, one lowercase letter and one number.
     func isPasswordValid(_ password : String) -> Bool{
         let passwordTest = NSPredicate(format: "SELF MATCHES %@", "^(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z])[A-Za-z0-9]{8,}")
         return passwordTest.evaluate(with: password)
     }
     
     // validate all text fields need to be filled
     func validateFields() -> String? {
         
         if  nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
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
             return " Please make sure that your passwords are same!"
         }
          
         return nil
     }
     
     // Check the input information and the database to match, if the account password is correct, you can enter
     // If the account password is wrong, an error message will be displayed.
     @IBAction func signUpTapped(_ sender: Any) {
         ProgressHUD.show("Waiting...", interaction: false)
         // Validate
         let error = validateFields()
         
         if error != nil {
             // something wrong show error message!
             ProgressHUD.showError(error!)
         }
         else {
             // Create users
             let firstName = nameTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             let email = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             let password = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
             
             
             Auth.auth().createUser(withEmail: email, password: password) { (result, err) in
                 
                 if err != nil {
                     ProgressHUD.showError("Creating user fail, Please try using a different email account")
                 }
                 else {
                     let db = Firestore.firestore()
                     let currentUser = Api.User.currentUser
                                         
                    let user = ["email": email, "profileImageUrl": "gs://monologue-10303.appspot.com/DefulatData/Head_Icon.png", "firstname": firstName, "uid": currentUser!.uid, "dob": "Unknow", "bio" : "Write you first personalized signature", "postNumber" : 0, "familyId":"", "families": []] as [String : Any?]
                     
                    db.collection("Users").document(currentUser!.uid).setData(user as [String : Any], completion: {(error) in
                         if error != nil {
                             ProgressHUD.showError("Saving user data")
                         }
                        ProgressHUD.showSuccess("Sign Up Successfully", interaction: false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.moveToLogInPage()
                        }
                     })
                 }
             }
         }
     }
     
     // move to family page
     func moveToFamilyPage() {
         let storyBoard = UIStoryboard(name: "Family", bundle: nil)
         let newViewController = storyBoard.instantiateViewController(withIdentifier: "familyVC")
         self.present(newViewController, animated: true, completion: nil)
     }
     // Move to log in page
     func moveToLogInPage() {
         let storyboard = UIStoryboard(name: "Start", bundle: nil)
         let logInViewController = storyboard.instantiateViewController(withIdentifier: "logInVC") as! LogInViewController
         self.present(logInViewController, animated: true, completion: nil)
     }
     
  }
