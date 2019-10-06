//
//  EditProfileViewController.swift
//  Familog
//
//  Created by Pengyu Mu on 12/9/19.
//
//for "editprofile" StoryBoard
//Developed Function:
//  1.Change profile Photo
//  2.Edit user Name

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseFirestore

protocol EditProfileControllerDelegate {
    func updateUserInfor()
}

class EditProfileViewController: UIViewController {
    
    // set profile photo function
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var usernnameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var bioTextField: UITextField!
    
    var delegate: EditProfileControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        usernnameTextField.delegate = self
        ageTextField.delegate = self
        bioTextField.delegate = self
        fetchCurrentUser()
    }
    
    func fetchCurrentUser() {
        Api.User.observeCurrentUser {  (user) in
            if(user.profileImageUrl != nil)
            {
                self.avatar.sd_setImage(with: user.profileImageUrl)
            }
        }
        
    }
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
//            ProgressHUD.show("Waiting...")
        if(usernnameTextField.text!.count > 4){
            Api.User.setCurrentUser(dictionary:["firstname" : usernnameTextField.text!])
            print(1)
        }
        if(ageTextField.text!.count < 3){
            Api.User.setCurrentUser(dictionary:["age" : ageTextField.text!])
            print(2)
        }
        if(bioTextField.text!.count < 50){
            Api.User.setCurrentUser(dictionary:["bio" : bioTextField.text!])
        }
        if(self.avatar.sd_imageURL != nil){
            Api.User.setCurrentUser(dictionary:["profileImageUrl" : self.avatar.sd_imageURL!])
        }
    }
    @IBAction func changeProfileBtn_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print("did Finish Picking Media")
        if let image = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            avatar.image = image
        }
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
}
