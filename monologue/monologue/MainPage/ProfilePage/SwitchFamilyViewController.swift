//
//  SwitchFamilyViewController.swift
//  Familog
//
//  Created by 袁翥 on 2019/10/13.
//

import UIKit
import ProgressHUD

class SwitchFamilyViewController: UIViewController{

    @IBOutlet weak var tableView: UITableView!
    var families = [Family]()
    var familyDict : [String: String] = [:]
    override func viewDidLoad() {
          super.viewDidLoad()
          tableView.reloadData()
          tableView.dataSource = self
          getFamilies()
      }
    func getFamilies() {
//        Api.User.REF_USERS.document(Api.User.currentUser!.uid).getDocument{(document, error) in
//            if let document = document, document.exists {
//                let families = document.get("families") as! [String]
//                for familyId in families {
//                    Api.Family.REF_FAMILY.document(familyId).getDocument{(document, error) in
//                        if let document = document, document.exists {
//                            let family = Family.transformFamily(dict: document.data()!)
//                            self.families.append(family)
//                            print("FAMILY\(self.familyDict)")
//                            self.familyDict[family.uid!] = family.familyName
//                        } else {
//                            Alert.presentAlert(on: self, with: "Error", message: "Can not get families!")
//                        }
//                    }
//                }
//            } else {
//                Alert.presentAlert(on: self, with: "Error", message: "Can not get families!")
//            }
//        }
        Api.User.REF_USERS.document(Api.User.currentUser!.uid).addSnapshotListener{ documentSnapshot, error in
            if let document = documentSnapshot {
                let families = document.get("families") as! [String]
                for familyId in families {
                Api.Family.REF_FAMILY.document(familyId).addSnapshotListener{ documentSnapshot, error in
                    if let document = documentSnapshot {
                        let family = Family.transformFamily(dict: document.data()!)
                        self.families.append(family)
                        self.familyDict[family.uid!] = family.familyName
                        self.tableView.reloadData()
                    } else {
                        ProgressHUD.showError("Can not get families!")
                    }
                    }
                }
            } else {
                 ProgressHUD.showError("Can not get families!")
            }
        }
    }

    
    @IBAction func newFamilyButtonTouch(_ sender: Any) {
        moveToFamilyPage()
    }
    
}
extension SwitchFamilyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return families.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FamilyCell", for: indexPath) as! SwitchFamilyTableViewCell
        let family = families[indexPath.row]
        cell.famliyButton.text(familyDict[family.uid!]!)
        cell.familyId = family.uid!
        cell.delegate = self
        return cell
        
    }
}

extension SwitchFamilyViewController: SwitchFamilyTableViewCellDelegate {
    func moveToTimeLinePage() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "Tabbar") as! TabBarViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func moveToFamilyPage(){
        let storyBoard = UIStoryboard(name: "Family", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "familyVC")
        self.present(newViewController, animated: true, completion: nil)
    }
}


