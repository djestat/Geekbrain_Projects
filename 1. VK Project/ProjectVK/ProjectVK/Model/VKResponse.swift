//
//  VKResponse.swift
//  ProjectVK
//
//  Created by Igor on 21/06/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import SwiftyJSON

class ErrorRequest {
    let errorCode: Int
    let errorMsg: String
    
    init(errorCode: Int, errorMsg: String) {
        self.errorCode = errorCode
        self.errorMsg = errorMsg
    }
    
    init(_ json: JSON) {
        self.errorCode = json["error_code"].intValue
        self.errorMsg = json["error_msg"].stringValue
    }
}

class Response {
    let response: Int
    
    init(response: Int) {
        self.response = response
    }
    
    init(_ json: JSON) {
        self.response = json["response"].intValue
    }
}
