//
//  UserDataResponse.swift
//  On the Map
//
//  Created by Ender Güzel on 9.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation

struct UserDataResponse: Codable {
    let user: User
}

struct User: Codable {
    let lastName: String
    let firstName: String
    
    enum CodingKeys: String, CodingKey {
        case lastName = "last_name"
        case firstName = "first_name"
    }
}
