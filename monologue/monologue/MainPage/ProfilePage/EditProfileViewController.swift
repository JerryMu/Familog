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
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    var delegate: EditProfileControllerDelegate?
    private var datePicker : UIDatePicker?

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        usernnameTextField.delegate = self
        dateOfBirth.delegate = self
        fetchCurrentUser()
        
        //Chose date for the user's date of birth
//
//            datePicker = UIDatePicker()
//            datePicker?.datePickerMode = .date
//            datePicker?.addTarget(self, action: #selector(EditProfileViewController.dateChanged(datePicker:)), for: valueChanged)
//
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.viewTapped(gestureRecongnizer:)))
//
//            view.addGestureRecognizer(tapGesture)
//
//            dateOfBirth.inputView = datePicker
//    }
//
//    @objc func viewTapped(gestureRecognizer: UITapGestureRecognizer){
//        view.endEditing(true)
//
//    }
//
//    @objc func dateChanged (datePicker: UIDatePicker){
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "mm/dd/yyyy"
//        dateOfBirth.text = dateFormatter.string(from: datePicker.date)
//        view.endEditing(true)
    }
    
    func fetchCurrentUser() {
//        Api.User.observeCurrentUser(){
//            user in
//            self.user = user
//        }
    }
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
//            ProgressHUD.show("Waiting...")
        if(usernnameTextField.text!.count > 0){
            Api.User.setCurrentUser(dictionary:["firstname" : usernnameTextField.text!])
        }
        if(dateOfBirth.text!.count > 0){
            Api.User.setCurrentUser(dictionary:["age" : dateOfBirth.text!])
        }
        if(bioTextView.text!.count > 0){
            Api.User.setCurrentUser(dictionary:["bio" : bioTextView.text!])
        }
    }
    @IBAction func changeProfileBtn_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
    }
    
}

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info:[ UIImagePickerController.InfoKey : Any] ){
            //editedImage
            if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as?
                UIImage{
                avatar.image = imageSelected
            }
            //originalImage
            if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as?
                UIImage{
                avatar.image = imageOriginal
            }
            //uploadToFirebase
            
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("Avatar").child(Api.User.currentUser)
            
            storageRef.putData((avatar.image?.pngData())!, metadata: nil){ (metadata, error) in
                if error != nil {
                    return
                }
                storageRef.downloadURL { (url, error) in
                    guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                    }
                    Api.User.setCurrentUser(dictionary:["profileImageUrl" : downloadURL.absoluteString])
                }
                
            }

            picker.dismiss(animated: true, completion: nil)
    }
}


extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
}
