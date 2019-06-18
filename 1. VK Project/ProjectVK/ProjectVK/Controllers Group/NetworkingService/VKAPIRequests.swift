//
//  VKAPIRequests.swift
//  ProjectVK
//
//  Created by Igor on 19/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class VKAPIRequests {
    
    private let baseUrl = "https://api.vk.com"
    let token = Session.authData.token
    let userId = Session.authData.userid
    
    // MARK: - Load VKgroup
    public func userGroups(completion: ((Swift.Result<[Group], Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token" : token,
            "extended" : "1",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let groupList = json["response"]["items"].arrayValue.map { Group($0) }
                completion?(.success(groupList))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - Search VKgroup
    public func findGroups(_ searchingGroup: String, completion: ((Swift.Result<[Group], Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token" : token,
            "q" : searchingGroup,
            "type" : "group",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let groupList = json["response"]["items"].arrayValue.map { Group($0) }
                completion?(.success(groupList))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

    // MARK: - Load VKfriends
    public func loadFriends(completion: ((Swift.Result<[FriendProfile], Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token" : token,
            "fields" : "nickname,domain,sex,bdate,city,country,photo_50,photo_100,photo_200_orig,online,relation",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let friendList = json["response"]["items"].arrayValue.map { FriendProfile($0) }
                completion?(.success(friendList))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - Load Friend photo
    public func loadPhotos(_ userID: Int, completion: ((Swift.Result<[FriendPhoto], Error>) -> Void)? = nil) {

        let baseURL = "https://api.vk.com"
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token" : token,
            "extended": "1",
            "owner_id" : userID,
            "count" : "100",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let photoList = json["response"]["items"].arrayValue.map { FriendPhoto($0) }
                completion?(.success(photoList))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
   
    // MARK: - Load VKnews
    public func loadNews(_ nextList: String, completion: ((Swift.Result<News, Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/newsfeed.get"
        
        let params: Parameters = [
            "access_token" : token,
            "filters" : "post,photo",
//            "filters" : "post,photo,wall_photo",
//            "source_id" : sourceID,
            "start_from" : nextList,
            "count" : "100",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let response = json["response"].self
                let newsList = News(response)
                completion?(.success(newsList))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    
    // MARK: - URLSession Requests NOT USED
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
    }
     
     public func loadFindedGroups2(_ searchingGroup: String) {
     
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
     
     */
}
