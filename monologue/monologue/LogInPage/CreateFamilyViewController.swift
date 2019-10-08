//
//  FamilyViewController.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/6.
//

import UIKit

class CreateFamilyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var familyNameTextField: UITextField!
    
   
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet var preferIdTextField: UITextField!
    
    @IBAction func createTapped(_ sender: Any) {
        
        let familyName = familyNameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        
        if familyName == "" {
            Alert.presentAlert(on: self, with: "Error!", message: "You must fill family name")
            return
        }
        let preferId = randomString()
        
        let data = ["profileImageUrl": nil, "familyName": familyName, "uid":preferId, "introduce" : nil, "familyOwner":nil, "userNumber" : 1] as [String : Any?]
        
        let family = Api.Family.familyRef.document(preferId)
        family.setData(data as [String : Any], completion: {(error) in
            if error != nil {
                Alert.presentAlert(on: self, with: "Error!", message: "Saving user data")
            } else {
                Alert.presentAlert(on: self, with: "Success!", message: "Sign up Successfully!")
                self.moveToLogInPage()
            }
        })
    }
    
    func randomString() -> String {
        let length = 8
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let randomCharacters = (0..<length).map{_ in characters.randomElement()!}
        let randomString = String(randomCharacters)
        return randomString
    }
    
    func moveToLogInPage() {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Start", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "logInVC") as! LogInViewController
        self.present(newViewController, animated: true, completion: nil)
    }
}
