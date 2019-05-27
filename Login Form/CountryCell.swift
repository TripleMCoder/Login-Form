//
//  CountryCell.swift
//  Login Form
//
//  Created by Mohamed Mamdouh on 5/27/19.
//  Copyright © 2019 Mohamed Mamdouh. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class CountryCell: UICollectionViewCell {
    
    @IBOutlet weak var flagImageView: UIImageView!
    @IBOutlet weak var countryNameLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    func configureCell(countryName: String, countryCode: String) {
        countryNameLbl.text = countryName
        Alamofire.request(countryCode).responseImage { (response) in
            if let error = response.result.error {
                print(error.localizedDescription)
                return
            }
            guard let img = response.result.value else {return}
            self.flagImageView.image = img
        }
        
    }
    
    func setupView() {
        self.layer.borderWidth = 0.3
        self.layer.borderColor = #colorLiteral(red: 0.7843137255, green: 0.7843137255, blue: 0.7843137255, alpha: 1)
    }
    
}
