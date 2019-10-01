//
//  comboCollectionViewCell.swift
//  
//
//  Created by Aakarsh S on 24/02/19.
//

import UIKit
import WebKit

class comboCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var viewButton: UIButton!
    
    @IBOutlet weak var comboImage: UIImageView!
    @IBOutlet weak var comboTitle: UILabel!
    @IBOutlet weak var cntView: UIView!
    @IBOutlet weak var comboDescription: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.cntView.layer.cornerRadius=10.0
        self.comboImage.layer.cornerRadius=10.0
    }
    @IBOutlet weak var comboPrice: UILabel!
    
    
}
