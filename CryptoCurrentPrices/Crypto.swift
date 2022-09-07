//
//  Crypto.swift
//  CryptoCurrentPrices
//
//  Created by MAC on 7.09.2022.
//

import Foundation

struct Crypto : Codable {
    
    var symbol : String
    var price : String
    var time : CLong
}
