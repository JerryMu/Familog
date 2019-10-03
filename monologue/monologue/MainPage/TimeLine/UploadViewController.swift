//
//  WelcomeViewController.swift
//  monologue
//
//  Created by 袁翥 on 2019/8/20.
//
import UIKit
import FirebaseStorage
import FirebaseFirestore
import AVFoundation
import FirebaseAuth

class UploadViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    // Set the image picker
    @IBAction func uploadTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    // Upload image to Firebase
    func uploadToFirebase(_ image: UIImage) {
        let imageName = NSUUID().uuidString
        // Set the image folder in the firebase storage
        let imageRef = Storage.storage().reference(forURL: "gs://monologue-10303.appspot.com/").child("images").child(imageName)
        // Compress the image quality then upload to the firebase storage
        if  let uploadData = image.jpegData(compressionQuality: 0.8) {
            imageRef.putData(uploadData, metadata: nil) {(metadata, error) in
                if error != nil {
                    Alert.presentAlert(on: self, with: "Error!", message: "Failed to upload")
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
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
                    let postRef = db.collection("Post").document()
                    let uid = postRef.documentID
                    let urlString = downloadurl.absoluteString
                    let currentUser = Auth.auth().currentUser!.uid
                    let data = ["discription": "good", "url": urlString, "uid": uid, "username": nil, "userId": currentUser, "familyId":"123456"]
                    
                    postRef.setData(data as [String : Any], completion: {(error) in
                        if error != nil {
                            Alert.presentAlert(on: self, with: "Error!", message: "Failed to upload")
                            return
                        }
                        Alert.presentAlert(on: self, with: "Success!", message: "Upload Successfully!")
                    })
                    db.collection("AllPost").document().setData(data as [String : Any], completion: {(error) in
                        if error != nil {
                            Alert.presentAlert(on: self, with: "Error!", message: "Failed to upload")
                            return
                        }
                        Alert.presentAlert(on: self, with: "Success!", message: "Upload Successfully!")
                    })
                })
            }
        }
    }
    
    
    
}

extension UploadViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    // Pick the image from iphone's photo library
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info:[ UIImagePickerController.InfoKey : Any] ){
        var selectedImageFromPicker: UIImage?
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            selectedImageFromPicker = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebase(selectedImage)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
