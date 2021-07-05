//
//  Proxy.swift
//  ProjectVK
//
//  Created by Igor on 18.11.2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation

class VKAPIRequestsProxy {
    let request = VKAPIRequests()
    
    public func userGroups(completion: ((Swift.Result<[REALMGroup], Error>) -> Void)? = nil) {
        self.request.userGroups(completion: completion)
        print("Proxy log - called function: userGroups")
    }

    public func loadGroupsData(completion: ((Swift.Result<Data, Error>) -> Void)? = nil) {
        self.request.loadGroupsData(completion: completion)
        print("Proxy log - called function: loadGroupsData")
    }

    public func findGroups(_ searchingGroup: String, completion: ((Swift.Result<[REALMGroup], Error>) -> Void)? = nil) {
        self.request.findGroups(searchingGroup, completion: completion)
        print("Proxy log - called function: findGroups")
    }

    public func joinGroup(_ groupId: Int) {
    }

    public func leaveGroup(_ groupId: Int) {
    }

    public func loadFriends(completion: ((Swift.Result<[REALMFriendProfile], Error>) -> Void)? = nil) {
    }

    public func loadPhotos(_ userID: Int, completion: ((Swift.Result<[REALMFriendPhoto], Error>) -> Void)? = nil) {
    }

    public func loadNews(_ nextList: String, completion: ((Swift.Result<News, Error>) -> Void)? = nil) {
    }

    public func getChats(completion: ((Swift.Result<[ChatsRealm], Error>) -> Void)? = nil) {
    }

    public func getMessages(_ userID: String,_ peerID: String, completion: ((Swift.Result<MessagesResponse, Error>) -> Void)? = nil) {
    }

    public func sendMessages(_ userID: String,_ randomID: Int64, _ peerID: String,_ message: String, completion: ((Swift.Result<MessagesResponse, Error>) -> Void)? = nil) {
    }

    public func sendMessagesTest(_ peerID: Int,_ message: String,_ randomID: Int64, completion: ((Swift.Result<SendMessageResponse, Error>) -> Void)? = nil) {
    }

    
}
