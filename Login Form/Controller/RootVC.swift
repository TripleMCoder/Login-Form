//
//  RootVC.swift
//  Login Form
//
//  Created by Mohamed Mamdouh on 5/27/19.
//  Copyright © 2019 Mohamed Mamdouh. All rights reserved.
//

import UIKit
import Firebase

class RootVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if Auth.auth().currentUser != nil {
            let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
            self.navigationController?.pushViewController(homeVC, animated: false)
        }
        else {
            let loginVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
            self.navigationController?.pushViewController(loginVC, animated: false)
        }
    }

}
