//
//  ReminderTableVC.swift
//  Autoworldsale
//
//  Created by Jose De Jesus Garfias Lopez on 1/24/18.
//  Copyright © 2018 Jose De Jesus Garfias Lopez. All rights reserved.
//

import UIKit

class ReminderTableVC: UITableViewCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var reminderLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
