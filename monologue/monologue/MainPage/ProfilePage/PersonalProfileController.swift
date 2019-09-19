
//
//  PersonalProfileController.swift
//  monologue
//
//  Created by 刘仕晟 on 2019/9/3.
//
import Foundation
import UIKit
import FirebaseStorage
import FirebaseAuth
import FirebaseDatabase

class PersonalProfileController: UIViewController {
    var imagePicker:UIImagePickerController!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAvatar()
        // use an instance of it to supply data to this particular table view
        tableView.dataSource = self
        
        //load posts updated on the database
    }
    // upload the avatar to the firebase
    func uploadToFirebase(_ image: UIImage) {
        let imageName = NSUUID().uuidString
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
    // logout
    @IBAction func logoutTapped(_ sender: Any) {
        do{
            // database signout
            try Auth.auth().signOut()
        } catch let logoutError{
            print(logoutError)
        }
        //go back to login
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signInVC = storyboard.instantiateViewController(withIdentifier: "logInVC")
        self.present(signInVC,animated: true , completion: nil)
    }
    
    func setupAvatar(){
        
        avatar.layer.cornerRadius = 40
        avatar.clipsToBounds = true
        avatar.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self ,action: #selector(presentPicker))
        avatar.addGestureRecognizer(tapGesture)
    }
    @objc func presentPicker(){
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker,animated: true,completion: nil)
    }
    
    
    
}
extension PersonalProfileController:UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITableViewDataSource{
    
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
    // decide how many rows table has
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
    
}
