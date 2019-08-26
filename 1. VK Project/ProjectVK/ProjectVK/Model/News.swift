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
    @objc dynamic var date: Int = 0
    @objc dynamic var newsType: String = ""
    @objc dynamic var sourceID: Int = 0
    @objc dynamic var sourceName: String = ""
    @objc dynamic var sourcePhoto: String = ""
    @objc dynamic var postText: String = ""
    @objc dynamic var photo: String = ""
    @objc dynamic var attachmentsType: String = ""
    @objc dynamic var attachmentsUrl: String = ""
    @objc dynamic var photoAspectRatio: Double = 1.0
    @objc dynamic var likes: Int = 0
    @objc dynamic var reposts: Int = 0
    @objc dynamic var comments: Int = 0
    @objc dynamic var views: Int = 0
    @objc dynamic var nextList: String = ""
    
    convenience init(postID: Int, date: Int, newsType: String, sourceID: Int, sourceName: String, sourcePhoto: String, postText: String, photo: String, attachmentsType: String, attachmentsUrl: String, photoAspectRatio: Double, likes: Int, reposts: Int, comments: Int, views: Int, nextList: String) {
        self.init()
        self.postID = postID
        self.date = date
        self.newsType = newsType
        self.sourceID = sourceID
        self.sourceName = sourceName
        self.sourcePhoto = sourcePhoto
        self.postText = postText
        self.photo = photo
        self.attachmentsType = attachmentsType
        self.attachmentsUrl = attachmentsUrl
        self.photoAspectRatio = photoAspectRatio
        self.likes = likes
        self.reposts = reposts
        self.comments = comments
        self.views = views
        self.nextList = nextList
    }
        
    override static func primaryKey() -> String? {
        return "postID"
    }
}

class News {
    let items: [ResponseItem]
    let profiles: [FriendProfile]
    let groups: [Group]
    let nextFrom: String
    
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
    
// MARK: - Video

class AttachmentsVideo {
    let id: Int
    let ownerID: Int
    let title: String
    let duration: Int
    let description: String
    let date: Int
    let comments: Int
    let views: Int
    let width: Int
    let height: Int
    let image: [VideoImage]
    let isFavorite: Bool
    let firstFrame: [VideoFistFrame]
    let accessKey: String
    let repeatCount: Int
    let canAdd: Int
    let trackCode: String
    let type: String

    init(_ json: JSON) {
        self.id = json["id"].intValue
        self.ownerID = json["owner_id"].intValue
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.date = json["date"].intValue
        self.comments = json["comments"].intValue
        self.views = json["views"].intValue
        self.duration = json["duration"].intValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        self.image = json["image"].arrayValue.map { VideoImage($0) }
        self.isFavorite = json["is_favorite"].boolValue
        self.firstFrame = json["image"].arrayValue.map { VideoFistFrame($0) }
        self.accessKey = json["access_key"].stringValue
        self.repeatCount = json["repeat"].intValue
        self.canAdd = json["can_add"].intValue
        self.trackCode = json["track_code"].stringValue
        self.type = json["type"].stringValue
    }
}

class VideoImage {
    let url: String
    let width: Int
    let height: Int
    let withPadding: Int
    
    init (_ json: JSON) {
        self.url = json["url"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
        self.withPadding = json["with_padding"].intValue

    }
}

class VideoFistFrame {
    let url: String
    let width: Int
    let height: Int
    
    init (_ json: JSON) {
        self.url = json["url"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
    }
}

// MARK: - Link

class AttachmentsLink {
    let url: String
    let title: String
    let caption: String
    let description: String
    let photo: PhotosItem
    let previewArticle: LinkPreviewArticle
    let isFavorite: Bool
    
    init(_ json: JSON) {
        self.url = json["url"].stringValue
        self.title = json["title"].stringValue
        self.caption = json["caption"].stringValue
        self.description = json["descriptio"].stringValue
        let photo = json["photo"].self
        self.photo = PhotosItem(photo)
        let previewArticle = json["preview_article"].self
        self.previewArticle = LinkPreviewArticle(previewArticle)
        self.isFavorite = json["photo"].boolValue
    }
}

class LinkPreviewArticle {
    let id: Int
    let ownerID: Int
    let ownerName: String
    let ownerPhoto: String
    let state: String
    let canReport: Bool
    let title: String
    let subtitle: String
    let views: Int
    let shares: Int
    let isFavorite: Bool
    let url: String
    let viewUrl: String
    let accessKey: String
    let publishedDate: Int
    let photo: PhotosItem

    init (_ json: JSON) {
        self.id = json["id"].intValue
        self.ownerID = json["owner_id"].intValue
        self.ownerName = json["owner_name"].stringValue
        self.ownerPhoto = json["owner_photo"].stringValue
        self.state = json["state"].stringValue
        self.canReport = json["can_report"].boolValue
        self.title = json["title"].stringValue
        self.subtitle = json["subtitle"].stringValue
        self.views = json["views"].intValue
        self.shares = json["shares"].intValue
        self.isFavorite = json["is_favorite"].boolValue
        self.url = json["url"].stringValue
        self.viewUrl = json["view_url"].stringValue
        self.accessKey = json["access_key"].stringValue
        self.publishedDate = json["published_date"].intValue
        let photo = json["photo"].self
        self.photo = PhotosItem(photo)
    }
    
}

// MARK: - Photos
class Photos {
    let count: Int
    let items: [PhotosItem]
    
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
    let postID: Int
    
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
    let width: Int
    let height: Int
    
    init(_ json: JSON) {
        self.src = json["src"].stringValue
        self.type = json["type"].stringValue
        self.url = json["url"].stringValue
        self.width = json["width"].intValue
        self.height = json["height"].intValue
    }
    
}

enum SizeType: String {
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

/*
 
 "type": "s",
 "type": "m",
 "type": "o",
 "type": "p",
 "type": "q",
 "type": "r",
 "type": "w",
 "type": "x",
 "type": "y",
 "type": "z",
 
 "type": "s",
 "width": 63,
 "height": 75
 }, {
 "sizes": [{
 "type": "m",
 "width": 110,
 "height": 130
 }, {
 "type": "o",
 "width": 130,
 "height": 154
 }, {
 "type": "p",
 "width": 200,
 "height": 236
 }, {
 "type": "q",
 "width": 320,
 "height": 378
 }, {
 "type": "r",
 "width": 510,
 "height": 603
 }
 "type": "x",
 "width": 511,
 "height": 604
 }, {
 "type": "y",
 "width": 683,
 "height": 807
 }, {
 "type": "z",
 "width": 812,
 "height": 960
 }, {

 [{
 "type": "s",
 "width": 67,
 "height": 75
 }, {
 "type": "m",
 "width": 117,
 "height": 130
 }, {
 "type": "o",
 "width": 130,
 "height": 145
 }, {
 "type": "p",
 "width": 200,
 "height": 223
 }, {
 "type": "q",
 "width": 320,
 "height": 357
 }, {
 "type": "r",
 "width": 510,
 "height": 568
 }, {
 "type": "x",
 "width": 542,
 "height": 604
 }, {
 "type": "y",
 "width": 724,
 "height": 807
 }, {
 "type": "z",
 "width": 829,
 "height": 924
 }],
 
 */


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

/*
 
 , {
 "type": "wall_photo",
 "source_id": -15755094,
 "date": 1495094448,
 "photos": {
 "count": 29,
 "items": [{
 "id": 456512246,
 "album_id": -7,
 "owner_id": -15755094,
 "user_id": 100,
 "photo_75": "https://pp.userap...cc9/7UaJOFYQ4t8.jpg",
 "photo_130": "https://pp.userap...cca/EAjkANRXxa8.jpg",
 "photo_604": "https://pp.userap...ccb/KwNeUd4zZj8.jpg",
 "photo_807": "https://pp.userap...ccc/G5WXBGhwcfY.jpg",
 "photo_1280": "https://pp.userap...ccd/nnHrhvWIFv0.jpg",
 "width": 1036,
 "height": 588,
 "text": "В Турции перевернулся микроавтобус с российскими туристами: https://ria.ru/world/20170518/1494542911.html",
 "date": 1495094448,
 "post_id": 16044279,
 "access_key": "e2ebfef470360df391",
 "likes": {
 "user_likes": 0,
 "count": 28
 },
 "comments": {
 "count": 25
 },
 "can_comment": 1,
 "can_repost": 1
 }, {
 "id": 456512227,
 "album_id": -7,
 "owner_id": -15755094,
 "user_id": 100,
 "photo_75": "https://pp.userap...ca9/-Y9q2O4VhX4.jpg",
 "photo_130": "https://pp.userap...caa/jleL-s_dg64.jpg",
 "photo_604": "https://pp.userap...cab/2avDkMG7dDs.jpg",
 "photo_807": "https://pp.userap...cac/s-d0WlUUxl4.jpg",
 "photo_1280": "https://pp.userap...cad/0QfNR0cLOk4.jpg",
 "width": 1024,
 "height": 681,
 "text": "В Минюсте назвали условия, при которых могут изъять единственное жилье: https://ria.ru/society/20170518/1494537882.html",
 "date": 1495093185,
 "post_id": 16044070,
 "access_key": "c1c55079beae811832",
 "likes": {
 "user_likes": 0,
 "count": 50
 },
 "comments": {
 "count": 45
 },
 "can_comment": 1,
 "can_repost": 1
 }, {
 "id": 456512215,
 "album_id": -7,
 "owner_id": -15755094,
 "user_id": 100,
 "photo_75": "https://pp.userap...ca1/Rj_iDRRUMAE.jpg",
 "photo_130": "https://pp.userap...ca2/aMocKsWPris.jpg",
 "photo_604": "https://pp.userap...ca3/0Y0cNSBq2Y4.jpg",
 "photo_807": "https://pp.userap...ca4/7nvn1-pcOv8.jpg",
 "width": 640,
 "height": 363,
 "text": "СМИ назвали главных фигурантов дела о "вмешательстве" России в выборы США: https://ria.ru/world/20170518/1494535783.html",
 "date": 1495092020,
 "post_id": 16043872,
 "access_key": "0e6c161b36ed7c7c42",
 "likes": {
 "user_likes": 0,
 "count": 55
 },
 "comments": {
 "count": 41
 },
 "can_comment": 1,
 "can_repost": 1
 }, {
 "id": 456512194,
 "album_id": -7,
 "owner_id": -15755094,
 "user_id": 100,
 "photo_75": "https://pp.userap...c98/ZwbJUSVwgcg.jpg",
 "photo_130": "https://pp.userap...c99/oBsBFHcRxh4.jpg",
 "photo_604": "https://pp.userap...c9a/vdkQneuX6Ew.jpg",
 "photo_807": "https://pp.userap...c9b/SiCac1pGUPc.jpg",
 "photo_1280": "https://pp.userap...c9c/L14TwTg9hGg.jpg",
 "width": 1024,
 "height": 682,
 "text": "В Крыму сожалеют, что Порошенко решил стать "командиром евродепутатов": https://ria.ru/world/20170518/1494534733.html",
 "date": 1495090754,
 "post_id": 16043539,
 "access_key": "90217a2c844d212995",
 "likes": {
 "user_likes": 0,
 "count": 105
 },
 "comments": {
 "count": 77
 },
 "can_comment": 1,
 "can_repost": 1
 }, {
 "id": 456512140,
 "album_id": -7,
 "owner_id": -15755094,
 "user_id": 100,
 "photo_75": "https://pp.userap...c87/2iipmzJRbQw.jpg",
 "photo_130": "https://pp.userap...c88/Hc-FSwnu0w8.jpg",
 "photo_604": "https://pp.userap...c89/FO6xp0uiyKE.jpg",
 "photo_807": "https://pp.userap...c8a/OdZ5hIUXpbI.jpg",
 "photo_1280": "https://pp.userap...c8b/z9c2finpZLk.jpg",
 "width": 1024,
 "height": 682,
 "text": "В США приняли законопроект, обвиняющий Россию в "бомбардировках сирийцев": https://ria.ru/syria/20170518/1494528207.html",
 "date": 1495088042,
 "post_id": 16042970,
 "access_key": "b96ee637e0210a9f74",
 "likes": {
 "user_likes": 0,
 "count": 98
 },
 "comments": {
 "count": 265
 },
 "can_comment": 1,
 "can_repost": 1
 }]
 },
 "post_id": 1495054800
 
 */
