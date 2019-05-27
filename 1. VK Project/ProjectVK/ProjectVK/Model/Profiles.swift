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
    @objc dynamic var userid: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var lastname: String = ""
    @objc dynamic var avatarImage: String = ""
    
    /*init(userid: Int, name: String, lastname: String, avatarImage: String) {
        self.userid = userid
        self.name = name
        self.lastname = lastname
        self.avatarImage = avatarImage
    }*/
    
    convenience init(_ json: JSON) {
        self.init()
        
        self.userid = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.lastname = json["last_name"].stringValue
        self.avatarImage = json["photo_200_orig"].stringValue
    }
    
}

class FriendProfilePhoto: Object {
    @objc dynamic var userid: Int = 0
    @objc dynamic var photo: String = ""
    
    convenience init(_ json: JSON) {
        self.init()
        self.userid = json["owner_id"].intValue
        self.photo = json["sizes"][3]["url"].stringValue
    }
    
}
