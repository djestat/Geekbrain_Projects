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
    @objc dynamic var groupName: String = ""
    @objc dynamic var groupImage: String = ""
    
    convenience init(_ json: JSON) {
        self.init()
        
        self.groupName = json["name"].stringValue
        self.groupImage = json["photo_200"].stringValue
    }
}

