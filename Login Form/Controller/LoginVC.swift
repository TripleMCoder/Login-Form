//
//  ViewController.swift
//  Login Form
//
//  Created by Mohamed Mamdouh on 5/26/19.
//  Copyright © 2019 Mohamed Mamdouh. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var emailErrLbl: UILabel!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordErrLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        emailTxtField.textContentType = UITextContentType(rawValue: "")
        passwordTxtField.textContentType = UITextContentType(rawValue: "")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @IBAction func loginBtnPressed(_ sender: Any) {
        if !checkErrors() {
            spinner.startAnimating()
            Auth.auth().signIn(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (authResult, error) in
                self.spinner.stopAnimating()
                if let error = error {
                    let alert = UIAlertController(title: "Log In Failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    print("Done")
                    let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "HomeVC") as! HomeVC
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
        }
    }
    
    func isValidEmail(_ testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    func checkErrors() -> Bool {
        emailErrLbl.isHidden = true
        passwordErrLbl.isHidden = true
        if emailTxtField.text == "" {
            emailErrLbl.text = "Enter your email"
            emailErrLbl.isHidden = false
            return true
        }
        else if !isValidEmail(emailTxtField.text!) {
            emailErrLbl.text = "Not a valid email"
            emailErrLbl.isHidden = false
            return true
        }
        if passwordTxtField.text == "" {
            passwordErrLbl.text = "Enter your Password"
            passwordErrLbl.isHidden = false
        }
        else if passwordTxtField.text!.count < 8 {
            passwordErrLbl.text = "Password must be at least 8 characters"
            passwordErrLbl.isHidden = false
        }
        
        return false
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == emailTxtField {
            passwordTxtField.becomeFirstResponder()
            if emailTxtField.text == "" {
                emailErrLbl.text = "Enter your email"
                emailErrLbl.isHidden = false
            }
            else if !isValidEmail(emailTxtField.text!) {
                emailErrLbl.text = "Not a valid email"
                emailErrLbl.isHidden = false
            }
        }
        else {
            view.endEditing(true)
            let _ = checkErrors()
        }
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == emailTxtField {
            emailErrLbl.isHidden = true
        }
        else {
            passwordErrLbl.isHidden = true
            if emailTxtField.text == "" {
                emailErrLbl.text = "Enter your email"
                emailErrLbl.isHidden = false
            }
            else if !isValidEmail(emailTxtField.text!) {
                emailErrLbl.text = "Not a valid email"
                emailErrLbl.isHidden = false
            }
        }
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
}

