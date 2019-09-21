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


class EditProfileViewController: UIViewController {
    
    // set profile photo function
    @IBOutlet weak var avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAvatar()
    }
    func uploadToFirebase(_ image: UIImage) {
        let avatarName = NSUUID().uuidString
        // Set the image folder in the firebase storage
        let avatarRef = Storage.storage().reference(forURL: "gs://monologue-10303.appspot.com/").child("Avatar").child(avatarName)
        // Compress the image quality then upload to the firebase storage
        if  let uploadData = image.jpegData(compressionQuality: 0.8) {
            avatarRef.putData(uploadData, metadata: nil) {(metadata, error) in
                if error != nil {
                    Alert.presentAlert(on: self, with: "Error!", message: "Failed to upload")
                    return
                }
                avatarRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        Alert.presentAlert(on: self, with: "Error!", message: "Failed to upload")
                        return
                    }
                    guard let downloadurl = url else {
                        Alert.presentAlert(on: self, with: "Error!", message: "Failed to upload")
                        return
                    }
                    
                    // Upload the image download URL and uid to the database
                    let db = Firestore.firestore()
                    let userRef = db.collection("Users")
                    let currentUser = Auth.auth().currentUser!.uid
                    let avatarRef = userRef.document(currentUser).collection("Avatar").document()
                    let avatarUid = avatarRef.documentID
                    let urlString = downloadurl.absoluteString
                    
                    let data = ["URL": urlString, "uid": avatarUid]
                    avatarRef.setData(data, completion: {(error) in
                        if error != nil {
                            Alert.presentAlert(on: self, with: "Error!", message: "Failed to upload")
                            return
                        }
                        UserDefaults.standard.set(avatarUid, forKey: "uid")
                        Alert.presentAlert(on: self, with: "Success!", message: "Upload Successfully!")
                    })
                })
            }
        }
    }
    // setup Avatar
    func setupAvatar(){
        avatar.layer.borderWidth = 1
        avatar.layer.masksToBounds = false
        avatar.layer.borderColor = UIColor.black.cgColor
        avatar.layer.cornerRadius = avatar.frame.height/2
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self ,action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    // open image picker
    @objc func presentPicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker,animated: true,completion: nil)
    }
    
    
    
}
//
extension EditProfileViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
          return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //create reuasble cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath)
        cell.textLabel?.text="\(indexPath.row)"
        cell.backgroundColor = UIColor.red
        return cell
    }
    
    
    
    
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
        uploadToFirebase(avatar.image!)
        // close it
        picker.dismiss(animated: true, completion: nil)
}
}
