//
//  Profiles.swift
//  ProjectVK
//
//  Created by Igor on 08/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class REALMFriendProfile: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var lastname: String = ""
    @objc dynamic var avatarGroupImage: String = ""
    @objc dynamic var avatarImage: String = ""
    @objc dynamic var online: Int = 0
    let photos = List<REALMFriendPhoto>()
    
    convenience init(id: Int, name: String, lastname: String, avatarImage: String, online: Int, photos:[REALMFriendPhoto] = []) {
        self.init()
        self.id = id
        self.name = name
        self.lastname = lastname
        self.avatarImage = avatarImage
        self.online = online
        self.photos.append(objectsIn: photos)
    }
    
    convenience init(_ json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.lastname = json["last_name"].stringValue
        self.avatarGroupImage = json["photo_100"].stringValue
        self.avatarImage = json["photo_200_orig"].stringValue
        self.online = json["online"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    override static func ignoredProperties() -> [String] {
//        return ["online"]
//    }
    
}

class REALMFriendPhoto: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerid: Int = 0
    @objc dynamic var photo: String = ""
    @objc dynamic var likes: Int = 0
    @objc dynamic var isLiked: Int = 0
    let owner = LinkingObjects(fromType: REALMFriendProfile.self, property: "photos")
    
    convenience init(id: Int, ownerid: Int, photo: String, likes: Int, isLiked: Int) {
        self.init()
        self.id = id
        self.ownerid = ownerid
        self.photo = photo
        self.likes = likes
        self.isLiked = isLiked
    }
    
    convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.ownerid = json["owner_id"].intValue
        let sizes = json["sizes"].arrayValue.count
        self.photo = json["sizes"][sizes - 1]["url"].stringValue
        self.likes = json["likes"]["count"].intValue
        self.isLiked = json["likes"]["user_likes"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    override static func ignoredProperties() -> [String] {
//        return ["likes", "isLiked"]
//    }
    
}



/*
 "id": 456244681,
 "album_id": -6,
 "owner_id": 2644744,
 "sizes": [...],
 "text": "",
 "date": 1558817427,
 "post_id": 1650
 */

/*
 "items": [{
 "id": 376599151,
 "album_id": -6,
 "owner_id": 1,
 "sizes": [...],
 "text": "",
 "date": 1438687279,
 "likes": {
    "user_likes": 0,
    "count": 82810
 },
 "real_offset": 0
 */

/*
// MARK: - Profile
class Profile: Codable {
    let id: Int
    let firstName, lastName: String
    let isClosed, canAccessClosed: Bool
    let sex: Int
    let screenName: String
    let photo50, photo100: String
    let online: Int
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName
        case lastName
        case isClosed
        case canAccessClosed
        case sex
        case screenName
        case photo50
        case photo100
        case online
    }
    
    init(id: Int, firstName: String, lastName: String, isClosed: Bool, canAccessClosed: Bool, sex: Int, screenName: String, photo50: String, photo100: String, online: Int) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.isClosed = isClosed
        self.canAccessClosed = canAccessClosed
        self.sex = sex
        self.screenName = screenName
        self.photo50 = photo50
        self.photo100 = photo100
        self.online = online
    }
} */
 
