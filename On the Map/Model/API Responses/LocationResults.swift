//
//  LocationResults.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation

struct LocationResults: Codable {
    let results: [StudentInformation]
    
    enum CodingKeys: String, CodingKey {
        case results
    }
}
