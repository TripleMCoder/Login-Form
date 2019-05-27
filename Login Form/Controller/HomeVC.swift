//
//  HomeVC.swift
//  Login Form
//
//  Created by Mohamed Mamdouh on 5/27/19.
//  Copyright © 2019 Mohamed Mamdouh. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var countriesName = [String]()
    var countriesCode = [String]()
    let url = "https://restcountries.eu/rest/v2/all"
    @IBOutlet weak var countryCV: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        loadCountries()
    }
    
    func loadCountries(){
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: self.view.frame.width/2, height: collectionView.frame.height)
//    }
    
    @IBAction func logoutBtnPressed(_ sender: Any) {
    }
    

}
