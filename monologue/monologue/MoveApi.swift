//
//  MoveApi.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/17.
//

import UIKit

class MoveApi: UIViewController {
    
    func moveToTimeLinePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func moveToFamilyPage() {
        let storyBoard = UIStoryboard(name: "Family", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "familyVC")
        self.present(newViewController, animated: true, completion: nil)
    }

    func moveToLogInPage() {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let logInViewController = storyboard.instantiateViewController(withIdentifier: "logInVC") as! LogInViewController
        self.present(logInViewController, animated: true, completion: nil)
    }
}
