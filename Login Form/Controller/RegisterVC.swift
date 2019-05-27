//
//  RegisterVC.swift
//  Login Form
//
//  Created by Mohamed Mamdouh on 5/26/19.
//  Copyright © 2019 Mohamed Mamdouh. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit

class RegisterVC: UIViewController, UITextFieldDelegate, GIDSignInUIDelegate {
    
    @IBOutlet weak var emailTxtField: UITextField!
    @IBOutlet weak var emailErrLbl: UILabel!
    @IBOutlet weak var passwordTxtField: UITextField!
    @IBOutlet weak var passwordErrLbl: UILabel!
    @IBOutlet weak var confirmPasswordTxtField: UITextField!
    @IBOutlet weak var confirmPasswordErrLbl: UILabel!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        GIDSignIn.sharedInstance().uiDelegate = self
        self.emailTxtField.delegate = self
        self.passwordTxtField.delegate = self
        self.confirmPasswordTxtField.delegate = self
        emailTxtField.textContentType = UITextContentType(rawValue: "")
        passwordTxtField.textContentType = UITextContentType(rawValue: "")
        confirmPasswordTxtField.textContentType = UITextContentType(rawValue: "")
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @IBAction func signupBtnPressed(_ sender: Any) {
        if !checkErrors() {
            spinner.startAnimating()
            Auth.auth().createUser(withEmail: emailTxtField.text!, password: passwordTxtField.text!) { (authResult, error) in
                self.spinner.stopAnimating()
                if let error = error {
                    let alert = UIAlertController(title: "Sign Up Failed", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
                else {
                    print("Done")
                }
            }
        }
    }
    
    @IBAction func facebookBtnPressed(_ sender: Any) {
        let loginManager = LoginManager()
        loginManager.logIn(permissions: [ .publicProfile ], viewController: self) { loginResult in
            switch loginResult {
            case .failed(let error):
                let alert = UIAlertController(title: "Sign Up Failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .cancelled:
                print("User cancelled login.")
            case .success(let accessToken):
                let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.token.tokenString)
                Auth.auth().signIn(with: credential, completion: { (authResult, error) in
                    if let error = error {
                        let alert = UIAlertController(title: "Sign Up Failed", message: error.localizedDescription, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        return
                    }
                    print("Done")
                })
            }
        }
    }
    
    @IBAction func googleBtnPressed(_ sender: Any) {
        GIDSignIn.sharedInstance().signIn()
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if let error = error {
            let alert = UIAlertController(title: "Sign Up Failed", message: error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signIn(with: credential) { (authResuly, error) in
            if let error = error {
                let alert = UIAlertController(title: "Sign Up Failed", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
                return
            }
            print("Done")
        }
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
        else if textField == passwordTxtField {
            confirmPasswordTxtField.becomeFirstResponder()
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
        else if textField == passwordTxtField {
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
        else {
            confirmPasswordErrLbl.isHidden = true
            if emailTxtField.text == "" {
                emailErrLbl.text = "Enter your email"
                emailErrLbl.isHidden = false
            }
            else if !isValidEmail(emailTxtField.text!) {
                emailErrLbl.text = "Not a valid email"
                emailErrLbl.isHidden = false
            }
            if passwordTxtField.text == "" {
                passwordErrLbl.text = "Enter your Password"
                passwordErrLbl.isHidden = false
            }
            else if passwordTxtField.text!.count < 8 {
                passwordErrLbl.text = "Password must be at least 8 characters"
                passwordErrLbl.isHidden = false
            }
        }
    }
    
    func checkErrors() -> Bool{
        emailErrLbl.isHidden = true
        passwordErrLbl.isHidden = true
        confirmPasswordErrLbl.isHidden = true
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
            return true
        }
        else if passwordTxtField.text!.count < 8 {
            passwordErrLbl.text = "Password must be at least 8 characters"
            passwordErrLbl.isHidden = false
            return true
        }
        if confirmPasswordTxtField.text == "" {
            confirmPasswordErrLbl.text = "Confirm your password"
            confirmPasswordErrLbl.isHidden = false
            return true
        }
        else if passwordTxtField.text != confirmPasswordTxtField.text {
            confirmPasswordErrLbl.text = "Passwords don't match"
            confirmPasswordErrLbl.isHidden = false
            return true
        }
        
        return false
        
    }
    
    func isValidEmail(_ testStr: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    
    @objc func handleTap() {
        view.endEditing(true)
    }
    
}
