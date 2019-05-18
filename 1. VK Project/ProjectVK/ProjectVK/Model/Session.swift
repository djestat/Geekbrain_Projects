//
//  Session.swift
//  ProjectVK
//
//  Created by Igor on 18/05/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation

class Session {
    private init() { }
    
    public static let sessionVK = Session()
    
    var token: String = ""
    var userid: Int = 0
    
}
