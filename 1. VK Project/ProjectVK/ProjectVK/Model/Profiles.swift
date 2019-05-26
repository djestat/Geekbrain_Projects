//
//  Profiles.swift
//  ProjectVK
//
//  Created by Igor on 08/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

class FriendProfile {
    let userid: Int
    let name: String
    let lastname: String
    let avatarImage: String
    
    init(userid: Int, name: String, lastname: String, avatarImage: String) {
        self.userid = userid
        self.name = name
        self.lastname = lastname
        self.avatarImage = avatarImage
    }
    
    init(_ json: JSON) {
        self.userid = json["id"].intValue
        self.name = json["first_name"].stringValue
        self.lastname = json["last_name"].stringValue
        self.avatarImage = json["photo_200_orig"].stringValue
    }
    
    
}

struct FriendProfilePhoto {
    let userid: Int
    let photo: String
    
    init(_ json: JSON) {
        self.userid = json["owner_id"].intValue
        self.photo = json["sizes"][3]["url"].stringValue
    }
    
}
