//
//  CarRemoteRepository.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 15/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Moya

struct CarRemoteRepository: CarRepository {
    
    private var engine: Networking<CarEndpoints> {
        let provider = MoyaProvider<CarEndpoints>(plugins:[NetworkLoggerPlugin()])
        return Networking<CarEndpoints>(provider: provider)
    }
    
    func save(car: Car, completion: @escaping (Result<Void, CarError>) -> Void) {
        engine.requestVoid(target: .save(car: car), completion: completion)
    }
    
    func update(car: Car, completion: @escaping (Result<Void, CarError>) -> Void) {
        engine.requestVoid(target: .update(car: car), completion: completion)
    }
    
    func delete(car: Car, completion: @escaping (Result<Void, CarError>) -> Void) {
        engine.requestVoid(target: .delete(car: car), completion: completion)
    }
    
    func loadBrands(completion: @escaping (Result<[Brand], CarError>) -> Void) {
        engine.request(target: .loadBrands, completion: completion)
    }
    
    func loadCars(completion: @escaping (Result<[Car], CarError>) -> Void) {
        engine.request(target: .loadCars, completion: completion)
    }
}
