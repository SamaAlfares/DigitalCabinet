//
//  ItemCollectionViewCell.swift
//  DigitalCabinet
//
//  Created by admin on 24.05.2023.
//

import UIKit

class ItemCollectionViewCell: UICollectionViewCell {
    
    var quantityInt: Int = 0
    
    @IBOutlet weak var quantityLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var decreaseBtn: UIButton!
    @IBOutlet weak var increaseBtn: UIButton!
    
    @IBAction func decreaseBtnPressed(_ sender: UIButton) {
        quantityInt = Int(quantityLbl.text!)! - 1
        quantityLbl.text = String(quantityInt)
    }
    
    @IBAction func increaseBtnPressed(_ sender: UIButton) {
        quantityInt = Int(quantityLbl.text!)! + 1
        quantityLbl.text = String(quantityInt)
    }
    
    
}
