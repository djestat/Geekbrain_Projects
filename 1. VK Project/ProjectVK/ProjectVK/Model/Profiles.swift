//
//  Profiles.swift
//  ProjectVK
//
//  Created by Igor on 08/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

struct MyFriend {
    let name: String
    let avatarImage: String
}

class FriendProfile {
    let userid: Int
    let name: String
    let avatarImage: String
    
    init(userid: Int, name: String, avatarImage: String) {
        self.userid = userid
        self.name = name
        self.avatarImage = avatarImage
    }
    
    init(_ json: JSON) {
        self.userid = json["id"].intValue
        self.name = String(json["first_name"].stringValue + " " + json["last_name"].stringValue)
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

/*
"response": {
    "count": 11,
    "items": [{
                "id": 354621649,
                "album_id": -6,
                "owner_id": 35436,
                "sizes": [{
                        "type": "m",
                        "url": "https://pp.userap...9a0/xWmk-pf1ZgQ.jpg",
                        "width": 130,
                        "height": 130
                        }, {
                        "type": "o
*/
