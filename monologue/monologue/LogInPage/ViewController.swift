 //
 //  ViewController.swift
 //  monologue
 //
 //  Created by 袁翥 on 2019/8/13.
 //
 
 import UIKit
 import FirebaseAuth
 
 class ViewController: UIViewController {
    
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var logInButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if Auth.auth().currentUser != nil {
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false, block: {(timer) in
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let newViewController = storyboard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
                self.present(newViewController, animated: true, completion: nil)
            })
        }
    }
    
 }
 
