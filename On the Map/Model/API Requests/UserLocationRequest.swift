//
//  UserLocationRequest.swift
//  On the Map
//
//  Created by Ender Güzel on 6.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation

struct UserLocationRequest: Codable {
    let uniqueKey: String
    let firstName: String
    let lastName: String
    let mapString: String
    let mediaURL: String
    let latitude: Double
    let longitude: Double
}
