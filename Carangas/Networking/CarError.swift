//
//  CarError.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 25/03/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

enum CarError {
    case url
    case taskError(error: Error)
    case noResponse
    case noData
    case responseStatusCode(_ code: Int)
    case invalidJSON
}
