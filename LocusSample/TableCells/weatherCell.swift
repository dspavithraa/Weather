//
//  weatherCell.swift
//  LocusSample
//
//  Created by Pavi on 15/01/22.
//

import UIKit

class weatherCell: UITableViewCell {

    @IBOutlet weak var weatherLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
