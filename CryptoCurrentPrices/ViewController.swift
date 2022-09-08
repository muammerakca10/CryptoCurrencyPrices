//
//  ViewController.swift
//  CryptoCurrentPrices
//
//  Created by MAC on 6.09.2022.
//

import UIKit

class ViewController: UITableViewController {
    
    var cryptosArray = [Crypto]()
    
    var favCryptosArray = [Crypto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://fapi.binance.com/fapi/v1/ticker/price"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    print("asdf")
                    self.parse(json: data)
                } else {
                    self.showError()
                }
            }
        }
        //print(cryptosArray)
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CryptoCell
        cell.symbolText!.text = cryptosArray[indexPath.row].symbol
        cell.priceText!.text = cryptosArray[indexPath.row].price
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cryptosArray.count
    }
    
    func showError () {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Error", message: "An error occurred. Please control your connect!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(ac, animated: true)
        }
    }
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonCryptos = try? decoder.decode([Crypto].self, from: json) {
            cryptosArray = jsonCryptos
            print(jsonCryptos)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
}

