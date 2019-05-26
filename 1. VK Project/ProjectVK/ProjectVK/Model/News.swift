//
//  News.swift
//  ProjectVK
//
//  Created by Igor on 26/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

struct News {
    
//    let groupImage: String
    let groupName: Int
    let newsPhotos: String
    let likeCounts: Int
    let commentsCount: Int
    let viewsCounts: Int
    let textNews: String
    
    init(_ json: JSON) {
//        self.groupImage = json["type"].stringValue
        self.groupName = json["source_id"].intValue
        self.newsPhotos = json["attachments"][0]["photo"]["sizes"][3]["url"].stringValue
        self.likeCounts = json["likes"]["count"].intValue
        self.commentsCount = json["comments"]["count"].intValue
        self.viewsCounts = json["views"]["count"].intValue
        self.textNews = json["text"].stringValue
        
    }
    
}

/*
 
 "type": "post",
 "source_id": -57846937,
 "date": 1558902300,
 "post_type": "post",
 "text": "",
 "marked_as_ads": 0,
 "attachments": [{...}],
 "post_source": {
                "type": "vk"
                            },
                            "comments": {
                                        "count": 11,
                                        "can_post": 1,
                                        "groups_can_post": true
                            },
                            "likes": {
                                        "count": 39,
                                        "user_likes": 0,
                                        "can_like": 1,
                                        "can_publish": 1
                            },
                            "reposts": {
                                        "count": 0,
                                        "user_reposted": 0
                            },
                            "views": {
                                        "count": 1778
 },
 "is_favorite": false,
 "post_id": 30247551 */
