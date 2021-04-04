//
//  ApiCars.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 25/03/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

let baseURL = "https://carangas.herokuapp.com"
let path = "/cars"

class ApiCars {
    
    private static var configuration: URLSessionConfiguration = {
        let config = URLSessionConfiguration.default
        config.allowsCellularAccess = false
        config.httpAdditionalHeaders = ["Content-Type": "application/json"]
        config.timeoutIntervalForRequest = 30.0
        config.httpMaximumConnectionsPerHost = 5
        return config
    }()
    
    private static let session = URLSession(configuration: configuration)
    
}


// MARK: -  Services
extension ApiCars {
    
    class func getCars(completion: @escaping ([Car]) -> Void, onError: @escaping (CarError) -> Void ) {
        
        let urlString = baseURL + path
        
        guard let url = URL(string: urlString) else {
            onError(.url)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                
                let statusCode = HTTPStatusCode(rawValue: response.statusCode)
                
                switch statusCode {
                case .ok:
                    guard let dataResponse = data else {return}
                    
                    do {
                        let decoder = JSONDecoder()
                        let cars = try decoder.decode([Car].self, from: dataResponse)
                        completion(cars)
                    } catch {
                        onError(.invalidJSON)
                    }
                default:
                    onError(.responseStatusCode(response.statusCode))
                }
                
            } else {
                onError(.taskError(error!))
            }
        }
        task.resume()
    }
    
    class func getBrands(completion: @escaping ([Brand]) -> Void, onError: @escaping (CarError) -> Void ) {
        
        let urlString = "https://fipeapi.appspot.com/api/1/carros/marcas.json"
        
        guard let url = URL(string: urlString) else {
            onError(.url)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            if error == nil {
                guard let response = response as? HTTPURLResponse else {
                    onError(.noResponse)
                    return
                }
                
                let statusCode = HTTPStatusCode(rawValue: response.statusCode)
                
                switch statusCode {
                case .ok:
                    guard let dataResponse = data else {return}
                    
                    do {
                        let decoder = JSONDecoder()
                        let brands = try decoder.decode([Brand].self, from: dataResponse)
                        completion(brands)
                    } catch {
                        onError(.invalidJSON)
                    }
                default:
                    onError(.responseStatusCode(response.statusCode))
                }
                
            } else {
                onError(.taskError(error!))
            }
        }
        task.resume()
    }
    
    
    class func saveCar(car: Car, completion: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .post, completion: completion)
    }
    
    class func updateCar(car: Car, completion: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .put, completion: completion)
    }
    
    class func deleteCar(car: Car, completion: @escaping (Bool) -> Void ) {
        applyOperation(car: car, operation: .delete, completion: completion)
    }
}


//MARK: Generic method
extension ApiCars {
    
    private class func applyOperation(car: Car, operation: RestOperation, completion: @escaping (Bool) -> Void ) {
        
        let urlString = baseURL + path + "/" + (car.id ?? "")
        guard let url = URL(string: urlString) else {
            completion(false)
            return
        }
        
        var httpMethod = ""
        switch operation {
        case .get:
            httpMethod = operation.rawValue
        case .post:
            httpMethod = operation.rawValue
        case .put:
            httpMethod = operation.rawValue
        case .delete:
            httpMethod = operation.rawValue
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        guard let json = try? JSONEncoder().encode(car)  else {
            completion(false)
            return
        }
        request.httpBody = json
        
        let task = session.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
            
            guard error == nil else {
                completion(false)
                return
            }
            guard let response = response as? HTTPURLResponse else {
                completion(false)
                return
            }
            
            let statusCode = HTTPStatusCode(rawValue: response.statusCode)
            
            switch statusCode {
            case .ok:
                guard let _ = data else {return}
                completion(true)
            default:
                completion(false)
            }
        }
        task.resume()
    }
}
