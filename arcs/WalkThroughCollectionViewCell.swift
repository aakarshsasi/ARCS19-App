//
//  WalkThroughCollectionViewCell.swift
//  arcs
//
//  Created by Aakarsh S on 30/01/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit

class WalkThroughCollectionViewCell: UICollectionViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        DispatchQueue.main.async {
           
            self.cntVIew.layer.cornerRadius=10.0
        }
    }
    @IBOutlet weak var ibTitle: UILabel!
    @IBOutlet weak var cntVIew: UIView!
    @IBOutlet weak var sponsorLogo: UIImageView!
    @IBOutlet weak var viewButton: UIButton!

    
}
