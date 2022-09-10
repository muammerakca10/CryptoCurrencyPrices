//
//  ViewController.swift
//  CryptoCurrentPrices
//
//  Created by MAC on 6.09.2022.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate, FavoriteButtonProtocol {
    
    var timer = Timer()
    
    var searchingWord = ""
    
    @IBOutlet var searchBar: UISearchBar!
    
    var cryptosArray = [Crypto]()
    
    var filteredCryptosArray = [Crypto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        self.tabBarController?.tabBar.items![0].image = UIImage(systemName: "house")
        
        let urlString = "https://fapi.binance.com/fapi/v1/ticker/price"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    self.filteredCryptosArray = self.parse(json: data)
                } else {
                    self.showError()
                }
            }
        }
        scheduledTimerWithTimeInterval()
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! CryptoCell
        cell.symbolText!.text = filteredCryptosArray[indexPath.row].symbol
        cell.priceText!.text = filteredCryptosArray[indexPath.row].price
        
        cell.favoriteButtonForProtocol = self
        //cell.favButton.addTarget(self, action: #selector(favButtonTapped), for: .allEvents)
        cell.indexPath = indexPath
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCryptosArray.count
    }
    
    func showError () {
        DispatchQueue.main.async { [weak self] in
            let ac = UIAlertController(title: "Error", message: "An error occurred. Please control your connect!", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self?.present(ac, animated: true)
        }
    }
    
    func parse(json: Data) -> [Crypto]{
        let decoder = JSONDecoder()
        
        if let jsonCryptos = try? decoder.decode([Crypto].self, from: json) {
            cryptosArray = jsonCryptos
            cryptosArray.sort{$0.symbol < $1.symbol}
            
        }
        return cryptosArray
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCryptosArray = []
        searchingWord = searchText
        if searchText == "" {
            filteredCryptosArray = cryptosArray
        }
        for word in cryptosArray {
            if word.symbol.uppercased().contains(searchText.uppercased()){
                filteredCryptosArray.append(word)
            }
        }
        self.tableView.reloadData()
    }
    
    func favoriteButtonClickedInCell(indexPath: IndexPath, sender: UIButton) {
        print("Button clicked \(indexPath.item)")
        
        if sender.imageView?.image == UIImage(systemName: "star"){
            sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else if sender.imageView?.image == UIImage(systemName: "star.fill") {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    
    func scheduledTimerWithTimeInterval(){
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
        let urlString = "https://fapi.binance.com/fapi/v1/ticker/price"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    self.cryptosArray = self.parse(json: data)
                    self.filteredCryptosArray = []
                    if self.searchingWord == "" {
                        self.filteredCryptosArray = self.cryptosArray
                    } else {
                        for crypto in self.cryptosArray {
                            if crypto.symbol.uppercased().contains(self.searchingWord.uppercased()){
                                self.filteredCryptosArray.append(crypto)
                            }
                        }
                    }
                    print(self.filteredCryptosArray)
                } else {
                    self.showError()
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}
