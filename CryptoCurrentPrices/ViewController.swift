//
//  ViewController.swift
//  CryptoCurrentPrices
//
//  Created by MAC on 6.09.2022.
//

import UIKit

class ViewController: UITableViewController, UISearchBarDelegate, FavoriteButtonProtocol {
    
    
    @IBOutlet var searchBar: UISearchBar!
    
    var cryptosArray = [Crypto]()
    
    var filteredCryptosArray = [Crypto]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        self.tabBarController?.tabBar.items![0].image = UIImage(systemName: "house")

        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(refreshButtonTapped))
        
        let urlString = "https://fapi.binance.com/fapi/v1/ticker/price"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    self.parse(json: data)
                } else {
                    self.showError()
                }
            }
        }
    }
    
    @objc func refreshButtonTapped(){
        
        let urlString = "https://fapi.binance.com/fapi/v1/ticker/price"
        
        DispatchQueue.global(qos: .userInitiated).async {
            if let url = URL(string: urlString){
                if let data = try? Data(contentsOf: url){
                    self.parse(json: data)
                } else {
                    self.showError()
                }
            }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
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
    
    func parse(json: Data){
        let decoder = JSONDecoder()
        
        if let jsonCryptos = try? decoder.decode([Crypto].self, from: json) {
            cryptosArray = jsonCryptos
            cryptosArray.sort{$0.symbol < $1.symbol}
            filteredCryptosArray = cryptosArray
            //print(jsonCryptos)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filteredCryptosArray = []
        
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
        
        //self.tableView.reloadData()
    }
    /*
    @objc func favButtonTapped(sender: UIButton){
        if sender.imageView?.image == UIImage(systemName: "star"){
        sender.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else if sender.imageView?.image == UIImage(systemName: "star.fill") {
            sender.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }
    */
    
}
