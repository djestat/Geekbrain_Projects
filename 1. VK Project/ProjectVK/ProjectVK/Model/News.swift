//
//  News.swift
//  ProjectVK
//
//  Created by Igor on 26/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class NewsRealm: Object {
    @objc dynamic var postID: Int = 0
    @objc dynamic var postType: String = ""
    @objc dynamic var sourceID: Int = 0
    @objc dynamic var sourceName: String = ""
    @objc dynamic var sourcePhoto: String = ""
    @objc dynamic var sourceText: String = ""
    @objc dynamic var attachmentPhoto: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var reposts: Int = 0
    @objc dynamic var comments: Int = 0
    @objc dynamic var views: Int = 0
    @objc dynamic var nextList: String = ""
    
    convenience init(postID: Int, postType: String, sourceID: Int, sourceName: String, sourcePhoto: String, sourceText: String, attachmentPhoto: String, likes: Int, reposts: Int, comments: Int, views: Int, nextList: String) {
        self.init()
        self.postID = postID
        self.postType = postType
        self.sourceID = sourceID
        self.sourceName = sourceName
        self.sourcePhoto = sourcePhoto
        self.sourceText = sourceText
        self.attachmentPhoto = attachmentPhoto
        self.likes = likes
        self.reposts = reposts
        self.comments = comments
        self.views = views
        self.nextList = nextList
    }
    
    convenience init(_ json: JSON) {
        self.init()
        self.postID = json[""].intValue
        self.postType = json[""].stringValue
        self.sourceID = json[""].intValue
        self.sourceName = json[""].stringValue
        self.sourcePhoto = json[""].stringValue
        self.sourceText = json[""].stringValue
        self.attachmentPhoto = json[""].stringValue
        self.likes = json[""].intValue
        self.reposts = json[""].intValue
        self.comments = json[""].intValue
        self.views = json[""].intValue
        self.nextList = json[""].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

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
    let attachmetsCount: Int
    let attachments: [Attachments]
    let copyhistory: [CopyHistory]
    let likes: Likes
    let reposts: Reposts
    let comments: Comments
    let views: Views
    
    init(type: String, sourceID: Int, date: Int, photos: Photos, postID: Int, text: String, attachmetsCount: Int, attachments: [Attachments], copyhistory: [CopyHistory], likes: Likes, reposts: Reposts, comments: Comments, views: Views) {
        self.type = type
        self.sourceID = sourceID
        self.date = date
        self.photos = photos
        self.postID = postID
        self.text = text
        self.attachmetsCount = attachmetsCount
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
        self.attachmetsCount = json["attachments"].count
        self.attachments = json["attachments"].arrayValue.map { Attachments($0) }
        self.copyhistory = json["copy_history"].arrayValue.map { CopyHistory($0) }
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

class CopyHistory {
    let id: Int
    let ownerID: Int
    let fromID: Int
    let postType: String
    let text: String
    let attachments: [Attachments]
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.ownerID = json["owner_id"].intValue
        self.fromID = json["from_id"].intValue
        self.postType = json["post_type"].stringValue
        self.text = json["text"].stringValue
        self.attachments = json["attachments"].arrayValue.map { Attachments($0) }
    }
}

class Attachments {
    let type: String
    let photo: AttachmentsPhotos
    let doc: AttachmentsDoc
    let video: AttachmentsVideo
    let link: AttachmentsLink
    
    init(_ json: JSON) {
        self.type = json["type"].stringValue
        let photo = json["photo"].self
        self.photo = AttachmentsPhotos(photo)
        let doc = json["doc"].self
        self.doc = AttachmentsDoc(doc)
        let video = json["video"].self
        self.video = AttachmentsVideo(video)
        let link = json["link"].self
        self.link = AttachmentsLink(link)
    }
    
}

class AttachmentsPhotos {
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

class AttachmentsDoc {
    let id: Int
    let ownerID: Int
    let title: String
    let size: Int
    let ext: String
    let url: String
    let date: Int
    let type: Int
    let preview: DocPreview
    
    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.ownerID = json["owner_id"].intValue
        self.title = json["title"].stringValue
        self.size = json["size"].intValue
        self.ext = json["ext"].stringValue
        self.url = json["url"].stringValue
        self.date = json["date"].intValue
        self.type = json["type"].intValue
        let preview = json["preview"].self
        self.preview = DocPreview(preview)
    }
}

class DocPreview {
    let photo: Sizes
    let video: Video
    
    init(_ json: JSON) {
        let photo = json["photo"].self
        self.photo = Sizes(photo)
        let video = json["video"].self
        self.video = Video(video)
    }
}

class Sizes {
    let sizes: [Size]
    
    init(_ json: JSON) {
        self.sizes = json["sizes"].arrayValue.map { Size($0) }
    }
}
    

class AttachmentsVideo {
    let id: Int
    let ownerID: Int
    let title: String
    let duration: Int
    let width: Int
    let height: Int
    let photo130: String
    let photo320: String
    let photo800: String
    let photo1280: String
    let accessKey: String
    let trackCode: String
    let type: String

    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.ownerID = json["owner_id"].intValue
        self.title = json["title"].stringValue
        self.duration = json["duration"].intValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        self.photo130 = json["photo_130"].stringValue
        self.photo320 = json["photo_320"].stringValue
        self.photo800 = json["photo_800"].stringValue
        self.photo1280 = json["photo_1280"].stringValue
        self.accessKey = json["access_key"].stringValue
        self.trackCode = json["track_code"].stringValue
        self.type = json["type"].stringValue
    }
}

class AttachmentsLink {
    let url: String
    let title: String
    let caption: String
    let description: String
    let photo: PhotosItem
    
    init(_ json: JSON) {
        self.url = json["url"].stringValue
        self.title = json["title"].stringValue
        self.caption = json["caption"].stringValue
        self.description = json["descriptio"].stringValue
        let photo = json["photo"].self
        self.photo = PhotosItem(photo)
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
    let src: String
    let type: String
    let url: String
    let width, height: Int
    
    init(src: String, type: String, url: String, width: Int, height: Int) {
        self.src = src
        self.type = type
        self.url = url
        self.width = width
        self.height = height
    }
    
    init(_ json: JSON) {
        self.src = json["src"].stringValue
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
 "type": "doc",
 "doc": {
        "id": 445414136,
        "owner_id": 18919286,
        "title": "fitnesshouse1.gif",
        "size": 2724172,
        "ext": "gif",
        "url": "https://vk.com/do...ed&no_preview=1",
        "date": 1495010108,
        "type": 3,
        "preview": {
                    "photo": {
                    "sizes": [{
                                "src": "https://cs540107....-3/m_13128e0512.jpg",
                               "width": 130,
                               "height": 90,
                               "type": "m"
                               }, {
                               "src": "https://cs540107....-3/s_13128e0512.jpg",
                               "width": 100,
                               "height": 69,
                               "type": "s"
                               }, {
                               "src": "https://cs540107....-3/x_13128e0512.jpg",
                               "width": 604,
                               "height": 415,
                               "type": "x"
                               }, {
                               "src": "https://cs540107....-3/y_13128e0512.jpg",
                               "width": 807,
                               "height": 555,
                               "type": "y"
                               }, {
                               "src": "https://cs540107....-3/o_13128e0512.jpg",
                               "width": 852,
                               "height": 585,
                               "type": "o"
                               }]
                                },
                    "video": {
                    "src": "https://vk.com/do...4=1&module=feed",
                    "width": 852,
                    "height": 584,
                    "file_size": 280916
                    }
        },
 "access_key": "8d58368c3c99183047"
 }







*/
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
