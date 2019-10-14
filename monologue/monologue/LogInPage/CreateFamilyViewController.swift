//
//  FamilyViewController.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/6.
//

import UIKit
import FirebaseFirestore
class CreateFamilyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        familyIdTextField.text! = randomString()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var familyNameTextField: UITextField!
    
    @IBOutlet weak var familyIdTextField: UITextField!
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createTapped(_ sender: Any) {
        
        let familyName = familyNameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        if familyName == "" {
            Alert.presentAlert(on: self, with: "Error!", message: "You must fill family name")
            return
        }
        
        let familyId = familyIdTextField.text!
        
        let data = ["profileImageUrl": "", "familyName": familyName, "uid":familyId, "introduce" : "", "familyOwner":"", "userNumber" : 1] as [String : Any?]
        
        // add channel to firebase
        let channel = Channel(name: familyName, id : familyId)
        Firestore.firestore().collection("channels").addDocument(data: channel.representation) { error in
            if let e = error {
                print("Error saving channel: \(e.localizedDescription)")
            }
        }
        
        let family = Api.Family.REF_FAMILY.document(familyId)
        family.setData(data as [String : Any], completion: {(error) in
            if error != nil {
                Alert.presentAlert(on: self, with: "Error", message: "Can not Creat this family!")
            } else {
                Api.User.REF_USERS.document(Api.User.currentUser).getDocument{(document, error) in
                if let document = document, document.exists {
                    
                    var familys = document.get("families") as! [String]
                    
                    familys.append(familyId)
                    
                    Api.User.REF_USERS.document(Api.User.currentUser).updateData(["familyId": familyId, "families": familys])
                    {
                        err in
                        if err != nil {
                            Alert.presentAlert(on: self, with: "Error", message: "Can not join this family!")
                        } else {
                            Alert.presentAlert(on: self, with: "Success", message: "Join family successfully!")
                            self.moveToTimeLinePage()
                        }
                    }
                } else {
                    Alert.presentAlert(on: self, with: "Error", message: "Can not get families!")
                    }
                }
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
    
    // Move to the timeline page
    func moveToTimeLinePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        self.present(newViewController, animated: true, completion: nil)
    }
}
