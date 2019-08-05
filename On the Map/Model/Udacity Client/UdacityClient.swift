//
//  UdacityClient.swift
//  On the Map
//
//  Created by Ender Güzel on 5.08.2019.
//  Copyright © 2019 Creyto. All rights reserved.
//

import Foundation

class UdacityClient {
    
    struct Auth {
        static var sessionId = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case studentLocations(Int)
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .studentLocations(let result):
                return Endpoints.base + "/StudentLocation" + "?limit=\(result)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func getLoginResponse(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(udacity: AccountRequest(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else
            {
                completion(false, error)
                return
            }
            // According to the documentation
            // first 5 characters should be removed from the data
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(LoginResponse.self, from: newData)
                Auth.sessionId = response.session.id
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(resultOf: Int, completion: @escaping ([StudentLocation]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.studentLocations(resultOf).url) { (data, response, error) in
            guard let data = data else {
                completion(nil, error)
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(LocationResults.self, from: data)
                completion(response.results, nil)
            } catch {
                completion(nil,error)
            }
        }
        task.resume()
    }
}
