//
//  Brand.swift
//  Carangas
//
//  Created by Robson Nunes de Souza on 02/04/21.
//  Copyright © 2021 Eric Brito. All rights reserved.
//

import Foundation

struct Brand: Codable {
    let name: String
}

extension Brand {
    enum CodingKeys: String, CodingKey {
        case name = "fipe_name"
    }
}
