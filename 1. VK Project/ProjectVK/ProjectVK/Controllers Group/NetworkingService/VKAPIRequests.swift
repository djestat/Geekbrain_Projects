//
//  VKAPIRequests.swift
//  ProjectVK
//
//  Created by Igor on 19/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation

class VKAPIRequests {
    
    private let baseUrl = "https://api.vk.com"
    let token = Session.authData.token
    let userId = Session.authData.userid
    
    public func loadGroups() {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.get"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "extended", value: "1"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        guard let url = urlComponents.url else { fatalError("URL is badly formatted.")}
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            print(json ?? "")
            
        }
        
        task.resume()
    }
    
    public func loadFindedGroups(_ searchingGroup: String) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/groups.search"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "q", value: searchingGroup),
            URLQueryItem(name: "type", value: "group"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        guard let url = urlComponents.url else { fatalError("URL is badly formatted.")}
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            print(json ?? "")
            
        }
        
        task.resume()
    }
    
    public func loadFriends() {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/friends.get"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "fields", value: "nickname,domain,sex,bdate,city,country,photo_50,photo_100,photo_200_orig,,,,online,relation"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        guard let url = urlComponents.url else { fatalError("URL is badly formatted.")}
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            print(json ?? "")
            
        }
        
        task.resume()
    }
    
    public func loadNews() {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/newsfeed.get"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "filters", value: "post,photo,photo_tag,wall_photo"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        guard let url = urlComponents.url else { fatalError("URL is badly formatted.")}
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            print(json ?? "")
            
        }
        
        task.resume()
    }
    
    public func loadPhotos(_ userID: Int) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "api.vk.com"
        urlComponents.path = "/method/photos.getAll"
        
        urlComponents.queryItems = [
            URLQueryItem(name: "access_token", value: token),
            URLQueryItem(name: "owner_id", value: "\(userID)"),
            URLQueryItem(name: "count", value: "37"),
            URLQueryItem(name: "skip_hidden", value: "1"),
            URLQueryItem(name: "v", value: "5.95")
        ]
        
        guard let url = urlComponents.url else { fatalError("URL is badly formatted.")}
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        
        let configuration = URLSessionConfiguration.default
        configuration.allowsCellularAccess = true
        let session = URLSession(configuration: configuration)
        
        let task = session.dataTask(with: request) { (data, response, error) in
            
            guard let data = data else { return }
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
            
            print(json ?? "")
            
        }
        
        task.resume()
    }
    
    /*
    
    static let session: SessionManager = {
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = 60
        let session = SessionManager(configuration: config)
        return session
    }()
    
    public func sendAlamofireRequest(city: String) {
        let path = "/data/2.5/forecast"
        
        let params: Parameters = [
            "q": city,
            "units": "metric",
            "appId": "8b32f5f2dc7dbd5254ac73d984baf306"
        ]
        
        //        let session = SessionManager()
        VKAPIRequests.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
        
        print("end")
    }
    
    func loadGroups(token: String) {
        let baseUrl = "https://api.vk.com"
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token": token,
            "extended": 1,
            "v": "5.92"
        ]
        
        VKAPIRequests.session.request(baseUrl + path, method: .get, parameters: params).responseJSON { response in
            guard let json = response.value else { return }
            
            print(json)
        }
    } */
}
