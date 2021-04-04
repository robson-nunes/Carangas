//
//  CarError.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 25/03/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

enum CarError: Error {
    case url
    case taskError(_ error: Error)
    case noResponse
    case noData
    case responseStatusCode(_ code: Int)
    case invalidJSON
}

extension CarError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .invalidJSON:
            return NSLocalizedString("JSON inválido", comment: "")
        case .noData:
            return NSLocalizedString("DATA inexiste", comment: "")
        case .noResponse:
            return NSLocalizedString("RESPONSE inexiste", comment: "")
        case .responseStatusCode(let statusCode):
            let format = NSLocalizedString("Erro: \(statusCode)", comment: "")
            return  String(format: format, String(statusCode))
        case .url:
            return NSLocalizedString("URL inválida", comment: "")
        case .taskError( let error):
            let format = NSLocalizedString("'%@'", comment: "")
            return  String(format: format, String(error.localizedDescription))
        }
    }
}
