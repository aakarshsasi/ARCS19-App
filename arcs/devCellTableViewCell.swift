//
//  devCellTableViewCell.swift
//  arcs
//
//  Created by Aakarsh S on 10/02/19.
//  Copyright © 2019 Aakarsh. All rights reserved.
//

import UIKit

class devCellTableViewCell: UITableViewCell {

    @IBOutlet weak var devName: UILabel!
    @IBOutlet weak var devRole: UILabel!
    @IBOutlet weak var devImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
