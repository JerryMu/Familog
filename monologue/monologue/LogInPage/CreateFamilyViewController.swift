//
//  FamilyViewController.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/6.
//

import UIKit
import FirebaseFirestore
import ProgressHUD
class CreateFamilyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        familyIdTextField.text! = randomString()
        // Do any additional setup after loading the view.
    }
    
    @IBOutlet weak var familyNameTextField: UITextField!
    
    @IBOutlet weak var creatFamilyButton: DesignableButton!
    @IBOutlet weak var familyIdTextField: UITextField!
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func createTapped(_ sender: Any) {
        ProgressHUD.show("Waiting...", interaction: false)
        creatFamilyButton.isEnabled = false
        let familyName = familyNameTextField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
        if familyName == "" {
            ProgressHUD.showError("You must fill family name")
            return
        }
        
        let familyId = familyIdTextField.text!
        
        let data = ["profileImageUrl": "", "familyName": familyName, "uid":familyId, "introduce" : "", "userNumber" : 1] as [String : Any?]
    
        
        let family = Api.Family.REF_FAMILY.document(familyId)
        family.setData(data as [String : Any], completion: {(error) in
            if error != nil {
                ProgressHUD.showError("Can not Creat this family!")
            } else {
                // add channel to firebase
                let channel = Channel(name: familyName, id : familyId)
                Firestore.firestore().collection("channels").addDocument(data: channel.representation) { error in
                    if let e = error {
                        print("Error saving channel: \(e.localizedDescription)")
                    }
                }
                
                Api.User.REF_USERS.document(Api.User.currentUser!.uid).getDocument{(document, error) in
                if let document = document, document.exists {
                    
                    var families = document.get("families") as! [String]
                    
                    families.append(familyId)
                    
                    Api.User.REF_USERS.document(Api.User.currentUser!.uid).updateData(["familyId": familyId, "families": families])
                    {
                        err in
                        if err != nil {
                            ProgressHUD.showError("Can not create this family!")
                        } else {
                            ProgressHUD.showSuccess("Create family successfully!", interaction: false)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                self.moveToTimeLinePage()
                            }
                        }
                    }
                } else {
                    ProgressHUD.showError("Can not get families!")
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
