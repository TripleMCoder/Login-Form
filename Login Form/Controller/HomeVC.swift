//
//  HomeVC.swift
//  Login Form
//
//  Created by Mohamed Mamdouh on 5/27/19.
//  Copyright © 2019 Mohamed Mamdouh. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import Alamofire
import SwiftyJSON
import FBSDKCoreKit
import FBSDKLoginKit

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var countriesName = [String]()
    var countriesCode = [String]()
    let url = "https://restcountries.eu/rest/v2/all"
    @IBOutlet weak var countryCV: UICollectionView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCountries()
    }
    
    func loadCountries(){
        spinner.startAnimating()
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            self.spinner.stopAnimating()
            if let error = response.result.error {
                print(error.localizedDescription)
                return
            }
            guard let data = response.data else {return}
            let json = JSON(data)
            for item in json {
                let name = item.1["name"].stringValue
                let code = item.1["alpha2Code"].stringValue
                self.countriesName.append(name)
                self.countriesCode.append("https://www.countryflags.io/\(code)/flat/64.png")
            }
            self.countryCV.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return countriesName.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = countryCV.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as? CountryCell {
            cell.configureCell(countryName: countriesName[indexPath.row], countryCode: countriesCode[indexPath.row])
            
            return cell
        } else {
            return UICollectionViewCell()
        }
    }

    @IBAction func logoutBtnPressed(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            GIDSignIn.sharedInstance().signOut()
            let manager = LoginManager()
            manager.logOut()
            self.navigationController?.popToRootViewController(animated: true)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
            let alert = UIAlertController(title: "Error signing out", message: signOutError.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        
    }
    

}
