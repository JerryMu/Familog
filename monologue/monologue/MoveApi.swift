//
//  MoveApi.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/17.
//

import UIKit

class MoveApi: UIViewController {
    
    func moveToTimeLinePage(vc: UIViewController) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        vc.present(newViewController, animated: true, completion: nil)
    }
    
    func moveToFamilyPage(vc: UIViewController) {
        let storyBoard = UIStoryboard(name: "Family", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "familyVC")
        vc.present(newViewController, animated: true, completion: nil)
    }

    func moveToLogInPage(vc: UIViewController) {
        let storyboard = UIStoryboard(name: "Start", bundle: nil)
        let logInViewController = storyboard.instantiateViewController(withIdentifier: "logInVC") as! LogInViewController
        vc.present(logInViewController, animated: true, completion: nil)
    }
}
