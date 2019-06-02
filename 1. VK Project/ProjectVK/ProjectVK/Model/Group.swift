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

class Group: Object {
    @objc dynamic var id: Int = 0
    @objc dynamic var groupName: String = ""
    @objc dynamic var groupImage: String = ""
    
    convenience init(id: Int, groupName: String, groupImage: String) {
        self.init()
        self.id = id
        self.groupName = groupName
        self.groupImage = groupImage
    }
    
    convenience init(_ json: JSON) {
        self.init()
        self.id = json["id"].intValue
        self.groupName = json["name"].stringValue
        self.groupImage = json["photo_200"].stringValue
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
