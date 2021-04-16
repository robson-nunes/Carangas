//
//  CarsViewModel.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 15/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

final class CarsViewModel {
    private let repository: CarRepository
    var stateChange: (()-> Void)?
    private var cars: [Car] = [] {
        didSet {
            currentState = cars.isEmpty ? .noCars : .loaded
        }
    }
    var currentState: State = .loading {
        didSet {
            stateChange?()
        }
    }
    
    var numberOfCars: Int {
        return cars.count
    }
    enum State: String {
        case loading = "Carregando carros..."
        case noCars = "Não existem carros cadastrados."
        case loaded = ""
    }
    
    init(repository: CarRepository = CarRemoteRepository()) {
        self.repository = repository
    }
    
    func removeCar(at indexPath: IndexPath) {
        if cars.indices.contains(indexPath.row) {
            self.cars.remove(at: indexPath.row)
        }
    }
    
    func car(for indexPath: IndexPath) -> Car? {
        return cars.indices.contains(indexPath.row) ? cars[indexPath.row] : nil
    }
    
    func loadCars(completion: @escaping() -> Void) {
        currentState = .loading
        repository.loadCars { (result) in
            switch result {
            case .failure(let error):
                print(error.localizedDescription)
            case .success(let cars):
                self.cars = cars
            }
            completion()
        }
    }
    
    func delete(car: Car, at indexPath: IndexPath, completion: @escaping() -> Void) {
        repository.delete(car: car) { (result) in
            switch result {
            case .failure(let error):
                print(error)
            case .success:
                self.removeCar(at: indexPath)
            }
            completion()
        }
    }
}
