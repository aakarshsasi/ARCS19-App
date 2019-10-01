//
//  workshopCarousalCollectionViewCell.swift
//  arcs
//
//  Created by Aakarsh S on 04/02/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit

class workshopCarousalCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
            self.workView.layer.shadowColor=UIColor.gray.cgColor
            self.workView.layer.shadowOpacity=0.5
            self.workView.layer.shadowOpacity=10.0
            self.workView.layer.shadowOffset = .zero
            self.workView.layer.shadowPath=UIBezierPath(rect:self.workView.bounds).cgPath
            self.workView.layer.shouldRasterize=true
            self.workView.layer.cornerRadius=10.0
        }
        
    }
    @IBOutlet weak var workshopImage: UIImageView!
    
    @IBOutlet weak var workView: UIView!
    

}
