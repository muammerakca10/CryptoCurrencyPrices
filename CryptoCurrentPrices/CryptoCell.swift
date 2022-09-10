//
//  TableViewCell.swift
//  CryptoCurrentPrices
//
//  Created by MAC on 6.09.2022.
//

import UIKit

protocol FavoriteButtonProtocol {
    func favoriteButtonClickedInCell(indexPath : IndexPath, sender: UIButton)
}

class CryptoCell: UITableViewCell {
    
    var favoriteButtonForProtocol : FavoriteButtonProtocol?
    var indexPath : IndexPath?
    

    @IBOutlet var symbolText: UILabel!
    @IBOutlet var priceText: UILabel!
    @IBOutlet var favButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    @IBAction func favoriteButtonAction(_ sender: Any) {
        
        favoriteButtonForProtocol?.favoriteButtonClickedInCell(indexPath: indexPath!, sender: sender as! UIButton)
    }
    
}
