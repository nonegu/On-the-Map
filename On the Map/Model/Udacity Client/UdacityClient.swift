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
        static var userId = ""
        static var userFirstName = ""
        static var userLastName = ""
    }
    
    enum Endpoints {
        static let base = "https://onthemap-api.udacity.com/v1"
        
        case login
        case getStudentLocations(Int)
        case markUserLocation
        case updateUserLocation
        case logout
        case getUserData
        
        var stringValue: String {
            switch self {
            case .login:
                return Endpoints.base + "/session"
            case .getStudentLocations(let result):
                return Endpoints.base + "/StudentLocation" + "?order=-updatedAt" + "&limit=\(result)"
            case .markUserLocation:
                return Endpoints.base + "/StudentLocation"
            case .updateUserLocation:
                return Endpoints.base + "/StudentLocation/\(LocationModel.userObjectId!)"
            case .logout:
                return Endpoints.base + "/session"
            case .getUserData:
                return Endpoints.base + "/users/\(Auth.userId)"
            }
        }
        
        var url: URL {
            return URL(string: stringValue)!
        }
    }
    
    class func login(username: String, password: String, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.login.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = LoginRequest(udacity: AccountRequest(username: username, password: password))
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else
            {
                DispatchQueue.main.async {
                    completion(false, error)
                }
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
                Auth.userId = response.account.key
                print(Auth.userId)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                do {
                    let errorResponse = try decoder.decode(ErrorResponse.self, from: newData) as Error
                    DispatchQueue.main.async {
                        completion(false, errorResponse)
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(false, error)
                    }
                }
            }
        }
        task.resume()
    }
    
    class func logout(completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.logout.url)
        request.httpMethod = "DELETE"
        
        var xsrfCookie: HTTPCookie? = nil
        let sharedCookieStorage = HTTPCookieStorage.shared
        
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(false, error)
                }
                return
            }
            
            // According to the documentation
            // first 5 characters should be removed from the data
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let _ = try decoder.decode(LogoutResponse.self, from: newData)
                DispatchQueue.main.async {
                    completion(true, nil)
                }
            } catch {
                DispatchQueue.main.async {
                    completion(false, error)
                }
            }
        }
        task.resume()
    }
    
    // Following Method can not be used until the UdacityAPI fixed.
    class func getUserData(completion: @escaping (Bool, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getUserData.url) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            // According to the documentation
            // first 5 characters should be removed from the data
            let range = 5..<data.count
            let newData = data.subdata(in: range)
            
            let decoder = JSONDecoder()
            do {
                let response = try decoder.decode(UserDataResponse.self, from: newData)
                Auth.userFirstName = response.user.firstName
                Auth.userLastName = response.user.lastName
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    class func getStudentLocations(resultOf: Int, completion: @escaping ([StudentInformation]?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: Endpoints.getStudentLocations(resultOf).url) { (data, response, error) in
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
    
    class func markUserLocation(body: UserLocationRequest, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.markUserLocation.url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let response = try decoder.decode(AddLocationResponse.self, from: data)
                LocationModel.userObjectId = response.objectId
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
    
    class func updateUserLocation(body: UserLocationRequest, completion: @escaping (Bool, Error?) -> Void) {
        var request = URLRequest(url: Endpoints.updateUserLocation.url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try! JSONEncoder().encode(body)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let data = data else {
                completion(false, error)
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let _ = try decoder.decode(UpdateLocationResponse.self, from: data)
                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
        task.resume()
    }
}
