//
//  TableViewCell.swift
//  CryptoCurrentPrices
//
//  Created by MAC on 6.09.2022.
//

import UIKit

class CryptoCell: UITableViewCell {
    
    

    @IBOutlet var symbolText: UILabel!
    @IBOutlet var priceText: UILabel!
    @IBOutlet var favButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
