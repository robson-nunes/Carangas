//
//  NetworkConstants.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 11/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

struct NetworkConstants {
    struct URLs {
        static var baseURL: URL {
            guard let url = URL(string: "https://carangas.herokuapp.com") else {
                fatalError("Erro ao converter URL")
            }
            return url
        }
        static var fipeURL: URL {
            guard let url = URL(string: "https://fipeapi.appspot.com") else {
                fatalError("Erro ao converter URL")
            }
            return url
        }
    }
    
    struct Headers {
        static var contentTypeApplicationJSON = ["Content-Type": "application/json"]
    }
}
