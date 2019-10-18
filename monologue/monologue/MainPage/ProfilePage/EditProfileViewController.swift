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
import Photos
import YPImagePicker
import ProgressHUD

protocol EditProfileControllerDelegate {
    func updateUserInfor()
}

class EditProfileViewController: UIViewController {
    
    // set profile photo function
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var dateOfBirth: UITextField!
    @IBOutlet weak var bioTextView: UITextView!
    
    var selectImage : UIImage?
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
        Api.User.observeCurrentUser(){
            user in
            if let photoUrlString = user.profileImageUrl {
                let photoUrl = URL(string: photoUrlString)
                self.avatar.sd_setImage(with: photoUrl, placeholderImage: UIImage(named: "Head_Icon"))
            }
        }
    }
    @IBAction func saveBtn_TouchUpInside(_ sender: Any) {
        ProgressHUD.show("Waiting...")
        if(nameTextField.text!.count > 0){
            Api.User.setCurrentUser(dictionary:["firstname" : nameTextField.text!])
        }
        if(dateOfBirth.text!.count > 0){
            Api.User.setCurrentUser(dictionary:["dob" : dateOfBirth.text!])
        }
        if(bioTextView.text!.count > 0){
            Api.User.setCurrentUser(dictionary:["bio" : bioTextView.text!])
        }
        if(self.selectImage != nil){
            uploadAvatar()
        }
        
        else {
            ProgressHUD.showSuccess("Update Successfully", interaction: false)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.moveToProfilePage()
            }
        }
    }
    
    func moveToProfilePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        newViewController.selectedIndex = 2
        self.present(newViewController, animated: true, completion: nil)
    }
    
    @IBAction func cameraTapped(_ sender: Any) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.selectImage = photo.image
                self.avatar.image = self.selectImage
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    
    func uploadAvatar(){
        ProgressHUD.show("Waiting...", interaction: false)
        let storageRef = Storage.storage().reference(forURL: Config.STORAGE_ROOF_REF).child("Avatar").child(Api.User.currentUser!.uid)
        
        storageRef.putData((avatar.image?.jpegData(compressionQuality: 0.1))!, metadata: nil){ (metadata, error) in
            if error != nil {
                return
            }
            storageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                // Uh-oh, an error occurred!
                return
                }
                Api.User.setCurrentUser(dictionary:["profileImageUrl" : downloadURL.absoluteString])
                ProgressHUD.showSuccess("Update Successfully", interaction: false)
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    self.moveToProfilePage()
                }
            }
            
        }
    }
    
}


extension EditProfileViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("return")
        textField.resignFirstResponder()
        return true
    }
}
