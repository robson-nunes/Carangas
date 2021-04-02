//
//  Car.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 25/03/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

struct Car: Codable {
    let id: String?
    var brand: String = ""
    var gasType: Int = 0
    var name: String = ""
    var price: Double = 0.0
    
    var gas: String {
        switch gasType {
        case 0:
            return "Flex"
        case 1:
            return "Alcool"
        default:
            return "Gasolina"
        }
    }
}

extension Car {
    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case brand
        case gasType
        case name
        case price
    }
}
