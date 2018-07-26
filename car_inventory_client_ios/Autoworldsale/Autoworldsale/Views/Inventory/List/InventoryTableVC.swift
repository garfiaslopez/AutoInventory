//
//  InventoryTableVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/23/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit

class InventoryTableVC: UITableViewCell {

    @IBOutlet weak var idLabel: UILabel!
    @IBOutlet weak var brandLabel: UILabel!
    @IBOutlet weak var arrivalLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var colorView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
