//
//  ApiCars.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 25/03/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation
import Alamofire

let baseURL = "https://carangas.herokuapp.com"
let path = "/cars"

class ApiCars {
    
    class func getCars(completion: @escaping ([Car]) -> Void, onError: @escaping (String) -> Void ) {
        
        let urlString = baseURL + path
        
        AF.request(urlString, method: .get)
            .response { (response) in
                switch response.result {
                
                case .success( _):
                    guard let data = response.data else {return}
                    do {
                        let cars = try JSONDecoder().decode([Car].self, from: data)
                        completion(cars)
                    } catch let error as NSError {
                        onError(error.localizedDescription)
                    }
                    
                case .failure(let error):
                    onError(error.localizedDescription)
                }
            }
    }
    
    class func getBrands(completion: @escaping ([Brand]) -> Void, onError: @escaping (String) -> Void ) {
        
        let urlString = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
        AF.request(urlString, method: .get)
            .response { (response) in
                switch response.result {
                
                case .success(_):
                    guard let data = response.data else {return}
                    do {
                        let brands = try JSONDecoder().decode([Brand].self, from: data)
                        completion(brands)
                    } catch let error as NSError {
                        onError(error.localizedDescription)
                    }
                    
                case .failure( let error):
                    onError(error.localizedDescription)
                }
        }
    }
    
    
    class func saveCar(car: Car, completion: @escaping (Bool) -> Void ) {
        applyOperation(car: car, method: .post, completion: completion)
    }
    
    class func updateCar(car: Car, completion: @escaping (Bool) -> Void ) {
        applyOperation(car: car, method: .put, completion: completion)
    }
    
    class func deleteCar(car: Car, completion: @escaping (Bool) -> Void ) {
        applyOperation(car: car, method: .delete, completion: completion)
    }
}


//MARK: Generic method
extension ApiCars {
    
    private class func applyOperation(car: Car, method: Alamofire.HTTPMethod, completion: @escaping (Bool) -> Void ) {
        
        let urlString = baseURL + path  + (car.id ?? "")
        

        let parameters: [String: Any] = [    "_id": car.id ?? "",
                                           "brand": car.brand,
                                         "gasType": car.gasType,
                                            "name": car.name,
                                           "price": car.price]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]


        AF.request(urlString, method: method, parameters: parameters,encoding: JSONEncoding.prettyPrinted, headers: headers)
            .validate()
            .responseJSON { (response) in
            debugPrint(response)
            switch response.result {

            case .success(_):
                completion(true)
            case .failure(_):
                completion(false)
            }
        }
    }
}
