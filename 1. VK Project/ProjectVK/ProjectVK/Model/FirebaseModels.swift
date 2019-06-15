//
//  FirebaseModels.swift
//  ProjectVK
//
//  Created by Igor on 15/06/2019.
//  Copyright © 2019 Igorlab. All rights reserved.
//

import Foundation
import Firebase

struct FirebaseGroupsRequests {
    let userId: Int
    let groupRequest: String
    
    let ref: DatabaseReference?
    
    init(userId: Int, groupRequest: String) {
        self.userId = userId
        self.groupRequest = groupRequest
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
            let userId = value["userId"] as? Int,
            let groupRequest = value["groupRequest"] as? String else { return nil }
        
        self.userId = userId
        self.groupRequest = groupRequest
        self.ref = snapshot.ref
        
    }
    
    func toAnyObject() -> [String: Any] {
        return ["userId": userId, "groupRequest": groupRequest]
    }
    
}


struct FirebaseUserAutorisation {
    let userId: Int
    
    let ref: DatabaseReference?
    
    init(userId: Int) {
        self.userId = userId
        self.ref = nil
    }
    
    init?(snapshot: DataSnapshot) {
        guard let value = snapshot.value as? [String: Any],
            let userId = value["userId"] as? Int else { return nil }
        
        self.userId = userId
        self.ref = snapshot.ref
        
    }
    
    func toAnyObject() -> [String: Any] {
        return ["userId": userId]
    }
    
}
