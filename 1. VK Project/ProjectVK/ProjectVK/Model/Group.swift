//
//  Groups.swift
//  ProjectVK
//
//  Created by Igor on 08/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class REALMGroup: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var image: String = ""
    @objc dynamic var isMember: Int = 0
    
    convenience init(id: Int, groupName: String, groupImage: String, isMember: Int) {
        self.init()
        self.id = id
        self.name = groupName
        self.image = groupImage
        self.isMember = isMember
    }
    
    convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.name = json["name"].stringValue
        self.image = json["photo_200"].stringValue
        self.isMember = json["is_member"].intValue
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}


/*
class Group: Codable {
    let id: Int
    let name, screenName: String
    let isClosed: Int
    let type: GroupType
    let isAdmin, isMember, isAdvertiser: Int
    let photo50, photo100, photo200: String
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName
        case isClosed
        case type
        case isAdmin
        case isMember
        case isAdvertiser
        case photo50
        case photo100
        case photo200
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
*/
