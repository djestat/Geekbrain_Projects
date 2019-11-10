//
//  FriendModel.swift
//  ProjectVK
//
//  Created by Igor on 10.11.2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation

class FriendProfile {
    let id: Int
    let name: String
    let lastname: String
    let avatarGroupImage: String
    let avatarImage: String
    let online: Int
    
    init(id: Int, name: String, lastname: String, avatarGroupImage: String, avatarImage: String, online: Int) {
        self.id = id
        self.name = name
        self.lastname = lastname
        self.avatarGroupImage = avatarGroupImage
        self.avatarImage = avatarImage
        self.online = online
    }
}

class FriendPhoto {
    let id: Int
    let ownerid: Int
    let photo: String
    let likes: Int
    let isLiked: Int
    
    init(id: Int, ownerid: Int, photo: String, likes: Int, isLiked: Int) {
        self.id = id
        self.ownerid = ownerid
        self.photo = photo
        self.likes = likes
        self.isLiked = isLiked
    }
}
