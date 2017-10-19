//
//  CustomTableViewCell.swift
//  IndoorMap
//
//  Created by Alok Ranjan on 9/26/17.
//  Copyright © 2017 Estimote, Inc. All rights reserved.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    @IBOutlet var asset: UILabel!
    @IBOutlet var rssi: UILabel!
    @IBOutlet var proximity: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
