//
//  AddEditCarViewModel.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 15/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

final class AddEditCarViewModel {
    var currentState: State = .add
    private let formatter = NumberFormatter()
    private let repository: CarRepository
    enum State {
        case edit
        case add
    }
    
    private var car: Car?
    private var brands: [Brand] = []
    var numberOfBrands: Int {
        return brands.count
    }
    
    var brand: String {
        return car?.brand ?? ""
    }
    
    var name: String {
        return car?.name ?? ""
    }
    
    var price: String {
        formatter.currencySymbol = Locale(identifier: "pt-BR").currencySymbol
        return formatter.string(from: NSNumber(value: car?.price ?? 0.0)) ?? "R$ ..."
    }
    
    var gasType: Int {
        return car?.gasType ?? 0
    }
    
    init(car: Car? = nil, repository: CarRepository = CarRemoteRepository()) {
        if let car = car {
            self.car = car
            self.currentState = .edit
        } else {
            self.car = Car(id: nil)
            self.currentState = .add
        }
        self.repository = repository
    }
    
    func getBrand(at row: Int) -> Brand? {
        return brands.indices.contains(row) ? brands[row] : nil
    }
    
    func loadBrands(completion: @escaping (() -> Void)) {
        repository.loadBrands { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success(let brands):
                self.brands = brands.sorted(by: {$0.name < $1.name})
            }
            completion()
        }
    }
    
    func addEditCar(brand: String,
                    name: String,
                    gasType: Int,
                    price: String,
                    completion: @escaping ((Result<Void,CarError>)-> Void)) {
        self.car?.brand = brand
        self.car?.name = name
        self.car?.gasType = gasType
        if let price = formatter.number(from: price)?.doubleValue {
            car?.price = price
        } else {
            car?.price = 0
        }
        guard let car = car else {
            return completion(.failure(CarError.noData))
        }
        if car.id == nil {
            repository.save(car: car, completion: completion)
        } else {
            repository.update(car: car, completion: completion)
        }
    }
}
