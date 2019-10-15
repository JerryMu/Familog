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
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    let datePicker = UIDatePicker()

    var delegate: EditProfileControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Edit Profile"
        nameTextField.delegate = self
//        dateOfBirth.delegate = self
        fetchCurrentUser()

        dateOfBirth.inputView = datePicker
        datePicker.datePickerMode = .date
//
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneAction))

        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        toolbar.setItems([flexSpace,doneButton], animated: true)
        
        dateOfBirth.inputAccessoryView = toolbar
        datePicker.addTarget(self, action: #selector(dateChannged), for: .valueChanged)
        
    }
    @objc func doneAction(){
        getDateFromPicker()
        view.endEditing(true)
    }
    
    @objc func dateChannged(){
        getDateFromPicker()
    }
    
    @objc func tapGestureDone(){
        view.endEditing(true)
    }
    func getDateFromPicker(){
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        dateOfBirth.text = formatter.string(from: datePicker.date)
        
    }
    @IBAction func logoutTapped(_ sender: Any) {
        do{
            // database signout
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        //go back to login
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "Authentication")
        //show the new page
        self.present(signInVC,animated: true , completion: nil)
    }
    
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
    func fetchCurrentUser() {
//        Api.User.observeCurrentUser(){
//            user in
//            self.user = user
//        }
    }
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
//            ProgressHUD.show("Waiting...")
        if(nameTextField.text!.count > 0){
            Api.User.setCurrentUser(dictionary:["firstname" : nameTextField.text!])
        }
        if(dateOfBirth.text!.count > 0){
            Api.User.setCurrentUser(dictionary:["dob" : dateOfBirth.text!])
        }
        if(bioTextView.text!.count > 0){
            Api.User.setCurrentUser(dictionary:["bio" : bioTextView.text!])
        }
        moveToProfilePage()
    }
    
    func moveToProfilePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        newViewController.selectedIndex = 2
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func changeProfileBtn_TouchUpInside(_ sender: Any) {
        let pickerController = UIImagePickerController()
        pickerController.allowsEditing = true
        pickerController.sourceType = .photoLibrary
        pickerController.delegate = self
        present(pickerController, animated: true, completion: nil)
        
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        let pickerController = UIImagePickerController()
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            pickerController.sourceType = .camera
            pickerController.delegate = self
            present(pickerController, animated: true, completion: nil)
        } else {
            Alert.presentAlert(on: self, with: "Error", message: "Can not use camera")
        }
        
       
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
            
            let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("Avatar").child(Api.User.currentUser!.uid)
            
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
