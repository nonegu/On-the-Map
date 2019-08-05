//
//  LoginResponse.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation

struct LoginResponse: Codable {
    let account: AccountResponse
    let session: SessionResponse
    
    enum CodingKeys: String, CodingKey {
        case account
        case session
    }
}
