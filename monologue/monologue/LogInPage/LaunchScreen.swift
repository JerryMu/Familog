//
//  File.swift
//  Familog
//
//  Created by Pengyu Mu on 21/9/19.
//
//  Implement auto Sign in Function
//
//  This file is mainly used for the automatic login function.
//  If the user is not using our software for the first time,
//  he will directly enter the Timeline page instead of the authentication interface.

import UIKit
import FirebaseAuth

class LaunchScreenViewController: UIViewController {
   override func viewDidLoad() {
       super.viewDidLoad()
       // Do any additional setup after loading the view.
   }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in

                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
                self.present(newViewController, animated: true, completion: nil)
            })
        }
        else
        {
            Timer.scheduledTimer(withTimeInterval: 1, repeats: false, block: {(timer) in
                
            let storyboard = UIStoryboard(name: "Start", bundle: nil)
            let newViewController = storyboard.instantiateViewController(withIdentifier: "Authentication") as! WelcomeViewController
            self.present(newViewController, animated: true, completion: nil)
            })
        
        }

    }
    
}
