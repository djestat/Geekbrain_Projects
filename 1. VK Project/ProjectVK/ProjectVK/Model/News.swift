//
//  News.swift
//  ProjectVK
//
//  Created by Igor on 26/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

struct News3 {
    
//    let groupImage: String
    let groupName: Int
    var newsPhotos: String
    let likeCounts: Int
    let commentsCount: Int
    let viewsCounts: Int
    let textNews: String
    var sizes: Int
    
    init(_ json: JSON) {
//        self.image = json["type"].stringValue
        self.groupName = json["source_id"].intValue
        self.sizes = json["attachments"][0]["link"]["photo"]["sizes"].arrayValue.count
        self.newsPhotos = json["attachments"][0]["link"]["photo"]["sizes"][sizes - 1]["url"].stringValue
        self.sizes = json["attachments"][0]["photo"]["sizes"].arrayValue.count
        self.newsPhotos = json["attachments"][0]["photo"]["sizes"][sizes - 1]["url"].stringValue
        self.likeCounts = json["likes"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.viewsCounts = json["views"]["count"].intValue
        self.textNews = json["text"].stringValue
        
    }
    
}


//MARK: News2 Extended
class News {
    let items: [ResponseItem]
    let profiles: [FriendProfile]
    let groups: [Group]
    let nextFrom: String
    
    init(items: [ResponseItem], profiles: [FriendProfile], groups: [Group], nextFrom: String) {
        self.items = items
        self.profiles = profiles
        self.groups = groups
        self.nextFrom = nextFrom
    }
    
    init(_ json: JSON) {
        self.items = json["items"].arrayValue.map { ResponseItem($0) }
        self.profiles = json["profiles"].arrayValue.map { FriendProfile($0) }
        self.groups = json["groups"].arrayValue.map { Group($0) }
        self.nextFrom = json["next_from"].stringValue
    }
}


// MARK: - ResponseItem
class ResponseItem {
    let type: String
    let sourceID: Int
    let date: Int
    let photos: Photos
    let postID: Int
    let text: String
    let attachments: [Attachments]
    let copyhistory: [ResponseItem]
    let likes: Likes
    let reposts: Reposts
    let comments: Comments
    let views: Views
    
    init(type: String, sourceID: Int, date: Int, photos: Photos, postID: Int, text: String, attachments: [Attachments], copyhistory: [ResponseItem], likes: Likes, reposts: Reposts, comments: Comments, views: Views) {
        self.type = type
        self.sourceID = sourceID
        self.date = date
        self.photos = photos
        self.postID = postID
        self.text = text
        self.attachments = attachments
        self.copyhistory = copyhistory
        self.likes = likes
        self.reposts = reposts
        self.comments = comments
        self.views = views
    }
    
    init(_ json: JSON) {
        self.type = json["type"].stringValue
        self.sourceID = json["source_id"].intValue
        self.date = json["date"].intValue
        let photos = json["photos"].self
        self.photos = Photos(photos)
        self.postID = json["post_id"].intValue
        self.text = json["text"].stringValue
        self.attachments = json["attachments"].arrayValue.map { Attachments($0) }
        self.copyhistory = json["copy_history"].arrayValue.map { ResponseItem($0) }
        let likes = json["likes"].self
        self.likes = Likes(likes)
        let repost = json["reposts"].self
        self.reposts = Reposts(repost)
        let comments = json["comments"].self
        self.comments = Comments(comments)
        let views = json["views"].self
        self.views = Views(views)
    }

}
/*
class Attachments22 {
    let id: Int
    let ownerID: Int
    let sizes: [Size]
    let text: String
    let date: Int
    let likes: Likes
    let reposts: Reposts
    let comments: Comments
    let views: Views
    
    init(id: Int, ownerID: Int, sizes: [Size], text: String, date: Int, likes: Likes, reposts: Reposts, comments: Comments, views: Views) {
        self.id = id
        self.ownerID = ownerID
        self.sizes = sizes
        self.text = text
        self.date = date
        self.likes = likes
        self.reposts = reposts
        self.comments = comments
        self.views = views
    }
    
    init(_ json: JSON) {
        self.id =  json["id"].intValue
        self.ownerID = json["ownerID"].intValue
        self.sizes = json["sizes"].arrayValue.map { Size($0) }
        self.text = json["text"].stringValue
        self.date = json["date"].intValue
        let likes = json["likes"].self
        self.likes = Likes(likes)
        let repost = json["reposts"].self
        self.reposts = Reposts(repost)
        let comments = json["comments"].self
        self.comments = Comments(comments)
        let views = json["views"].self
        self.views = Views(views)
    }
} */

class Attachments {
    let type: String
    let photo: AttachmentsPhoto
    
    init(type: String, photo: AttachmentsPhoto) {
        self.photo = photo
        self.type = type
    }
    
    init(_ json: JSON) {
        self.type = json["type"].stringValue
        let photo = json["photo"].self
        self.photo = AttachmentsPhoto(photo)
    }
    
}

class AttachmentsPhoto {
    let owner_id: Int
    let sizes: [Size]
    let text: String
    let date: Int
    
    init(_ json: JSON) {
        self.owner_id = json["owner_id"].intValue
        self.sizes = json["sizes"].arrayValue.map { Size($0) }
        self.text = json["text"].stringValue
        self.date = json["date"].intValue
    }
    
}

// MARK: - Photos
class Photos {
    let count: Int
    let items: [PhotosItem]
    
    init(count: Int, items: [PhotosItem]) {
        self.count = count
        self.items = items
    }
    
    init(_ json: JSON) {
        self.count = json["count"].intValue
        self.items = json["items"].arrayValue.map { PhotosItem($0) }
    }
}

// MARK: - PhotosItem
class PhotosItem {
    let id, albumID, ownerID, userID: Int
    let sizes: [Size]
    let text: String
    let date: Int
    let accessKey: String
    let likes: Likes
    let reposts: Reposts
    let comments: Comments
    let canComment, canRepost: Int
    let postID: Int?
    
    init(id: Int, albumID: Int, ownerID: Int, userID: Int, sizes: [Size], text: String, date: Int, accessKey: String, likes: Likes, reposts: Reposts, comments: Comments, canComment: Int, canRepost: Int, postID: Int?) {
        self.id = id
        self.albumID = albumID
        self.ownerID = ownerID
        self.userID = userID
        self.sizes = sizes
        self.text = text
        self.date = date
        self.accessKey = accessKey
        self.likes = likes
        self.reposts = reposts
        self.comments = comments
        self.canComment = canComment
        self.canRepost = canRepost
        self.postID = postID
    }
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.albumID = json["albumID"].intValue
        self.ownerID = json["ownerID"].intValue
        self.userID = json["userID"].intValue
        self.sizes = json["sizes"].arrayValue.map { Size($0) }
        self.text = json["text"].stringValue
        self.date = json[""].intValue
        let likes = json["likes"].self
        self.likes = Likes(likes)
        let repost = json["reposts"].self
        self.reposts = Reposts(repost)
        let comments = json["comments"].self
        self.comments = Comments(comments)
        self.accessKey = json["accessKey"].stringValue
        self.canComment = json["canComment"].intValue
        self.canRepost = json["canRepost"].intValue
        self.postID = json["postID"].intValue
    }
}

// MARK: - Size
class Size {
    let type: String
    let url: String
    let width, height: Int
    
    init(type: String, url: String, width: Int, height: Int) {
        self.type = type
        self.url = url
        self.width = width
        self.height = height
    }
    
    init(_ json: JSON) {
        self.type = json["type"].stringValue
        self.url = json["url"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
    }
    
}

// MARK: - Comments
class Comments {
    let count: Int
    
    init(count: Int) {
        self.count = count
    }
    
    init(_ json: JSON) {
        self.count = json["count"].intValue
    }
}

// MARK: - Likes
class Likes {
    let userLikes, count: Int
    
    init(userLikes: Int, count: Int) {
        self.userLikes = userLikes
        self.count = count
    }
    
    init(_ json: JSON) {
        self.userLikes = json["user_likes"].intValue
        self.count = json["count"].intValue
    }
}

// MARK: - Reposts
class Reposts {
    let count, userReposted: Int
    
    init(count: Int, userReposted: Int) {
        self.count = count
        self.userReposted = userReposted
    }
    
    init(_ json: JSON) {
        self.count = json["count"].intValue
        self.userReposted = json["count"].intValue
    }
}

// MARK: - Reposts
class Views {
    let count: Int
    
    init(count: Int) {
        self.count = count
    }
    
    init(_ json: JSON) {
        self.count = json["count"].intValue
    }
}











/*
// MARK: - The1
class The1: Codable {
    let response: VKResponse
    
    init(response: VKResponse) {
        self.response = response
    }
}

// MARK: - Response
class VKResponse: Codable {
    let items: [ResponseItem]
    let profiles: [FriendProfile]
    let groups: [NewsGroup]
    let nextFrom: String
    
    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
    
    init(items: [ResponseItem], profiles: [FriendProfile], groups: [NewsGroup], nextFrom: String) {
        self.items = items
        self.profiles = profiles
        self.groups = groups
        self.nextFrom = nextFrom
    }
}

// MARK: - Group
class NewsGroup: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: GroupType
    let isAdmin, isMember, isAdvertiser: Int
    let photo50, photo100, photo200: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
    
    init(id: Int, name: String, screenName: String, isClosed: Int, type: GroupType, isAdmin: Int, isMember: Int, isAdvertiser: Int, photo50: String, photo100: String, photo200: String) {
        self.id = id
        self.name = name
        self.screenName = screenName
        self.isClosed = isClosed
        self.type = type
        self.isAdmin = isAdmin
        self.isMember = isMember
        self.isAdvertiser = isAdvertiser
        self.photo50 = photo50
        self.photo100 = photo100
        self.photo200 = photo200
    }
}

enum GroupType: String, Codable {
    case group = "group"
    case page = "page"
}

// MARK: - ResponseItem
class ResponseItem: Codable {
    let type: ItemType
    let sourceID, date: Int
    let photos: Photos
    let postID: Int
    
    enum CodingKeys: String, CodingKey {
        case type
        case sourceID = "source_id"
        case date, photos
        case postID = "post_id"
    }
    
    init(type: ItemType, sourceID: Int, date: Int, photos: Photos, postID: Int) {
        self.type = type
        self.sourceID = sourceID
        self.date = date
        self.photos = photos
        self.postID = postID
    }
}

// MARK: - Photos
class Photos: Codable {
    let count: Int
    let items: [PhotosItem]
    
    init(count: Int, items: [PhotosItem]) {
        self.count = count
        self.items = items
    }
}

// MARK: - PhotosItem
class PhotosItem: Codable {
    let id, albumID, ownerID, userID: Int
    let sizes: [Size]
    let text: String
    let date: Int
    let accessKey: String
    let likes: Likes
    let reposts: Reposts
    let comments: Comments
    let canComment, canRepost: Int
    let postID: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case userID = "user_id"
        case sizes, text, date
        case accessKey = "access_key"
        case likes, reposts, comments
        case canComment = "can_comment"
        case canRepost = "can_repost"
        case postID = "post_id"
    }
    
    init(id: Int, albumID: Int, ownerID: Int, userID: Int, sizes: [Size], text: String, date: Int, accessKey: String, likes: Likes, reposts: Reposts, comments: Comments, canComment: Int, canRepost: Int, postID: Int?) {
        self.id = id
        self.albumID = albumID
        self.ownerID = ownerID
        self.userID = userID
        self.sizes = sizes
        self.text = text
        self.date = date
        self.accessKey = accessKey
        self.likes = likes
        self.reposts = reposts
        self.comments = comments
        self.canComment = canComment
        self.canRepost = canRepost
        self.postID = postID
    }
}

// MARK: - Comments
class Comments: Codable {
    let count: Int
    
    init(count: Int) {
        self.count = count
    }
}

// MARK: - Likes
class Likes: Codable {
    let userLikes, count: Int
    
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
    
    init(userLikes: Int, count: Int) {
        self.userLikes = userLikes
        self.count = count
    }
}

// MARK: - Reposts
class Reposts: Codable {
    let count, userReposted: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
    
    init(count: Int, userReposted: Int) {
        self.count = count
        self.userReposted = userReposted
    }
}

// MARK: - Size
class Size: Codable {
    let type: SizeType
    let url: String
    let width, height: Int
    
    init(type: SizeType, url: String, width: Int, height: Int) {
        self.type = type
        self.url = url
        self.width = width
        self.height = height
    }
}

enum SizeType: String, Codable {
    case m = "m"
    case o = "o"
    case p = "p"
    case q = "q"
    case r = "r"
    case s = "s"
    case w = "w"
    case x = "x"
    case y = "y"
    case z = "z"
}

enum ItemType: String, Codable {
    case wallPhoto = "wall_photo"
}


*/
