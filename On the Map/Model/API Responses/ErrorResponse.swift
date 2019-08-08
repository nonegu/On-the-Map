//
//  UdacityResponse.swift
//  On the Map
//
//  Created by Ender Güzel on 8.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation

struct ErrorResponse: Codable, LocalizedError {
    let status: Int
    let error: String
    
    var errorDescription: String? {
        return error
    }
}
