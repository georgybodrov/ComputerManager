//
//  ComputerInTheCartTVCell.swift
//  ManagerForAPI
//
//  Created by Гоша Бодров on 24.10.2018.
//  Copyright © 2018 Гоша Бодров. All rights reserved.
//

import UIKit

class ComputerInTheCartTVCell: UITableViewCell {
    @IBOutlet weak var computerName: UILabel!
    @IBOutlet weak var computerId: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
