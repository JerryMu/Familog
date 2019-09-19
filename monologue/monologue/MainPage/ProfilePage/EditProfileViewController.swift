//
//  EditProfileViewController.swift
//  Familog
//
//  Created by Pengyu Mu on 12/9/19.
//

import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase



class EditProfileViewController: UIViewController {
    
    @IBOutlet weak var avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAvatar()
    }
    func uploadToFirebase(_ image: UIImage) {
        let imageName = NSUUID().uuidString
        //where to put the image data in the database
        let imageRef = Storage.storage().reference().child("images").child(imageName)
        if  let uploadData = image.jpegData(compressionQuality: 0.2) {
            imageRef.putData(uploadData, metadata: nil, completion: {(metadata, error) in
                if error != nil {
                    print("Failed to upload")
                    return
                }
            })
        }
    }
    
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
        
        uploadToFirebase(avatar.image!)
        picker.dismiss(animated: true, completion: nil)
}
}
