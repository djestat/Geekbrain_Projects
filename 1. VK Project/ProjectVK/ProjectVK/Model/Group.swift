//
//  Groups.swift
//  ProjectVK
//
//  Created by Igor on 08/04/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Group {
    let groupName: String
    let groupImage: String
    
    init(_ json: JSON) {
        self.groupName = json["name"].stringValue
        self.groupImage = json["photo_200"].stringValue
    }
}
