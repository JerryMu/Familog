//
//  PersonalProfileController.swift
//  monologue
//
//  Created by 刘仕晟 on 2019/9/3.
//

import Foundation
import UIKit

class PersonalProfileController: UIViewController {
    var imagePicker:UIImagePickerController!
    
    @IBOutlet weak var avatar: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAvatar()
        // Do any additional setup after loading the view.
    
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
extension PersonalProfileController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController,didFinishPickingMediaWithInfo info:[ UIImagePickerController.InfoKey : Any] ){
        if let imageSelected = info[UIImagePickerController.InfoKey.editedImage] as?
            UIImage{
            avatar.image = imageSelected
        }
        if let imageOriginal = info[UIImagePickerController.InfoKey.originalImage] as?
            UIImage{
            avatar.image = imageOriginal
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}
