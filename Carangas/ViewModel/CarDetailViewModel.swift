//
//  CarDetailViewModel.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 16/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

import UIKit
final class CarDetailViewModel {
    private (set) var car: Car
    private var formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale(identifier: "pt-BR")
        formatter.currencySymbol = Locale(identifier: "pt-BR").currencySymbol
        formatter.alwaysShowsDecimalSeparator = true
        return formatter
    }()
    init(car: Car) {
        self.car = car
    }
    
    var name: String {
        return car.name
    }
    var brand: String {
        return car.brand
    }
    
    var price: String {
        return formatter.string(for: car.price) ?? "R$ ..."
    }
    
    var gas: String {
        return car.gas
    }
    
    var nameSearch: String {
        return (car.name + "+" + car.brand).replacingOccurrences(of: " ", with: "+")
    }
}
