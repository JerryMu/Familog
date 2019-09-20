 //
 //  ViewController.swift
 //  monologue
 //
 //  Created by 袁翥 on 2019/8/13.
 //
 
 import UIKit
 import FirebaseAuth
 
 class WelcomeViewController: UIViewController {
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Auth.auth().currentUser != nil {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {(timer) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
                self.present(newViewController, animated: true, completion: nil)
            })
        }
    }
    
 }
 
