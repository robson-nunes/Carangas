//
//  CarService.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 12/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

//import Foundation
import Moya
enum CarEndpoints {
    case loadCars
    case save(car: Car)
    case update(car: Car)
    case delete(car: Car)
    case loadBrands
}

extension CarEndpoints: TargetType {
    var baseURL: URL {
        switch self {
        case .loadBrands:
            return NetworkConstants.URLs.fipeURL
        default:
            return NetworkConstants.URLs.baseURL
        }
    }
    
    var path: String {
        switch self {
        case .loadBrands:
            return "/api/1/carros/marcas.json"
        case .delete(let car),
             .update(let car),
             .save(let car):
            return "/cars/\(car.id ?? "")"
        case .loadCars:
            return "/cars"
        }
    }
    
    var method: Method {
        switch self {
        case .delete:
            return .delete
        case .loadBrands,
             .loadCars:
            return .get
        case .save:
            return .post
        case .update:
            return .put
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        switch self {
        case .delete(let car as Encodable),
             .update(let car as Encodable),
             .save(let car as Encodable):
            return .requestJSONEncodable(car)
        case .loadBrands,
             .loadCars:
            return .requestPlain
        }
    }
    
    var headers: [String : String]? {
        return NetworkConstants.Headers.contentTypeApplicationJSON
    }
    
    var validationType: ValidationType {
        return ValidationType.successCodes
    }
}
