//
//  CarRepository.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 12/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

protocol CarRepository {
    func save(car: Car, completion: @escaping (Result<Void,CarError>) -> Void)
    func update(car: Car, completion: @escaping(Result<Void,CarError>) -> Void)
    func delete(car: Car, completion: @escaping(Result<Void,CarError>) -> Void)
    func loadBrands(completion: @escaping(Result<[Brand],CarError>) -> Void)
    func loadCars(completion: @escaping(Result<[Car],CarError>) -> Void)
}
