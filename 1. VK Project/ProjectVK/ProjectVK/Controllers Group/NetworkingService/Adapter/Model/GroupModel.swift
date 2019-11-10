//
//  GroupModel.swift
//  ProjectVK
//
//  Created by Igor on 10.11.2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation

class Group {
    let id: Int
    let name: String
    let image: String
    let isMember: Int
    
    init(id: Int, groupName: String, groupImage: String, isMember: Int) {
        self.id = id
        self.name = groupName
        self.image = groupImage
        self.isMember = isMember
    }
}
