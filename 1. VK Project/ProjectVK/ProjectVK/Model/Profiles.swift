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

class FriendProfile: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var lastname: String = ""
    @objc dynamic var avatarImage: String = ""
    
    convenience init(id: Int, name: String, lastname: String, avatarImage: String) {
        self.init()
        self.id = id
        self.name = name
        self.lastname = lastname
        self.avatarImage = avatarImage
    }
    
    convenience init(_ json: JSON) {
        self.init()
        
        self.id = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.lastname = json["last_name"].stringValue
        self.avatarImage = json["photo_200_orig"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    
}

class FriendProfilePhoto: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var ownerid: Int = 0
    @objc dynamic var photo: String = ""
    
    convenience init(id: Int, ownerid: Int, photo: String) {
        self.init()
        self.id = id
        self.ownerid = ownerid
        self.photo = photo
    }
    
    convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.ownerid = json["owner_id"].intValue
        let sizes = json["sizes"].arrayValue.count
        self.photo = json["sizes"][sizes - 1]["url"].stringValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
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
 
