//
//  Alert.swift
//  Familog
//
//  Created by 袁翥 on 2019/9/19.
//
//  This file mainly shows that we use UIAlertController to push some important information.
import Foundation
import UIKit

struct Alert {
    static func presentAlert(on vc: UIViewController, with title: String, message: String) {
        let alert: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        DispatchQueue.main.async {
            vc.present(alert, animated: true, completion: nil)
        }
        
    }
}
