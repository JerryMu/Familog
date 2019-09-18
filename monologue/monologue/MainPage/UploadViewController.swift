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

class UploadViewController: UIViewController{
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func uploadTapped(_ sender: Any) {
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = true
        imagePicker.sourceType = .photoLibrary
        //imagePicker.mediaTypes = [kUTTypeImage as String, kUTTypeMoive as String]
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func uploadToFirebase(_ image: UIImage) {
        let imageName = NSUUID().uuidString
        let imageRef = Storage.storage().reference().child("images").child(imageName)
        if  let uploadData = image.jpegData(compressionQuality: 0.8) {
            imageRef.putData(uploadData, metadata: nil) {(metadata, error) in
                if error != nil {
                    print("Failed to upload")
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        print("Failed to upload")
                        return
                    }
                    guard let downloadurl = url else {
                        print("Failed to upload")
                        return
                    }
                    let db = Firestore.firestore()
                    let documentUid = db.collection("Artifacts").document().documentID
                    let urlString = downloadurl.absoluteString
                    
                    let data = ["uid": documentUid, "imageURL": urlString]
                    
                    db.collection("Artifacts").document().setData(data, completion: {(error) in
                        if error != nil {
                            print("fail")
                            return
                        }
                        UserDefaults.standard.set(documentUid, forKey: "uid")
                    })
                    
                    
                })
            }
        }
        print("Upload")
    }
    
    
    
}
extension UploadViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
        print("Good")
    }
    
}
