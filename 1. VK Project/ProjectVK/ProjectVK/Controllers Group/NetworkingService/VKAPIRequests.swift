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
    
    // MARK: - Group
    // MARK: - Load VKgroup
    public func userGroups(completion: ((Swift.Result<[REALMGroup], Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token" : token,
            "extended" : "1",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: .global()) {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let groupList = json["response"]["items"].arrayValue.map { REALMGroup($0) }
                completion?(.success(groupList))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - Load GROUPS DATA for Operation
    public func loadGroupsData(completion: ((Swift.Result<Data, Error>) -> Void)? = nil) {
        
        //    public func loadGroupsData(completion: ((Swift.Result<Data, Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/groups.get"
        
        let params: Parameters = [
            "access_token" : token,
            "extended" : "1",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseData { responce in
            switch responce.result {
            case .success(let value):
                completion?(.success(value))
                print("⚡️ DATA DOWNLOAD \(value)")
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - Search VKgroup
    public func findGroups(_ searchingGroup: String, completion: ((Swift.Result<[REALMGroup], Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/groups.search"
        
        let params: Parameters = [
            "access_token" : token,
            "q" : searchingGroup,
            "type" : "group",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: .global()) {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let groupList = json["response"]["items"].arrayValue.map { REALMGroup($0) }
                DispatchQueue.main.async {
                    completion?(.success(groupList))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - Join VKgroup
    public func joinGroup(_ groupId: Int) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/groups.join"
        
        let params: Parameters = [
            "access_token" : token,
            "group_id" : groupId,
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: .global()) {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let response = json["response"].intValue
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    // MARK: - Leave VKgroup
    public func leaveGroup(_ groupId: Int) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/groups.leave"
        
        let params: Parameters = [
            "access_token" : token,
            "group_id" : groupId,
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: .global()) {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let response = json["response"].intValue
                print(response)
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - Users
    // MARK: - Load VKfriends
    public func loadFriends(completion: ((Swift.Result<[REALMFriendProfile], Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/friends.get"
        
        let params: Parameters = [
            "access_token" : token,
            "fields" : "nickname,domain,sex,bdate,city,country,photo_50,photo_100,photo_200_orig,online,relation",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let friendList = json["response"]["items"].arrayValue.map { REALMFriendProfile($0) }
                completion?(.success(friendList))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - Load Friend photo
    public func loadPhotos(_ userID: Int, completion: ((Swift.Result<[REALMFriendPhoto], Error>) -> Void)? = nil) {

        let baseURL = "https://api.vk.com"
        let path = "/method/photos.getAll"
        
        let params: Parameters = [
            "access_token" : token,
            "extended": "1",
            "owner_id" : userID,
            "count" : "100",
            "v" : "5.95"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: .global()) {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let photoList = json["response"]["items"].arrayValue.map { REALMFriendPhoto($0) }
                completion?(.success(photoList))
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - News
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
//            "v" : "5.95"
            "v" : "5.101"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: .global()) {
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
    
    // MARK: - Messages Requests
    // MARK: - Get Chats Requests

    public func getChats(completion: ((Swift.Result<[ChatsRealm], Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/messages.getConversations"
        
        let params: Parameters = [
            "access_token" : token,
            "count" : "200",
            "filter" : "all",
            "extended": "1",
            "v" : "5.101"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: .global()) {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let response = json["response"].self
                let chats = Chats(response)
                var chatsRealm = [ChatsRealm]()
                for i in 0..<chats.items.count {
                    let userID = chats.items[i].conversation.peer.id
                    var userName = ""
                    let peerType = chats.items[i].conversation.peer.type
                    let date = chats.items[i].lastMessage.date
                    var userAvatar = ""
                    var userLastMessage = ""
                    
                    switch chats.items[i].conversation.peer.type {
                    case "user":
                        for i in 0..<chats.profiles.count {
                            if userID == chats.profiles[i].id {
                                userName = chats.profiles[i].name + " " + chats.profiles[i].lastname
                                userAvatar = chats.profiles[i].avatarGroupImage
                                break
                            } else if i == chats.profiles.count - 1 {
                                userName = "Unknowk"
                                userAvatar = "avatar"
                                break
                            }
                        }
                    case "chat":
                        userName = chats.items[i].conversation.chatSettings.title
                        userAvatar = "Groups"
                    case "group":
                        for i in 0..<chats.groups.count {
                            if -userID == chats.groups[i].id {
                                userName = chats.groups[i].name
                                userAvatar = chats.groups[i].image
                                break
                            } else if i == chats.groups.count - 1 {
                                userName = "Unknowk"
                                userAvatar = "avatar"
                                break
                            }
                        }
                    default:
                        print("Not User or Chat")
                    }
                    
                    if chats.items[i].lastMessage.text.isEmpty  {
                        userLastMessage = "Документ 📎"
                    } else {
                        userLastMessage = chats.items[i].lastMessage.text
                    }
      
                    let newChat = ChatsRealm(userID: userID, userName: userName,peerType: peerType, date: date, userAvatar: userAvatar, userLastMessage: userLastMessage)
                    
                    chatsRealm.append(newChat)
                    
                }
                DispatchQueue.main.async {
                    completion?(.success(chatsRealm))
                }
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    // MARK: - Get Messages Requests
    
    public func getMessages(_ userID: String,_ peerID: String, completion: ((Swift.Result<MessagesResponse, Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/messages.getHistory"
        
        let params: Parameters = [
            "access_token" : token,
//            "count" : "200",
            "count" : "50",
            "user_id" : "\(userID)",
            "peer_id" : "\(peerID)",
            "rev" : "",
            "extended": "1",
            "v" : "5.101"
        ]
        
        Alamofire.request(baseURL + path, method: .get, parameters: params).responseJSON(queue: .global()) {
            response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let response = json["response"].self
                let messages = MessagesResponse(response)
                DispatchQueue.main.async {
                    completion?(.success(messages))
                }
                /*print("📬 Messages", messages.items.count)
                for i in 0..<messages.items.count {
                    print("📃 Message text is here -->\(messages.items[i].text)<--")
                }*/
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func sendMessages(_ userID: String,_ randomID: Int64, _ peerID: String,_ message: String, completion: ((Swift.Result<MessagesResponse, Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/messages.send"
        
        let params: Parameters = [
            "access_token" : token,
            "user_id" : "\(userID)",
            "random_id": randomID,
            "peer_id" : "\(peerID)",
            "message" : message,
            "extended": "1",
            "v" : "5.101"
        ]
        
        Alamofire.request(baseURL + path, method: .post, parameters: params).responseJSON(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                let response = json["response"].self
                let messages = MessagesResponse(response)
                DispatchQueue.main.async {
                    completion?(.success(messages))
                }
                print("✉️ Message send \n", messages)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }
    
    public func sendMessagesTest(_ peerID: Int,_ message: String,_ randomID: Int64, completion: ((Swift.Result<SendMessageResponse, Error>) -> Void)? = nil) {
        
        let baseURL = "https://api.vk.com"
        let path = "/method/messages.send"
        
        let params: Parameters = [
            "access_token" : token,
            "peer_id" : "\(peerID)",
            "message" : message,
            "random_id": randomID,
            "extended": "1",
            "v" : "5.101"
        ]
        
        Alamofire.request(baseURL + path, method: .post, parameters: params).responseJSON(queue: .global()) { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
//                let response = json["response"].self
                let messages = SendMessageResponse(json)
                DispatchQueue.main.async {
                    completion?(.success(messages))
                }
                print("✉️ Message send \nОтвет =>", messages)
            case .failure(let error):
                completion?(.failure(error))
            }
        }
    }

}
