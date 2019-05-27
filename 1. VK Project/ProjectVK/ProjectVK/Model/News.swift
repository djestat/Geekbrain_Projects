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

