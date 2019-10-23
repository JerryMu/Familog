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
import YPImagePicker
import ProgressHUD
import Vision


class UploadViewController: UIViewController{
    
    let classificationModel = MobileNetV2()
             
             // MARK: - Vision Properties
     var request: VNCoreMLRequest?
     var visionModel: VNCoreMLModel?
  
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
   
    }

    
    
    @IBOutlet weak var ShareButton: DesignableButton!
    
    @IBOutlet weak var photo: UIImageView!
    
  
    @IBOutlet weak var descriptionField: UITextView!
    
    
    var selectedImage: UIImage?
    
    var familyId : String = ""

    // Set the image picker
    @IBAction func dismissPopup(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraTapped(_ sender: Any) {
        let picker = YPImagePicker()
        picker.didFinishPicking { [unowned picker] items, _ in
            if let photo = items.singlePhoto {
                self.selectedImage = photo.image
                self.photo.image = self.selectedImage
            }
            picker.dismiss(animated: true, completion: nil)
        }
        present(picker, animated: true, completion: nil)
        
    }
    func getFamilyId(_ image: UIImage) {
        Api.User.REF_USERS.document(Api.User.currentUser!.uid).getDocument{(document, error) in
                if let document = document, document.exists {
                    let familyId = document.get("familyId") as! String
                    self.uploadToFirebase(image, fid: familyId)
                }
        }
    }
    

    
    // Upload image to Firebase
    func uploadToFirebase(_ image: UIImage, fid : String) {
        ProgressHUD.show("Waiting...", interaction: false)
        let imageName = NSUUID().uuidString
        // Set the image folder in the firebase storage
        let imageRef = Storage.storage().reference(forURL: "gs://monologue-10303.appspot.com/").child("images").child(imageName)
        // Compress the image quality then upload to the firebase storage
        if  let uploadData = image.jpegData(compressionQuality: 0.8) {
            imageRef.putData(uploadData, metadata: nil) {(metadata, error) in
                if error != nil {
                    ProgressHUD.showError("Failed to upload")
                    return
                }
                imageRef.downloadURL(completion: { (url, error) in
                    if error != nil {
                        ProgressHUD.showError("Failed to upload")
                        return
                    }
                    guard let downloadurl = url else {
                        ProgressHUD.showError("Failed to upload")
                        return
                    }
                    
                    
                    func predict(with url: URL) {
                        guard let request = self.request else { fatalError() }

                           // vision framework configures the input size of image following our model's input configuration automatically
                           let handler = VNImageRequestHandler(url: url, options: [:])
                           try? handler.perform([request])
                       }
                    // post-processing
                    func setUpModel() {
                        if let visionModel = try? VNCoreMLModel(for: self.classificationModel.model) {
                            self.visionModel = visionModel
                            self.request = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestDidComplete)
                            self.request?.imageCropAndScaleOption = .scaleFill
                        } else {
                            fatalError()
                            }
                        }
                    
                    
                    
                    // Upload the image download URL and uid to the database
                    setUpModel()
                    predict(with: downloadurl)
                    
                    func visionRequestDidComplete(request: VNRequest, error: Error?) {
                        print(request)

                        if let result = request.results?.first as? VNClassificationObservation {
                            let top1ResultLabel = result.identifier
                            let top1ConfidenceLabel = "\(String(format: "%.2f", result.confidence * 100))%"
                        

                    
                    let db = Firestore.firestore()
                    let postRef = db.collection("Post").document()
                    let uid = postRef.documentID
                    let urlString = downloadurl.absoluteString
                    let currentUser = Auth.auth().currentUser!.uid
                    let description = self.descriptionField.text!.trimmingCharacters(in:.whitespacesAndNewlines)
                    
                    let timestamp = Int(Date().timeIntervalSince1970)
                    let data = ["description": description, "url": urlString, "uid": uid, "userId": currentUser, "familyId": fid,"timestamp": timestamp, "comment" : [], "predictType": top1ResultLabel, "predictAcc":top1ConfidenceLabel] as [String : Any]
                    
                    postRef.setData(data as [String : Any], completion: {(error) in
                        if error != nil {
                            ProgressHUD.showError("Failed to upload")
                            return
                        }
                        ProgressHUD.showSuccess("Upload Successfully", interaction: false)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            self.moveToTimeLinePage()
                        }
                    })
                }
                    }
            
                })
            }
            
        }
    }
    
    @IBAction func shareTapped(_ sender: Any) {
        if selectedImage == nil {
            ProgressHUD.showError("You must pick one Photo")
            return
        }
        if self.descriptionField.text?.trimmingCharacters(in:.whitespacesAndNewlines) == "Describe your artifacts..." {
            ProgressHUD.showError("You must fill description")
            return
        }
        getFamilyId(photo.image!)
    }
    
    // Move to the timeline page
    func moveToTimeLinePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        self.present(newViewController, animated: true, completion: nil)
    }

  
}
